library dart_mavlink;

import 'dart:async';
import 'dart:typed_data';

import 'crc.dart';
import 'mavlink_dialect.dart';
import 'mavlink_frame.dart';
import 'mavlink_signature.dart';
import 'mavlink_version.dart';

enum _ParserState {
  init,
  waitPayloadLength,
  waitIncompatibilityFlags,
  waitCompatibilityFlags,
  waitPacketSequence,
  waitSystemId,
  waitComponentId,
  waitMessageIdLow,
  waitMessageIdMiddle,
  waitMessageIdHigh,
  waitPayloadEnd,
  waitCrcLowByte,
  waitCrcHighByte,
  waitSignatureLinkId,
  waitSignatureTimestamp,
  waitSignatureValue,
}

class MavlinkParser {
  static const int _mavlinkMaximumPayloadSize = 255;
  static const int _mavlinkIflagSigned = 0x01;

  final StreamController<MavlinkFrame> _streamController =
      StreamController<MavlinkFrame>.broadcast();

  _ParserState _state = _ParserState.init;

  MavlinkVersion _version = MavlinkVersion.v1;
  int _payloadLength = -1;
  int _incompatibilityFlags = -1;
  int _compatibilityFlags = -1;
  int _sequence = -1;
  int _systemId = -1;
  int _componentId = -1;
  int _messageIdLow = -1;
  int _messageIdMiddle = -1;
  int _messageIdHigh = -1;
  int _messageId = -1;

  final Uint8List _payload = Uint8List(_mavlinkMaximumPayloadSize);
  int _payloadCursor = -1;

  int _crcLowByte = -1;
  int _crcHighByte = -1;

  int _signatureLinkId = -1;
  final Uint8List _signatureTimestamp = Uint8List(6);
  int _signatureTimestampCursor = -1;
  final Uint8List _signatureValue = Uint8List(6);
  int _signatureValueCursor = -1;

  final MavlinkDialect _dialect;
  final MavlinkSignatureManager? _signatureManager;

  MavlinkParser(
    this._dialect, {
    MavlinkSignatureManager? signatureManager,
  }) : _signatureManager = signatureManager;

  void _resetContext() {
    _version = MavlinkVersion.v1;
    _payloadLength = -1;
    _incompatibilityFlags = -1;
    _compatibilityFlags = -1;
    _sequence = -1;
    _systemId = -1;
    _componentId = -1;
    _messageIdLow = -1;
    _messageIdMiddle = -1;
    _messageIdHigh = -1;
    _messageId = -1;
    _payloadCursor = -1;
    _crcLowByte = -1;
    _crcHighByte = -1;
    _signatureLinkId = -1;
    _signatureTimestampCursor = -1;
    _signatureValueCursor = -1;
  }

  bool _checkCRC() {
    final header = (_version == MavlinkVersion.v1)
        ? <int>[_payloadLength, _sequence, _systemId, _componentId, _messageId]
        : <int>[
            _payloadLength,
            _incompatibilityFlags,
            _compatibilityFlags,
            _sequence,
            _systemId,
            _componentId,
            _messageIdLow,
            _messageIdMiddle,
            _messageIdHigh,
          ];

    final crc = CrcX25();

    for (final d in header) {
      crc.accumulate(d & 0xff);
    }

    for (int i = 0; i < _payloadLength; i++) {
      crc.accumulate(_payload[i] & 0xff);
    }

    final crcExt = _dialect.crcExtra(_messageId);
    if (crcExt == -1) {
      return false;
    }

    crc.accumulate(crcExt);

    final packetCrc = ((_crcHighByte << 8) | _crcLowByte) & 0xFFFF;
    return crc.crc == packetCrc;
  }

  void parse(Uint8List data) {
    for (final d in data) {
      final frame = parseByte(d);
      if (frame != null) {
        _streamController.add(frame);
      }
    }
  }

