library dart_mavlink;

import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Policy for handling unsigned or incorrectly signed packets
enum SignatureAcceptPolicy {
  /// Accept only correctly signed packets
  signedOnly,

  /// Accept unsigned packets but reject incorrectly signed packets
  acceptUnsigned,

  /// Accept all packets (no signature verification)
  acceptAll,
}

/// Configuration for MAVLink message signing
class MavlinkSignatureConfig {
  /// 32-byte secret key for signature generation/verification
  final Uint8List secretKey;

  /// Link ID for this communication channel
  final int linkId;

  /// Policy for accepting unsigned/incorrectly signed packets
  final SignatureAcceptPolicy acceptPolicy;

  MavlinkSignatureConfig({
    required this.secretKey,
    required this.linkId,
    this.acceptPolicy = SignatureAcceptPolicy.signedOnly,
  }) {
    if (secretKey.length != 32) {
      throw ArgumentError('Secret key must be exactly 32 bytes');
    }

    if (linkId < 0 || linkId > 255) {
      throw ArgumentError('Link ID must be 0-255');
    }
  }
}

/// Manages MAVLink message signing and verification
class MavlinkSignatureManager {
  static const int _signatureLength = 6;

  final MavlinkSignatureConfig config;

  /// Current 48-bit signing timestamp (in 100 microsecond units per MAVLink spec)
  int _currentTimestamp = 0;

  /// Last seen timestamps by "sysId:compId:linkId"
  final Map<String, int> _lastTimestamps = <String, int>{};

  MavlinkSignatureManager(this.config) {
    // Initialise from real wall-clock time so the very first outgoing
    // timestamp is in the expected range for remote peers.
    _currentTimestamp =
        DateTime.now().microsecondsSinceEpoch ~/ 10 & 0xFFFFFFFFFFFF;
  }

  /// Optional setter if you want to resume from a stored value.
  void setInitialTimestamp(int value) {
    _currentTimestamp = value & 0xFFFFFFFFFFFF;
  }

  /// Returns a monotonically-increasing 48-bit timestamp (100 µs units)
  /// and advances the internal counter.
  int generateTimestamp() {
    // Always move forward relative to wall-clock time so reconnects do not
    // cause the counter to go backwards.
    final int now =
        DateTime.now().microsecondsSinceEpoch ~/ 10 & 0xFFFFFFFFFFFF;
    if (now > _currentTimestamp) {
      _currentTimestamp = now;
    } else {
      // Guarantee strict monotonicity even if the system clock is coarse.
      _currentTimestamp = (_currentTimestamp + 1) & 0xFFFFFFFFFFFF;
    }
    return _currentTimestamp;
  }

  /// Returns the first 48 bits of:
  /// SHA-256(secret_key + header + payload + CRC_low + CRC_high + timestamp(6 bytes) + link_id)
  ///
  /// IMPORTANT: The MAVLink C library (mavlink_sign_packet) feeds the 7 trailing
  /// bytes as [ts[0], ts[1], ts[2], ts[3], ts[4], ts[5], link_id] — i.e. the
  /// 6-byte timestamp first and link_id as the last byte.  Do NOT swap this order.
  Uint8List calculateSignature({
    required Uint8List header,
    required Uint8List payload,
    required int crcLow,
    required int crcHigh,
    required int linkId,
    required int timestamp48,
  }) {
    final buffer = BytesBuilder();

    buffer.add(config.secretKey);
    buffer.add(header);
    buffer.add(payload);

    buffer.addByte(crcLow & 0xFF);
    buffer.addByte(crcHigh & 0xFF);

    // The MAVLink C library mavlink_sign_packet() builds the 7-byte trailing
    // block as: signature[0]=link_id, signature[1..6]=timestamp (little-endian),
    // then feeds all 7 bytes to SHA-256 via sha256_update(signature, 7).
    // So link_id MUST come before the timestamp bytes — not after.
    buffer.addByte(linkId & 0xFF);
    for (int i = 0; i < 6; i++) {
      buffer.addByte((timestamp48 >> (i * 8)) & 0xFF);
    }

    final hash = sha256.convert(buffer.toBytes());
    return Uint8List.fromList(hash.bytes.sublist(0, _signatureLength));
  }

  bool verifySignature({
    required Uint8List header,
    required Uint8List payload,
    required int crcLow,
    required int crcHigh,
    required int linkId,
    required int timestamp48,
    required Uint8List signature,
    required int systemId,
    required int componentId,
  }) {
    if (signature.length != _signatureLength) {
      // TODO Commenting print statement
      // print('[SIG] REJECT bad signature length: ' + signature.length.toString());
      return false;
    }

    final expectedSignature = calculateSignature(
      header: header,
      payload: payload,
      crcLow: crcLow,
      crcHigh: crcHigh,
      linkId: linkId,
      timestamp48: timestamp48,
    );

    // TODO Commenting print statement
    // ── DEBUG ──────────────────────────────────────────────────────────────
    // String rxHex = signature.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    // String exHex = expectedSignature.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    // String keyHex = config.secretKey.sublist(0, 4).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    // print('[SIG] sysid=' + systemId.toString() +
    //       ' compid=' + componentId.toString() +
    //       ' linkId=' + linkId.toString() +
    //       ' ts=' + timestamp48.toString());
    // print('[SIG] received =' + rxHex);
    // print('[SIG] expected =' + exHex);
    // print('[SIG] key[0..3]=' + keyHex);
    // ── END DEBUG ──────────────────────────────────────────────────────────

    if (!_constantTimeEquals(expectedSignature, signature)) {
      // TODO Commenting print statement
      // print('[SIG] REJECT signature mismatch!');
      return false;
    }

    // TODO Commenting print statement
    // print('[SIG] signature bytes match, checking timestamp...');
    return _verifyTimestamp(
      timestamp48: timestamp48,
      systemId: systemId,
      componentId: componentId,
      linkId: linkId,
    );
  }

  /// Tolerance window: 1 000 000 units = ~10 seconds in 100 µs units.
  /// Allows clock drift and brief reconnects without rejecting valid packets.
  static const int _timestampToleranceUnits = 1000000;

  bool _verifyTimestamp({
    required int timestamp48,
    required int systemId,
    required int componentId,
    required int linkId,
  }) {
    final String linkKey = systemId.toString() + ':' + componentId.toString() + ':' + linkId.toString();
    final int? lastTimestamp = _lastTimestamps[linkKey];

    // TODO Commenting print statement
    // ── DEBUG ──────────────────────────────────────────────────────────────
    // print('[TS] key=' + linkKey +
    //       ' incoming=' + timestamp48.toString() +
    //       ' last=' + lastTimestamp.toString() +
    //       ' tolerance=' + _timestampToleranceUnits.toString());
    // ── END DEBUG ──────────────────────────────────────────────────────────

    if (lastTimestamp != null) {
      if (timestamp48 < (lastTimestamp - _timestampToleranceUnits)) {
        // TODO Commenting print statement
        // print('[TS] REJECT replay: ' + timestamp48.toString() +
        //       ' < (' + lastTimestamp.toString() +
        //       ' - ' + _timestampToleranceUnits.toString() + ')');
        return false;
      }
    }

    if (lastTimestamp == null || timestamp48 > lastTimestamp) {
      _lastTimestamps[linkKey] = timestamp48 & 0xFFFFFFFFFFFF;
    }
    // TODO Commenting print statement
    // print('[TS] ACCEPT timestamp OK');
    return true;
  }

  bool shouldAcceptPacket({
    required bool isSigned,
    required bool signatureValid,
  }) {
    switch (config.acceptPolicy) {
      case SignatureAcceptPolicy.signedOnly:
        return isSigned && signatureValid;

      case SignatureAcceptPolicy.acceptUnsigned:
        if (!isSigned) {
          return true;
        }
        return signatureValid;

      case SignatureAcceptPolicy.acceptAll:
        return true;
    }
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }

    int diff = 0;
    for (int i = 0; i < a.length; i++) {
      diff |= (a[i] ^ b[i]);
    }
    return diff == 0;
  }
}