  List<MavlinkFrame> parseBlob(Uint8List data) {
    _resetContext();
    _state = _ParserState.init;

    final List<MavlinkFrame> result = [];

    for (final d in data) {
      final frame = parseByte(d);
      if (frame != null) {
        result.add(frame);
      }
    }

    _resetContext();
    _state = _ParserState.init;
    return result;
  }

  MavlinkFrame? parseByte(int d) {
    switch (_state) {
      case _ParserState.init:
        if (d == MavlinkFrame.mavlinkStxV1) {
          _version = MavlinkVersion.v1;
          _state = _ParserState.waitPayloadLength;
        } else if (d == MavlinkFrame.mavlinkStxV2) {
          _version = MavlinkVersion.v2;
          _state = _ParserState.waitPayloadLength;
        }
        return null;

      case _ParserState.waitPayloadLength:
        _payloadLength = d;
        _state = (_version == MavlinkVersion.v1)
            ? _ParserState.waitPacketSequence
            : _ParserState.waitIncompatibilityFlags;
        return null;

      case _ParserState.waitIncompatibilityFlags:
        _incompatibilityFlags = d;
        _state = _ParserState.waitCompatibilityFlags;
        return null;

      case _ParserState.waitCompatibilityFlags:
        _compatibilityFlags = d;
        _state = _ParserState.waitPacketSequence;
        return null;

      case _ParserState.waitPacketSequence:
        _sequence = d;
        _state = _ParserState.waitSystemId;
        return null;

      case _ParserState.waitSystemId:
        _systemId = d;
        _state = _ParserState.waitComponentId;
        return null;

      case _ParserState.waitComponentId:
        _componentId = d;
        _state = (_version == MavlinkVersion.v1)
            ? _ParserState.waitMessageIdHigh
            : _ParserState.waitMessageIdLow;
        return null;

      case _ParserState.waitMessageIdLow:
        _messageIdLow = d;
        _state = _ParserState.waitMessageIdMiddle;
        return null;

      case _ParserState.waitMessageIdMiddle:
        _messageIdMiddle = d;
        _state = _ParserState.waitMessageIdHigh;
        return null;

      case _ParserState.waitMessageIdHigh:
        if (_version == MavlinkVersion.v1) {
          _messageId = d;
        } else {
          _messageIdHigh = d;
          _messageId =
              (_messageIdHigh << 16) | (_messageIdMiddle << 8) | _messageIdLow;
        }

        if (_payloadLength == 0) {
          _state = _ParserState.waitCrcLowByte;
        } else {
          _payloadCursor = 0;
          _state = _ParserState.waitPayloadEnd;
        }
        return null;

      case _ParserState.waitPayloadEnd:
        if (_payloadCursor < _payloadLength) {
          _payload[_payloadCursor++] = d;
        }

        if (_payloadCursor == _payloadLength) {
          _state = _ParserState.waitCrcLowByte;
        }
        return null;

      case _ParserState.waitCrcLowByte:
        _crcLowByte = d;
        _state = _ParserState.waitCrcHighByte;
        return null;

      case _ParserState.waitCrcHighByte:
        _crcHighByte = d;

        if (_version == MavlinkVersion.v2 &&
            (_incompatibilityFlags & _mavlinkIflagSigned) != 0) {
          // TODO Commenting print statement
          // print('[PARSER] signed packet detected msgid=' + _messageId.toString() +
          //       ' sysid=' + _systemId.toString() +
          //       ' compid=' + _componentId.toString() +
          //       ' seq=' + _sequence.toString());
          _state = _ParserState.waitSignatureLinkId;
          return null;
        }

        final frame = _finishFrame(isSigned: false);
        _resetContext();
        _state = _ParserState.init;
        return frame;

      case _ParserState.waitSignatureLinkId:
        _signatureLinkId = d;
        _signatureTimestampCursor = 0;
        _state = _ParserState.waitSignatureTimestamp;
        return null;

      case _ParserState.waitSignatureTimestamp:
        _signatureTimestamp[_signatureTimestampCursor++] = d;

        if (_signatureTimestampCursor == 6) {
          _signatureValueCursor = 0;
          _state = _ParserState.waitSignatureValue;
        }
        return null;

      case _ParserState.waitSignatureValue:
        _signatureValue[_signatureValueCursor++] = d;

        if (_signatureValueCursor == 6) {
          // TODO Commenting print statement
          // print('[PARSER] full signed frame received, calling _finishFrame');
          final frame = _finishFrame(isSigned: true);
          _resetContext();
          _state = _ParserState.init;
          return frame;
        }
        return null;
    }
  }

  MavlinkFrame? _finishFrame({required bool isSigned}) {
    // TODO Commenting print statement
    // print('[FINISH] isSigned=' + isSigned.toString() +
    //       ' msgid=' + _messageId.toString() +
    //       ' sysid=' + _systemId.toString() +
    //       ' payloadLen=' + _payloadLength.toString() +
    //       ' hasManager=' + (_signatureManager != null).toString());

    if (!_checkCRC()) {
      // TODO Commenting print statement
      // print('[FINISH] DROPPED: CRC check failed msgid=' + _messageId.toString());
      return null;
    }

    bool signatureValid = false;

    if (isSigned) {
      if (_signatureManager != null) {
        int timestamp48 = 0;
        for (int i = 0; i < 6; i++) {
          timestamp48 |= (_signatureTimestamp[i] & 0xFF) << (i * 8);
        }

        // The MAVLink signing spec hashes the full on-wire header starting
        // from STX. The C library mavlink_sign_packet receives a pointer to
        // the first byte of the wire frame (0xFD for v2), so we must include
        // it here. The v1 branch is moot since v1 packets cannot be signed.
        final header = (_version == MavlinkVersion.v1)
            ? Uint8List.fromList([
                MavlinkFrame.mavlinkStxV1, // 0xFE
                _payloadLength,
                _sequence,
                _systemId,
                _componentId,
                _messageId,
              ])
            : Uint8List.fromList([
                MavlinkFrame.mavlinkStxV2, // 0xFD
                _payloadLength,
                _incompatibilityFlags,
                _compatibilityFlags,
                _sequence,
                _systemId,
                _componentId,
                _messageIdLow,
                _messageIdMiddle,
                _messageIdHigh,
              ]);

        signatureValid = _signatureManager!.verifySignature(
          header: header,
          payload: Uint8List.fromList(_payload.sublist(0, _payloadLength)),
          crcLow: _crcLowByte,
          crcHigh: _crcHighByte,
          linkId: _signatureLinkId,
          timestamp48: timestamp48,
          signature: _signatureValue,
          systemId: _systemId,
          componentId: _componentId,
        );

        if (!_signatureManager!.shouldAcceptPacket(
          isSigned: true,
          signatureValid: signatureValid,
        )) {
          // TODO Commenting print statement
          // print('[FINISH] DROPPED: policy rejected isSigned=true signatureValid=' + signatureValid.toString());
          return null;
        }
      } else {
        // Packet is signed but we have no manager to verify it.
        // TODO Commenting print statement
        // print('[FINISH] DROPPED: signed packet but _signatureManager is null!');
        return null;
      }
    } else {
      if (_signatureManager != null &&
          !_signatureManager!.shouldAcceptPacket(
            isSigned: false,
            signatureValid: false,
          )) {
        // TODO Commenting print statement
        // print('[FINISH] DROPPED: policy rejected unsigned packet');
        return null;
      }
    }

    final message = _dialect.parse(
        _messageId, _payload.buffer.asByteData(0, _payloadLength));

    if (message == null) {
      // TODO Commenting print statement
      // print('[FINISH] DROPPED: dialect could not parse msgid=' + _messageId.toString());
      return null;
    }

    // TODO Commenting print statement
    // print('[FINISH] ACCEPTED msgid=' + _messageId.toString() +
    //       ' signatureValid=' + signatureValid.toString());

    return MavlinkFrame(
      _version,
      _sequence,
      _systemId,
      _componentId,
      message,
      isSigned,
      signatureValid,
    );
  }

  Stream<MavlinkFrame> get stream => _streamController.stream;
}
