import 'dart:typed_data';
import 'package:mavlink_dart/mavlink_dialect.dart';
import 'package:mavlink_dart/mavlink_message.dart';
import 'package:mavlink_dart/types.dart';
import 'dart:convert';

/// Indicates vehicle or ground station entity connectivity status.
///
/// HEARTBEAT
class Heartbeat implements MavlinkMessage {
  static const int msgId = 0;

  static const int crcExtra = 50;

  static const int mavlinkEncodedLength = 9;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 9-12 (HC/GCS) or Bytes 9 (COMP). Drive mode rules. COMP sends 1: Speed, 2: Torque, 3: Torque with speed limit. HC and GCS send 0 (Not used).
  ///
  /// MAVLink type: uint32_t
  ///
  /// custom_mode
  final uint32_t customMode;

  /// Bytes: 6. Component type. COMP sends 18 (MAV_TYPE_ONBOARD_CONTROLLER). HC sends 6 (GCS Type). GCS sends 6 (GCS Type).
  ///
  /// MAVLink type: uint8_t
  ///
  /// type
  final uint8_t type;

  /// Bytes: 7. Autopilot identifier. Compute/HC/GCS all hardcode to 8 (MAV_AUTOPILOT_INVALID).
  ///
  /// MAVLink type: uint8_t
  ///
  /// autopilot
  final uint8_t autopilot;

  /// Bytes: 8. System wide flag bitmask. COMP sends 1 (Custom mode enable). HC and GCS send 0 (No MAV_MODE_FLAG enabled).
  ///
  /// MAVLink type: uint8_t
  ///
  /// base_mode
  final uint8_t baseMode;

  /// Bytes: 13 (HC/GCS) or Bytes 17 (COMP). Status flags. Mapped as 3: Standby mode, 4: Active mode.
  ///
  /// MAVLink type: uint8_t
  ///
  /// system_status
  final uint8_t systemStatus;

  /// Bytes: 14 (HC/GCS) or Bytes 18 (COMP). Internal communication library version indicator injected automatically by protocol wire layer.
  ///
  /// MAVLink type: uint8_t
  ///
  /// mavlink_version
  final uint8_t mavlinkVersion;

  Heartbeat({
    required this.customMode,
    required this.type,
    required this.autopilot,
    required this.baseMode,
    required this.systemStatus,
    required this.mavlinkVersion,
  });

  Heartbeat.fromJson(Map<String, dynamic> json)
      : customMode = json['customMode'],
        type = json['type'],
        autopilot = json['autopilot'],
        baseMode = json['baseMode'],
        systemStatus = json['systemStatus'],
        mavlinkVersion = json['mavlinkVersion'];
  Heartbeat copyWith({
    uint32_t? customMode,
    uint8_t? type,
    uint8_t? autopilot,
    uint8_t? baseMode,
    uint8_t? systemStatus,
    uint8_t? mavlinkVersion,
  }) {
    return Heartbeat(
      customMode: customMode ?? this.customMode,
      type: type ?? this.type,
      autopilot: autopilot ?? this.autopilot,
      baseMode: baseMode ?? this.baseMode,
      systemStatus: systemStatus ?? this.systemStatus,
      mavlinkVersion: mavlinkVersion ?? this.mavlinkVersion,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'customMode': customMode,
        'type': type,
        'autopilot': autopilot,
        'baseMode': baseMode,
        'systemStatus': systemStatus,
        'mavlinkVersion': mavlinkVersion,
      };

  factory Heartbeat.parse(ByteData data_) {
    if (data_.lengthInBytes < Heartbeat.mavlinkEncodedLength) {
      var len = Heartbeat.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var customMode = data_.getUint32(0, Endian.little);
    var type = data_.getUint8(4);
    var autopilot = data_.getUint8(5);
    var baseMode = data_.getUint8(6);
    var systemStatus = data_.getUint8(7);
    var mavlinkVersion = data_.getUint8(8);

    return Heartbeat(
        customMode: customMode,
        type: type,
        autopilot: autopilot,
        baseMode: baseMode,
        systemStatus: systemStatus,
        mavlinkVersion: mavlinkVersion);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, customMode, Endian.little);
    data_.setUint8(4, type);
    data_.setUint8(5, autopilot);
    data_.setUint8(6, baseMode);
    data_.setUint8(7, systemStatus);
    data_.setUint8(8, mavlinkVersion);
    return data_;
  }
}

/// Time synchronization mechanism ensuring clock drift alignments.
///
/// TIMESYNC
class Timesync implements MavlinkMessage {
  static const int msgId = 111;

  static const int crcExtra = 198;

  static const int mavlinkEncodedLength = 18;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 10-17. Time synchronization payload marker segment 1 (us). HC requests send 0. COMP responses send the UGV clock timestamp.
  ///
  /// MAVLink type: int64_t
  ///
  /// tc1
  final int64_t tc1;

  /// Bytes: 18-25. Time synchronization payload marker segment 2 (us). Current timestamp of the HC or GCS, mirrored back in response.
  ///
  /// MAVLink type: int64_t
  ///
  /// ts1
  final int64_t ts1;

  /// Bytes: 26. Target routing system validation field. Mapped as 1: UGV/Compute, 2: Hand controller, 255: GCS, 0: Broadcast.
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Bytes: 27. Target component identifier address block. Mapped as 191: Compute, 190: Mission Planner GCS, 1: HC, 0: Broadcast.
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_component
  final uint8_t targetComponent;

  Timesync({
    required this.tc1,
    required this.ts1,
    required this.targetSystem,
    required this.targetComponent,
  });

  Timesync.fromJson(Map<String, dynamic> json)
      : tc1 = json['tc1'],
        ts1 = json['ts1'],
        targetSystem = json['targetSystem'],
        targetComponent = json['targetComponent'];
  Timesync copyWith({
    int64_t? tc1,
    int64_t? ts1,
    uint8_t? targetSystem,
    uint8_t? targetComponent,
  }) {
    return Timesync(
      tc1: tc1 ?? this.tc1,
      ts1: ts1 ?? this.ts1,
      targetSystem: targetSystem ?? this.targetSystem,
      targetComponent: targetComponent ?? this.targetComponent,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'tc1': tc1,
        'ts1': ts1,
        'targetSystem': targetSystem,
        'targetComponent': targetComponent,
      };

  factory Timesync.parse(ByteData data_) {
    if (data_.lengthInBytes < Timesync.mavlinkEncodedLength) {
      var len = Timesync.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var tc1 = data_.getInt64(0, Endian.little);
    var ts1 = data_.getInt64(8, Endian.little);
    var targetSystem = data_.getUint8(16);
    var targetComponent = data_.getUint8(17);

    return Timesync(
        tc1: tc1,
        ts1: ts1,
        targetSystem: targetSystem,
        targetComponent: targetComponent);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setInt64(0, tc1, Endian.little);
    data_.setInt64(8, ts1, Endian.little);
    data_.setUint8(16, targetSystem);
    data_.setUint8(17, targetComponent);
    return data_;
  }
}

/// Standard action block transmitting state adjustments across the data link.
///
/// COMMAND_LONG
class CommandLong implements MavlinkMessage {
  static const int msgId = 76;

  static const int crcExtra = 152;

  static const int mavlinkEncodedLength = 33;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 15-18. Command parameter argument slot 1 configuration. Sets Mode flag options, Arm/Disarm states, Drive modes, Light toggles, Camera streams, or Home activation rules.
  ///
  /// MAVLink type: float
  ///
  /// param1
  final float param1;

  /// Bytes: 19-22. Command parameter argument slot 2 configuration. Custom Mode Selection (1-5), Force Arm verification (21196), Fog lights toggle, or Range markers status.
  ///
  /// MAVLink type: float
  ///
  /// param2
  final float param2;

  /// Bytes: 23-26. Command parameter argument slot 3 configuration. Drive Mode speed limit selections (1: Low, 2: Medium, 3: High) or Aft Brake Lights control.
  ///
  /// MAVLink type: float
  ///
  /// param3
  final float param3;

  /// Bytes: 27-30. Command parameter argument slot 4 configuration. Hardcoded to NA / Reserved for future use.
  ///
  /// MAVLink type: float
  ///
  /// param4
  final float param4;

  /// Bytes: 31-34. Command parameter argument slot 5 configuration. Hardcoded to NA / Reserved except for Latitude value in Home commands.
  ///
  /// MAVLink type: float
  ///
  /// param5
  final float param5;

  /// Bytes: 35-38. Command parameter argument slot 6 configuration. Hardcoded to NA / Reserved except for Longitude value in Home commands.
  ///
  /// MAVLink type: float
  ///
  /// param6
  final float param6;

  /// Bytes: 39-42. Command parameter argument slot 7 configuration. Hardcoded to NA / Reserved except for Altitude value in Home commands.
  ///
  /// MAVLink type: float
  ///
  /// param7
  final float param7;

  /// Bytes: 12-13. Target internal action command code. Expected values: 176 (SET_MODE), 400 (ARM_DISARM), 179 (SET_HOME), 31900 (DRIVE_MODE), 31901 (LIGHT_CONTROL), 31902 (CAMERA_MARKER), 31904 (REMOTE_EMERGENCY).
  ///
  /// MAVLink type: uint16_t
  ///
  /// command
  final uint16_t command;

  /// Bytes: 10. System sequence destination validation field. Value expected: 1 (UGV).
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Bytes: 11. Component destination routing index. Value expected: 191 (Compute).
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_component
  final uint8_t targetComponent;

  /// Bytes: 14. Retransmission tracker. Value expected: 0 for first transmission, increments 1-255 on active retry attempts.
  ///
  /// MAVLink type: uint8_t
  ///
  /// confirmation
  final uint8_t confirmation;

  CommandLong({
    required this.param1,
    required this.param2,
    required this.param3,
    required this.param4,
    required this.param5,
    required this.param6,
    required this.param7,
    required this.command,
    required this.targetSystem,
    required this.targetComponent,
    required this.confirmation,
  });

  CommandLong.fromJson(Map<String, dynamic> json)
      : param1 = json['param1'],
        param2 = json['param2'],
        param3 = json['param3'],
        param4 = json['param4'],
        param5 = json['param5'],
        param6 = json['param6'],
        param7 = json['param7'],
        command = json['command'],
        targetSystem = json['targetSystem'],
        targetComponent = json['targetComponent'],
        confirmation = json['confirmation'];
  CommandLong copyWith({
    float? param1,
    float? param2,
    float? param3,
    float? param4,
    float? param5,
    float? param6,
    float? param7,
    uint16_t? command,
    uint8_t? targetSystem,
    uint8_t? targetComponent,
    uint8_t? confirmation,
  }) {
    return CommandLong(
      param1: param1 ?? this.param1,
      param2: param2 ?? this.param2,
      param3: param3 ?? this.param3,
      param4: param4 ?? this.param4,
      param5: param5 ?? this.param5,
      param6: param6 ?? this.param6,
      param7: param7 ?? this.param7,
      command: command ?? this.command,
      targetSystem: targetSystem ?? this.targetSystem,
      targetComponent: targetComponent ?? this.targetComponent,
      confirmation: confirmation ?? this.confirmation,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'param1': param1,
        'param2': param2,
        'param3': param3,
        'param4': param4,
        'param5': param5,
        'param6': param6,
        'param7': param7,
        'command': command,
        'targetSystem': targetSystem,
        'targetComponent': targetComponent,
        'confirmation': confirmation,
      };

  factory CommandLong.parse(ByteData data_) {
    if (data_.lengthInBytes < CommandLong.mavlinkEncodedLength) {
      var len = CommandLong.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var param1 = data_.getFloat32(0, Endian.little);
    var param2 = data_.getFloat32(4, Endian.little);
    var param3 = data_.getFloat32(8, Endian.little);
    var param4 = data_.getFloat32(12, Endian.little);
    var param5 = data_.getFloat32(16, Endian.little);
    var param6 = data_.getFloat32(20, Endian.little);
    var param7 = data_.getFloat32(24, Endian.little);
    var command = data_.getUint16(28, Endian.little);
    var targetSystem = data_.getUint8(30);
    var targetComponent = data_.getUint8(31);
    var confirmation = data_.getUint8(32);

    return CommandLong(
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        param6: param6,
        param7: param7,
        command: command,
        targetSystem: targetSystem,
        targetComponent: targetComponent,
        confirmation: confirmation);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setFloat32(0, param1, Endian.little);
    data_.setFloat32(4, param2, Endian.little);
    data_.setFloat32(8, param3, Endian.little);
    data_.setFloat32(12, param4, Endian.little);
    data_.setFloat32(16, param5, Endian.little);
    data_.setFloat32(20, param6, Endian.little);
    data_.setFloat32(24, param7, Endian.little);
    data_.setUint16(28, command, Endian.little);
    data_.setUint8(30, targetSystem);
    data_.setUint8(31, targetComponent);
    data_.setUint8(32, confirmation);
    return data_;
  }
}

/// Locomotion interface routing joystick user input vectors down to the drivetrain.
///
/// MANUAL_CONTROL
class ManualControl implements MavlinkMessage {
  static const int msgId = 69;

  static const int crcExtra = 243;

  static const int mavlinkEncodedLength = 30;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 11-12. Scaled forward and reverse velocity coordinate. HC range: -4800 to 4790 (ADC offset multiplied by 10). GCS range: -32767 to 32767. Mechanical center deadzone returns 0.
  ///
  /// MAVLink type: int16_t
  ///
  /// x
  final int16_t x;

  /// Bytes: 13-14. Scaled port and starboard displacement lateral coordinate. HC range: -4800 to 4790. GCS range: -32767 to 32767. Mechanical center deadzone returns 0.
  ///
  /// MAVLink type: int16_t
  ///
  /// y
  final int16_t y;

  /// Bytes: 15-16. Z-axis input elevation parameters placeholder. Hardcoded constant value: 32767 (Disabled).
  ///
  /// MAVLink type: int16_t
  ///
  /// z
  final int16_t z;

  /// Bytes: 17-18. Rotational direction yaw modifier. Hardcoded constant value: 32767 (Disabled).
  ///
  /// MAVLink type: int16_t
  ///
  /// r
  final int16_t r;

  /// Bytes: 19-20. 16-bit physical interface key buttons allocation bitmask panel.
  ///
  /// MAVLink type: uint16_t
  ///
  /// buttons
  final uint16_t buttons;

  /// Bytes: 10. Target routing destination system verification code. Value expected: 1 (UGV).
  ///
  /// MAVLink type: uint8_t
  ///
  /// target
  final uint8_t target;

  /// Bytes: 21-22. Extended layout joystick button checks register payload space (Not used, hardcoded to 0).
  ///
  /// MAVLink type: uint16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// buttons2
  final uint16_t buttons2;

  /// Bytes: 23. Active payload field extensions indicator status byte (Not used, hardcoded to 0).
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// enabled_extensions
  final uint8_t enabledExtensions;

  /// Bytes: 24-25. Pitch axis framework extension parameter (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// s
  final int16_t s;

  /// Bytes: 26-27. Roll axis framework extension parameter (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// t
  final int16_t t;

  /// Bytes: 28-29. Auxiliary component parameter input pipeline 1 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux1
  final int16_t aux1;

  /// Bytes: 30-31. Auxiliary component parameter input pipeline 2 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux2
  final int16_t aux2;

  /// Bytes: 32-33. Auxiliary component parameter input pipeline 3 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux3
  final int16_t aux3;

  /// Bytes: 34-35. Auxiliary component parameter input pipeline 4 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux4
  final int16_t aux4;

  /// Bytes: 36-37. Auxiliary component parameter input pipeline 5 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux5
  final int16_t aux5;

  /// Bytes: 38-39. Auxiliary component parameter input pipeline 6 (Not used, hardcoded to 0).
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux6
  final int16_t aux6;

  ManualControl({
    required this.x,
    required this.y,
    required this.z,
    required this.r,
    required this.buttons,
    required this.target,
    required this.buttons2,
    required this.enabledExtensions,
    required this.s,
    required this.t,
    required this.aux1,
    required this.aux2,
    required this.aux3,
    required this.aux4,
    required this.aux5,
    required this.aux6,
  });

  ManualControl.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'],
        r = json['r'],
        buttons = json['buttons'],
        target = json['target'],
        buttons2 = json['buttons2'],
        enabledExtensions = json['enabledExtensions'],
        s = json['s'],
        t = json['t'],
        aux1 = json['aux1'],
        aux2 = json['aux2'],
        aux3 = json['aux3'],
        aux4 = json['aux4'],
        aux5 = json['aux5'],
        aux6 = json['aux6'];
  ManualControl copyWith({
    int16_t? x,
    int16_t? y,
    int16_t? z,
    int16_t? r,
    uint16_t? buttons,
    uint8_t? target,
    uint16_t? buttons2,
    uint8_t? enabledExtensions,
    int16_t? s,
    int16_t? t,
    int16_t? aux1,
    int16_t? aux2,
    int16_t? aux3,
    int16_t? aux4,
    int16_t? aux5,
    int16_t? aux6,
  }) {
    return ManualControl(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      r: r ?? this.r,
      buttons: buttons ?? this.buttons,
      target: target ?? this.target,
      buttons2: buttons2 ?? this.buttons2,
      enabledExtensions: enabledExtensions ?? this.enabledExtensions,
      s: s ?? this.s,
      t: t ?? this.t,
      aux1: aux1 ?? this.aux1,
      aux2: aux2 ?? this.aux2,
      aux3: aux3 ?? this.aux3,
      aux4: aux4 ?? this.aux4,
      aux5: aux5 ?? this.aux5,
      aux6: aux6 ?? this.aux6,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'x': x,
        'y': y,
        'z': z,
        'r': r,
        'buttons': buttons,
        'target': target,
        'buttons2': buttons2,
        'enabledExtensions': enabledExtensions,
        's': s,
        't': t,
        'aux1': aux1,
        'aux2': aux2,
        'aux3': aux3,
        'aux4': aux4,
        'aux5': aux5,
        'aux6': aux6,
      };

  factory ManualControl.parse(ByteData data_) {
    if (data_.lengthInBytes < ManualControl.mavlinkEncodedLength) {
      var len = ManualControl.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var x = data_.getInt16(0, Endian.little);
    var y = data_.getInt16(2, Endian.little);
    var z = data_.getInt16(4, Endian.little);
    var r = data_.getInt16(6, Endian.little);
    var buttons = data_.getUint16(8, Endian.little);
    var target = data_.getUint8(10);
    var buttons2 = data_.getUint16(11, Endian.little);
    var enabledExtensions = data_.getUint8(13);
    var s = data_.getInt16(14, Endian.little);
    var t = data_.getInt16(16, Endian.little);
    var aux1 = data_.getInt16(18, Endian.little);
    var aux2 = data_.getInt16(20, Endian.little);
    var aux3 = data_.getInt16(22, Endian.little);
    var aux4 = data_.getInt16(24, Endian.little);
    var aux5 = data_.getInt16(26, Endian.little);
    var aux6 = data_.getInt16(28, Endian.little);

    return ManualControl(
        x: x,
        y: y,
        z: z,
        r: r,
        buttons: buttons,
        target: target,
        buttons2: buttons2,
        enabledExtensions: enabledExtensions,
        s: s,
        t: t,
        aux1: aux1,
        aux2: aux2,
        aux3: aux3,
        aux4: aux4,
        aux5: aux5,
        aux6: aux6);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setInt16(0, x, Endian.little);
    data_.setInt16(2, y, Endian.little);
    data_.setInt16(4, z, Endian.little);
    data_.setInt16(6, r, Endian.little);
    data_.setUint16(8, buttons, Endian.little);
    data_.setUint8(10, target);
    data_.setUint16(11, buttons2, Endian.little);
    data_.setUint8(13, enabledExtensions);
    data_.setInt16(14, s, Endian.little);
    data_.setInt16(16, t, Endian.little);
    data_.setInt16(18, aux1, Endian.little);
    data_.setInt16(20, aux2, Endian.little);
    data_.setInt16(22, aux3, Endian.little);
    data_.setInt16(24, aux4, Endian.little);
    data_.setInt16(26, aux5, Endian.little);
    data_.setInt16(28, aux6, Endian.little);
    return data_;
  }
}

/// Telemetry radio budget metrics tracking wireless signal health indicators.
///
/// RADIO_STATUS
class RadioStatus implements MavlinkMessage {
  static const int msgId = 109;

  static const int crcExtra = 185;

  static const int mavlinkEncodedLength = 9;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 6-7. Total corrupted or invalid packets received by the UGV radio telemetry node since system boot up.
  ///
  /// MAVLink type: uint16_t
  ///
  /// rxerrors
  final uint16_t rxerrors;

  /// Bytes: 8-9. Total radio packets successfully repaired using internal forward error correction (FEC) mechanisms (Not used, set to 0-65535).
  ///
  /// MAVLink type: uint16_t
  ///
  /// fixed
  final uint16_t fixed;

  /// Byte: 10. Local signal strength indicator measured at the UGV receiver. Range: 0-254, 255: Invalid.
  ///
  /// MAVLink type: uint8_t
  ///
  /// rssi
  final uint8_t rssi;

  /// Byte: 11. Remote endpoint link signal strength measured at hand controller. Range: 0-254, 255: Invalid.
  ///
  /// MAVLink type: uint8_t
  ///
  /// remrssi
  final uint8_t remrssi;

  /// Byte: 12. Percentage metric tracking available transmitter buffer queue volume space (Not used, returns 0-100).
  ///
  /// MAVLink type: uint8_t
  ///
  /// txbuf
  final uint8_t txbuf;

  /// Byte: 13. Local background RF electrical noise measurement envelope at the UGV unit. Range: 0-254, 255: Invalid.
  ///
  /// MAVLink type: uint8_t
  ///
  /// noise
  final uint8_t noise;

  /// Byte: 14. Remote background RF noise recorded at the hand controller terminal unit. Range: 0-254, 255: Invalid.
  ///
  /// MAVLink type: uint8_t
  ///
  /// remnoise
  final uint8_t remnoise;

  RadioStatus({
    required this.rxerrors,
    required this.fixed,
    required this.rssi,
    required this.remrssi,
    required this.txbuf,
    required this.noise,
    required this.remnoise,
  });

  RadioStatus.fromJson(Map<String, dynamic> json)
      : rxerrors = json['rxerrors'],
        fixed = json['fixed'],
        rssi = json['rssi'],
        remrssi = json['remrssi'],
        txbuf = json['txbuf'],
        noise = json['noise'],
        remnoise = json['remnoise'];
  RadioStatus copyWith({
    uint16_t? rxerrors,
    uint16_t? fixed,
    uint8_t? rssi,
    uint8_t? remrssi,
    uint8_t? txbuf,
    uint8_t? noise,
    uint8_t? remnoise,
  }) {
    return RadioStatus(
      rxerrors: rxerrors ?? this.rxerrors,
      fixed: fixed ?? this.fixed,
      rssi: rssi ?? this.rssi,
      remrssi: remrssi ?? this.remrssi,
      txbuf: txbuf ?? this.txbuf,
      noise: noise ?? this.noise,
      remnoise: remnoise ?? this.remnoise,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'rxerrors': rxerrors,
        'fixed': fixed,
        'rssi': rssi,
        'remrssi': remrssi,
        'txbuf': txbuf,
        'noise': noise,
        'remnoise': remnoise,
      };

  factory RadioStatus.parse(ByteData data_) {
    if (data_.lengthInBytes < RadioStatus.mavlinkEncodedLength) {
      var len = RadioStatus.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var rxerrors = data_.getUint16(0, Endian.little);
    var fixed = data_.getUint16(2, Endian.little);
    var rssi = data_.getUint8(4);
    var remrssi = data_.getUint8(5);
    var txbuf = data_.getUint8(6);
    var noise = data_.getUint8(7);
    var remnoise = data_.getUint8(8);

    return RadioStatus(
        rxerrors: rxerrors,
        fixed: fixed,
        rssi: rssi,
        remrssi: remrssi,
        txbuf: txbuf,
        noise: noise,
        remnoise: remnoise);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint16(0, rxerrors, Endian.little);
    data_.setUint16(2, fixed, Endian.little);
    data_.setUint8(4, rssi);
    data_.setUint8(5, remrssi);
    data_.setUint8(6, txbuf);
    data_.setUint8(7, noise);
    data_.setUint8(8, remnoise);
    return data_;
  }
}

/// Aggregated telemetry monitoring framework health and status of all subsystems.
///
/// UGV_SYSTEM_INFO
class UgvSystemInfo implements MavlinkMessage {
  static const int msgId = 50001;

  static const int crcExtra = 181;

  static const int mavlinkEncodedLength = 81;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 31-33. Packed bitmask covering the absolute physical fault registers array logs for all powertrain components. Bytes 36(0) to 37(7): Aft motor controllers system check covering overspeed, overload, phase loss, brake, encoder tracking anomalies, thermal tracking errors, hall framework failures, and engine stall conditions targeting both Port and Starboard motors. Bytes 38(0) to 39(7): Forward motor controllers matching system fault check covering overspeed, overload, phase loss, brake, encoder, thermal, hall, and stall criteria for both Forward Port and Starboard motors.
  ///
  /// MAVLink type: uint32_t
  ///
  /// motor_faults
  final uint32_t motorFaults;

  /// Bytes: 36-39. Packed internal traction motor controller drive electronics health loop validation checklist profile register. Bytes 41(0) to 42(7): Dynamic powertrain motor driver safety errors bitmask tracking loop anomalies including global drive loops failure, electrical phase overcurrent, input rail overvoltage, input rail undervoltage, internal UART data framework failures, DC bus balance faults, thermal temperature check boundaries violation, and internal CAN interface packet network drops targeting both Aft and Forward controller modules. Byte 43 (Bits 0): Aft motor controller validation feedback parameters checking matrix loop authority flag (0: Valid, 1: Invalid). Byte 43 (Bits 1): Forward motor controller validation feedback parameters checking loop.
  ///
  /// MAVLink type: uint32_t
  ///
  /// comp_interface_health_2
  final uint32_t compInterfaceHealth2;

  /// Bytes: 57-60. Reference coordinates anchor latitude data value allocation field space. Valid coordinates only return when locking parameter 56(0) equals 1. Scaling factor constraint: 1e-7 integer format.
  ///
  /// MAVLink type: int32_t
  ///
  /// lat
  final int32_t lat;

  /// Bytes: 61-64. Reference coordinates anchor longitude data value allocation field space. Valid coordinates only return when locking parameter 56(0) equals 1. Scaling factor constraint: 1e-7 integer format.
  ///
  /// MAVLink type: int32_t
  ///
  /// lon
  final int32_t lon;

  /// Byte: 11. Low Voltage system battery state-of-charge gauge indicator. Returns 0-100 percentage range.
  ///
  /// MAVLink type: uint16_t
  ///
  /// battery_soc
  final uint16_t batterySoc;

  /// Byte: 14 (Bits 0-3). Drive mode limit selection (1: Low, 2: Medium, 3: High). Byte 14 (Bits 4-7) Drive Mode loop strategy (1: Speed, 2: Torque, 3: Torque with speed limit).
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_model
  final uint16_t compModel;

  /// Bytes: 16-17. Packed bitmask mapping diagnostics for UHF hardware elements. Bits 16(0) to 16(3): UHF Radio UART, Firmware, RSSI, and Temperature faults. Bits 16(4) to 17(4): UHF Transceiver link connection drops, noises, SNR, and heartbeat timeout indicators.
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_1
  final uint16_t sensorSubsystemHealth1;

  /// Bytes: 19-20. Packed bitmask monitoring tracking loops for L-Band onboard radios. Bits 19(0) to 19(3): L-Band Ethernet, Firmware, RSSI, and Temp faults. Bits 19(4) to 20(4): L-Band link connection drops, noises, SNR anomalies, and timeout alerts. Byte 20 (Bits 5-6) L-Band Link connection status.
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_4
  final uint16_t sensorSubsystemHealth4;

  /// Bytes: 22-23. Diagnostics register. Byte 22(5) to 22(6): IMU hardware communication and data loops integrity status. Byte 22(7) to 23(1): 2D and 3D Lidar hardware lines communications check indicators. Byte 23 (Bits 2-3): Forward single camera module framework evaluation index (0: Unknown, 1: Healthy, 2: Faulty). Byte 23 (Bits 4-5): Forward composite camera system evaluation. Byte 23 (Bits 6-7): Port camera.
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_subsystem_status
  final uint16_t compSubsystemStatus;

  /// Bytes: 23-24. Packed camera health index arrays. Byte 24 (Bits 0-1): Starboard camera health check index. Byte 24 (Bits 2-3): Rear camera check index. Byte 24 (Bits 4-5): Day/Night camera check index. Byte 24 (Bits 6): 3D Lidar raw metrics integration data validity flag.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_subsystem_power_state_1
  final uint16_t vcuSubsystemPowerState1;

  /// Bytes: 25-26. Dynamic power systems diagnostics registers tracker. Byte 25 (Bits 0-1): Aft motor controllers system health state status index. Byte 25 (Bits 2-3): Forward motor controllers health status. Byte 25 (Bits 4-5): High Voltage traction battery system health. Byte 25 (Bits 6-7): Low Voltage system battery health status. Byte 26 (Bits 0-1): LV PDU health. Byte 26 (Bits 2-3): DC-DC 48V-12V converter module loop health. Byte 26 (Bits 4-5): HV PDU component health status. Byte 26 (Bits 6-7): Forward left motor state.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_power_subsystem_state_2
  final uint16_t vcuPowerSubsystemState2;

  /// Bytes: 25-26. Traction array logic parameter mapping register. Byte 27 (Bits 0-1): Aft left locomotion motor state index. Byte 27 (Bits 2-3): Forward right motor state index. Byte 27 (Bits 4-5): Aft right motor state index. Byte 27 (Bits 6-7): Onboard primary core compute node hardware execution check index. Byte 28 (Bits 0-1): Secondary safety compute coprocessor unit hardware monitoring state index.
  ///
  /// MAVLink type: uint16_t
  ///
  /// validity_motor_faults
  final uint16_t validityMotorFaults;

  /// Bytes: 26-27. Auxiliary execution subsystems logs. Byte 28 (Bits 2-3): VCU operational system state checklist flag. Byte 29 (Bits 0-1): UGV side UHF radio transceiver platform device health. Byte 29 (Bits 2-3): Onboard L-Band receiver module hardware operations loop registry. Byte 29 (Bits 4-5): Ethernet infrastructure network switcher module verification code. Byte 29 (Bits 6-7): Onboard GNSS positioning array unit check validation key.
  ///
  /// MAVLink type: uint16_t
  ///
  /// mc_faults_1
  final uint16_t mcFaults1;

  /// Bytes: 27-28. Compute systems log bitmask. Byte 30 (Bits 0-1): Inertial Navigation IMU system health validation code (0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty). Byte 30 (Bits 2-3): On-Vehicle 2D Lidar system tracking performance health index. Byte 30 (Bits 4-5): On-Vehicle 3D Lidar system tracking performance health index.
  ///
  /// MAVLink type: uint16_t
  ///
  /// mc_faults_2
  final uint16_t mcFaults2;

  /// Bytes: 28-29. Relays configuration bitmask loop parameters layout. Byte 31 (Bits 0-1): Forward traction motor power line grid controller relay (0: Unknown, 1: ON, 2: OFF). Byte 31 (Bits 2-3): Aft traction motor power line grid controller relay. Byte 31 (Bits 4-5): Onboard DC-DC 48V to 12V converter unit electrical relay switch status. Byte 31 (Bits 6-7): HV PDU execution power rail loop confirmation flag. Byte 32 (Bits 0-1): LV PDU execution power rail loop confirmation flag. Byte 32 (Bits 2-3): UHF telemetry radio module dynamic electrical power relay validation. Byte 32 (Bits 4-5): Onboard L-Band network transceiver system electrical relay switch status.
  ///
  /// MAVLink type: uint16_t
  ///
  /// contactor_fault
  final uint16_t contactorFault;

  /// Bytes: 29-30. Power distribution module safety monitoring registers index layout. Byte 32 (Bits 6-7): Onboard network infrastructure Ethernet switch rail relay switch status. Byte 33 (Bits 0-1): GNSS navigation sensor system active electronic relay line status. Byte 33 (Bits 2-3): Inertial IMU instrumentation sensor active electronic relay line status. Byte 33 (Bits 4-5): 2D Lidar sensor active power line electronic relay status. Byte 33 (Bits 6-7): 3D Lidar sensor active power line electronic relay status.
  ///
  /// MAVLink type: uint16_t
  ///
  /// pdu_fault
  final uint16_t pduFault;

  /// Bytes: 29-30. Core system framework execution monitoring checks layout. Byte 34 (Bits 0-1): VCU primary logic central command power supply line relay verification. Byte 34 (Bits 2-3): Onboard main primary core compute node power supply rail line verification. Byte 34 (Bits 4-5): Secondary coprocessor compute node power supply rail line verification. Byte 34 (Bits 6-7): RGBD profiling video cameras active power supply line relay status.
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_1
  final uint16_t powerSubsystemFaults1;

  /// Bytes: 29-30. Peripheral equipment grid management validation indices. Byte 35 (Bits 0-1): High performance vehicle lighting headlights line relay state verification (0: Unknown, 1: ON, 2: OFF). Byte 35 (Bits 2-3): High performance vehicle lighting aft brake lights line relay state verification. Byte 35 (Bits 4-5): High performance vehicle lighting forward fog lights line relay state verification.
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_2
  final uint16_t powerSubsystemFaults2;

  /// Bytes: 30-31. Central management loop inputs diagnostics profile registers mapping. Mapped from dynamic sequential parameter checking arrays targeting physical inputs health loops.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_interface_health
  final uint16_t vcuInterfaceHealth;

  /// Bytes: 33-35. Locomotion motor diagnostic metrics arrays integrity confirmation flag check code. Byte 40 (Bits 0): Raw motor metrics target payload array validity checking code targeting Aft motor system diagnostics (0: Valid, 1: Invalid). Byte 40 (Bits 1): Raw motor metrics target payload array validity checking code targeting Forward motor system diagnostics (0: Valid, 1: Invalid).
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_interface_health_1
  final uint16_t compInterfaceHealth1;

  /// Bytes: 41-42. Power delivery systems structural distribution routing network diagnostics bitmask checklist profile register. Bytes 45(0) to 45(7): Electronic PDU switch array dynamic output channel electrical tracking registers covering structural failures across distribution channels 1 through 8 (0: No Fault, 1: Channel Fault present).
  ///
  /// MAVLink type: uint16_t
  ///
  /// home_location
  final uint16_t homeLocation;

  /// Bytes: 45. Low Voltage management frame storage system monitoring register guidelines checklist. Bytes 48(0) to 48(2): LV Battery performance threshold tracking flags monitoring battery terminal undervoltage limits, battery terminal overvoltage limits, and load short circuit conditions (0: Fault not present, 1: Fault present).
  ///
  /// MAVLink type: uint16_t
  ///
  /// pdu_fault_extended
  final uint16_t pduFaultExtended;

  /// Bytes: 45-46. Central logic tracking central command processor networks tracking indices block. Bytes 49(0) to 49(2): Internal logic communication loop transceiver status indices checking network isolation drop across CAN C Bus, CAN A Bus, and CAN B Bus configurations (0: No / Clear, 1: Yes / Bus off).
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_extended
  final uint16_t powerSubsystemFaultsExtended;

  /// Bytes: 46-48. Central command processor inputs logic diagnostic status registers monitoring module block. Bytes 49(3) to 49(7): Central controller physical line data tracking checking loop registers covering failures on Discrete system inputs, Analog system inputs, High side output driver components, Low side output driver components, and global logic power supply voltage limits (0: No fault, 1: Subsystem fault present).
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_interface_health_extended
  final uint16_t vcuInterfaceHealthExtended;

  /// Bytes: 49-50. Central command processor safety watchdogs supervisor logic monitoring checklists registry. Bytes 50(0) to 50(7): Core diagnostic indicators logging internal electronic processor tracking failures including MCU hardware hardware watchdog activation, runtime CPU processing overload limits, structural volatile RAM data validation failure, non-volatile Flash memory structural CRC verification failure, FCC system active state registration flag, integrated safety SBC co-processor failure, internal structural ambient temp limits warning, and global initial boot sequence execution failure.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_bus_faults
  final uint16_t vcuBusFaults;

  /// Bytes: 49-50. Dynamic CAN interface connection lanes validation status mapping registers register block. Bytes 51(0) to 51(2): Primary logic internal interface CAN bus status routing parameters verifying transaction pathways for the primary Control CAN interface loop, the secondary Auxiliary CAN interface loop, and the dedicated mechanical Actuator CAN interface loop (0: Inactive, 1: Active).
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_internal_faults
  final uint16_t vcuInternalFaults;

  /// Bytes: 50-51. Locomotion motor controllers serial driver lane interface validation mapping logs register block. Bytes 51(3) to 51(4): Primary serial lines communication verification status tracking parameters checking data paths for the Forward motor controller serial interface loop and the Aft motor controller serial interface loop (0: Inactive, 1: Active).
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_hardware_safety
  final uint16_t vcuHardwareSafety;

  /// Bytes: 51-52. Primary logic internal communication Ethernet hardware pipeline link indicator. Byte 51(5): Primary compute node global local area network high speed Ethernet lane transaction path validation flag status (0: Inactive, 1: Active).
  ///
  /// MAVLink type: uint16_t
  ///
  /// aux_can_interfaces
  final uint16_t auxCanInterfaces;

  /// Bytes: 51-52. Co-processor computational module hardware health parameter checking logs framework block. Bytes 51(6) to 52(0): Secondary auxiliary computing system error markers tracking loop parameters monitoring CPU execution overload fault, volatile system memory allocation faults, and mass filesystem storage device data integration failure (0: No fault, 1: Fault present). Byte 52 (Bits 1-2): Secondary compute hardware platform configuration status tracking parameter (0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved).
  ///
  /// MAVLink type: uint16_t
  ///
  /// compute_node_health
  final uint16_t computeNodeHealth;

  /// Byte: 54. Primary graphics AI node computer standard interaction transaction peripheral connection verification lines. Bytes 54(0) to 54(3): Central AI processing system communication data interface pipelines tracking validation status verifying primary Control CAN lane, peripheral Auxiliary CAN lane, standard logic Ethernet interface network, and dedicated Hand Controller local serial terminal unit.
  ///
  /// MAVLink type: uint16_t
  ///
  /// jetson_interface_health
  final uint16_t jetsonInterfaceHealth;

  /// Bytes: 54-55. High speed imaging array deserializer camera lane connection validation tracking profile lines. Bytes 54(4) to 55(4): Nvidia Jetson camera streaming hardware pipelines status tracking registers checking high resolution processing nodes covering Vision dedicated Ethernet channel, and high speed serial data pipelines GMSL-1 down through GMSL-8 interface connections (0: Inactive, 1: Active).
  ///
  /// MAVLink type: uint16_t
  ///
  /// vision_gmsl_health
  final uint16_t visionGmslHealth;

  /// Byte: 10 (Bits 0-1). VCU state tracking flag (1: Idle, 2: Key On, 3: Drive). Byte 10 (Bits 2-3) Charger connected (0: Not connected, 1: Connected). Byte 10 (Bits 4-5) Charging in progress (0: Not charging, 1: Charging). Byte 10 (Bits 6-7) Tow state (0: Disengaged, 1: Engaged).
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_status
  final uint8_t vcuStatus;

  /// Byte: 12. High Voltage powertrain traction battery fuel balance metric. Returns 0-100 percentage range.
  ///
  /// MAVLink type: uint8_t
  ///
  /// battery_hv_soc
  final uint8_t batteryHvSoc;

  /// Byte: 13 (Bits 0-3). Autonomy Mode (1: Mode A, 2: Mode B, 3: Mode C, 4: Mode D, 5: Mode E). Byte 13 (Bits 4-5) Hold State (1: Disengaged, 2: Engaged). Byte 13 (Bits 6-7) Arm Mode (1: Disarmed, 2: Armed, 3: Override).
  ///
  /// MAVLink type: uint8_t
  ///
  /// comp_mode2
  final uint8_t compMode2;

  /// Byte: 15 (Bits 0-1). On-Vehicle emergency stop switch (1: Disengaged, 2: Engaged, 3: Disabled). Byte 15 (Bits 2-3) Remote emergency stop switch. Byte 15 (Bits 4-6) Selected active video camera feed stream index (1-6). Byte 15 (Bits 7) Range overlay marker status flag (0: OFF, 1: ON).
  ///
  /// MAVLink type: uint8_t
  ///
  /// sensor_subsystem_health_2
  final uint8_t sensorSubsystemHealth2;

  /// Byte: 18 (Bits 0-1). UHF Dynamic communication pipeline connection (0: Unknown, 1: Connected, 2: Disconnected). Byte 18 (Bits 2-3) UHF Radio operational health status evaluation index (0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty).
  ///
  /// MAVLink type: uint8_t
  ///
  /// sensor_subsystem_health_3
  final uint8_t sensorSubsystemHealth3;

  /// Byte: 21 (Bits 0-1). L-Band datalink quality evaluation index (0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty). Bits 21(2) to 21(6): Ethernet core network structural interface hardware pings for sensors (GNSS, L-Band, Lidars, secondary compute node). Bits 21(7) to 22(4): GNSS localization system errors (Fix validity, Fix dimension, HDOP, Satellites, Heading faults).
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_subsystem_status
  final uint8_t vcuSubsystemStatus;

  /// Byte: 40. High current distribution isolation contactor switches monitor. Bytes 44(0) to 44(5): Mechanical grid relay isolation switches status bitmask log tracking Pre-charge line, main motor controller line, input DC-DC line, HV charging line, LV charging line, and output DC-DC converter line failure status (0: No Fault / Clear, 1: Yes / Fault).
  ///
  /// MAVLink type: uint8_t
  ///
  /// sec_comp_status
  final uint8_t secCompStatus;

  /// Byte: 43. High Voltage traction battery storage frame system diagnostic parameter checking register mapping block 1. Bytes 46(0) to 47(6): HV Battery management matrix logging cell errors including cell overvoltage limits, cell undervoltage limits, total pack overvoltage, total pack undervoltage, charge loop thermal limit violation, charge loop low temp limit violation, discharge loop thermal limit, discharge loop low temp limit, charge overcurrent, discharge overcurrent, short circuit protection trigger, detection instrumentation IC failure, software safety MOS lock, cycle lifespan countdown warning, and total structural storage capacity drop (0: Fault not present, 1: Fault present).
  ///
  /// MAVLink type: uint8_t
  ///
  /// lat_placeholder
  final uint8_t latPlaceholder;

  /// Byte: 44. High Voltage traction battery storage frame system diagnostic parameter checking register mapping block 2. Byte 47(7): Low Voltage supply block battery cell deep structural depletion warning parameter state indicator (0: Fault not present, 1: Battery deeply discharged).
  ///
  /// MAVLink type: uint8_t
  ///
  /// long_placeholder
  final uint8_t longPlaceholder;

  /// Byte: 53. Primary graphics AI node computer motherboard system processing boundary validation data metrics. Bytes 53(0) to 53(3): Nvidia Jetson central command board framework checks register logging processor heartbeat framework failure, system ambient temperature range violation, logic power supply input voltage anomalies, and structural CPU load execution boundary warning.
  ///
  /// MAVLink type: uint8_t
  ///
  /// jetson_heartbeat
  final uint8_t jetsonHeartbeat;

  /// Byte: 56. Navigation coordinate parameters initialization validation status registry checklist. Byte 56(0): Home baseline positioning coordinates validation flag (0: Not set / Lock missing, 1: Locked and Set). Byte 56(1): Autonomy navigation mission trajectory target recording pathway state flag (0: OFF, 1: ON / Active saving).
  ///
  /// MAVLink type: uint8_t
  ///
  /// home_initialization
  final uint8_t homeInitialization;

  UgvSystemInfo({
    required this.motorFaults,
    required this.compInterfaceHealth2,
    required this.lat,
    required this.lon,
    required this.batterySoc,
    required this.compModel,
    required this.sensorSubsystemHealth1,
    required this.sensorSubsystemHealth4,
    required this.compSubsystemStatus,
    required this.vcuSubsystemPowerState1,
    required this.vcuPowerSubsystemState2,
    required this.validityMotorFaults,
    required this.mcFaults1,
    required this.mcFaults2,
    required this.contactorFault,
    required this.pduFault,
    required this.powerSubsystemFaults1,
    required this.powerSubsystemFaults2,
    required this.vcuInterfaceHealth,
    required this.compInterfaceHealth1,
    required this.homeLocation,
    required this.pduFaultExtended,
    required this.powerSubsystemFaultsExtended,
    required this.vcuInterfaceHealthExtended,
    required this.vcuBusFaults,
    required this.vcuInternalFaults,
    required this.vcuHardwareSafety,
    required this.auxCanInterfaces,
    required this.computeNodeHealth,
    required this.jetsonInterfaceHealth,
    required this.visionGmslHealth,
    required this.vcuStatus,
    required this.batteryHvSoc,
    required this.compMode2,
    required this.sensorSubsystemHealth2,
    required this.sensorSubsystemHealth3,
    required this.vcuSubsystemStatus,
    required this.secCompStatus,
    required this.latPlaceholder,
    required this.longPlaceholder,
    required this.jetsonHeartbeat,
    required this.homeInitialization,
  });

  UgvSystemInfo.fromJson(Map<String, dynamic> json)
      : motorFaults = json['motorFaults'],
        compInterfaceHealth2 = json['compInterfaceHealth2'],
        lat = json['lat'],
        lon = json['lon'],
        batterySoc = json['batterySoc'],
        compModel = json['compModel'],
        sensorSubsystemHealth1 = json['sensorSubsystemHealth1'],
        sensorSubsystemHealth4 = json['sensorSubsystemHealth4'],
        compSubsystemStatus = json['compSubsystemStatus'],
        vcuSubsystemPowerState1 = json['vcuSubsystemPowerState1'],
        vcuPowerSubsystemState2 = json['vcuPowerSubsystemState2'],
        validityMotorFaults = json['validityMotorFaults'],
        mcFaults1 = json['mcFaults1'],
        mcFaults2 = json['mcFaults2'],
        contactorFault = json['contactorFault'],
        pduFault = json['pduFault'],
        powerSubsystemFaults1 = json['powerSubsystemFaults1'],
        powerSubsystemFaults2 = json['powerSubsystemFaults2'],
        vcuInterfaceHealth = json['vcuInterfaceHealth'],
        compInterfaceHealth1 = json['compInterfaceHealth1'],
        homeLocation = json['homeLocation'],
        pduFaultExtended = json['pduFaultExtended'],
        powerSubsystemFaultsExtended = json['powerSubsystemFaultsExtended'],
        vcuInterfaceHealthExtended = json['vcuInterfaceHealthExtended'],
        vcuBusFaults = json['vcuBusFaults'],
        vcuInternalFaults = json['vcuInternalFaults'],
        vcuHardwareSafety = json['vcuHardwareSafety'],
        auxCanInterfaces = json['auxCanInterfaces'],
        computeNodeHealth = json['computeNodeHealth'],
        jetsonInterfaceHealth = json['jetsonInterfaceHealth'],
        visionGmslHealth = json['visionGmslHealth'],
        vcuStatus = json['vcuStatus'],
        batteryHvSoc = json['batteryHvSoc'],
        compMode2 = json['compMode2'],
        sensorSubsystemHealth2 = json['sensorSubsystemHealth2'],
        sensorSubsystemHealth3 = json['sensorSubsystemHealth3'],
        vcuSubsystemStatus = json['vcuSubsystemStatus'],
        secCompStatus = json['secCompStatus'],
        latPlaceholder = json['latPlaceholder'],
        longPlaceholder = json['longPlaceholder'],
        jetsonHeartbeat = json['jetsonHeartbeat'],
        homeInitialization = json['homeInitialization'];
  UgvSystemInfo copyWith({
    uint32_t? motorFaults,
    uint32_t? compInterfaceHealth2,
    int32_t? lat,
    int32_t? lon,
    uint16_t? batterySoc,
    uint16_t? compModel,
    uint16_t? sensorSubsystemHealth1,
    uint16_t? sensorSubsystemHealth4,
    uint16_t? compSubsystemStatus,
    uint16_t? vcuSubsystemPowerState1,
    uint16_t? vcuPowerSubsystemState2,
    uint16_t? validityMotorFaults,
    uint16_t? mcFaults1,
    uint16_t? mcFaults2,
    uint16_t? contactorFault,
    uint16_t? pduFault,
    uint16_t? powerSubsystemFaults1,
    uint16_t? powerSubsystemFaults2,
    uint16_t? vcuInterfaceHealth,
    uint16_t? compInterfaceHealth1,
    uint16_t? homeLocation,
    uint16_t? pduFaultExtended,
    uint16_t? powerSubsystemFaultsExtended,
    uint16_t? vcuInterfaceHealthExtended,
    uint16_t? vcuBusFaults,
    uint16_t? vcuInternalFaults,
    uint16_t? vcuHardwareSafety,
    uint16_t? auxCanInterfaces,
    uint16_t? computeNodeHealth,
    uint16_t? jetsonInterfaceHealth,
    uint16_t? visionGmslHealth,
    uint8_t? vcuStatus,
    uint8_t? batteryHvSoc,
    uint8_t? compMode2,
    uint8_t? sensorSubsystemHealth2,
    uint8_t? sensorSubsystemHealth3,
    uint8_t? vcuSubsystemStatus,
    uint8_t? secCompStatus,
    uint8_t? latPlaceholder,
    uint8_t? longPlaceholder,
    uint8_t? jetsonHeartbeat,
    uint8_t? homeInitialization,
  }) {
    return UgvSystemInfo(
      motorFaults: motorFaults ?? this.motorFaults,
      compInterfaceHealth2: compInterfaceHealth2 ?? this.compInterfaceHealth2,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      batterySoc: batterySoc ?? this.batterySoc,
      compModel: compModel ?? this.compModel,
      sensorSubsystemHealth1:
          sensorSubsystemHealth1 ?? this.sensorSubsystemHealth1,
      sensorSubsystemHealth4:
          sensorSubsystemHealth4 ?? this.sensorSubsystemHealth4,
      compSubsystemStatus: compSubsystemStatus ?? this.compSubsystemStatus,
      vcuSubsystemPowerState1:
          vcuSubsystemPowerState1 ?? this.vcuSubsystemPowerState1,
      vcuPowerSubsystemState2:
          vcuPowerSubsystemState2 ?? this.vcuPowerSubsystemState2,
      validityMotorFaults: validityMotorFaults ?? this.validityMotorFaults,
      mcFaults1: mcFaults1 ?? this.mcFaults1,
      mcFaults2: mcFaults2 ?? this.mcFaults2,
      contactorFault: contactorFault ?? this.contactorFault,
      pduFault: pduFault ?? this.pduFault,
      powerSubsystemFaults1:
          powerSubsystemFaults1 ?? this.powerSubsystemFaults1,
      powerSubsystemFaults2:
          powerSubsystemFaults2 ?? this.powerSubsystemFaults2,
      vcuInterfaceHealth: vcuInterfaceHealth ?? this.vcuInterfaceHealth,
      compInterfaceHealth1: compInterfaceHealth1 ?? this.compInterfaceHealth1,
      homeLocation: homeLocation ?? this.homeLocation,
      pduFaultExtended: pduFaultExtended ?? this.pduFaultExtended,
      powerSubsystemFaultsExtended:
          powerSubsystemFaultsExtended ?? this.powerSubsystemFaultsExtended,
      vcuInterfaceHealthExtended:
          vcuInterfaceHealthExtended ?? this.vcuInterfaceHealthExtended,
      vcuBusFaults: vcuBusFaults ?? this.vcuBusFaults,
      vcuInternalFaults: vcuInternalFaults ?? this.vcuInternalFaults,
      vcuHardwareSafety: vcuHardwareSafety ?? this.vcuHardwareSafety,
      auxCanInterfaces: auxCanInterfaces ?? this.auxCanInterfaces,
      computeNodeHealth: computeNodeHealth ?? this.computeNodeHealth,
      jetsonInterfaceHealth:
          jetsonInterfaceHealth ?? this.jetsonInterfaceHealth,
      visionGmslHealth: visionGmslHealth ?? this.visionGmslHealth,
      vcuStatus: vcuStatus ?? this.vcuStatus,
      batteryHvSoc: batteryHvSoc ?? this.batteryHvSoc,
      compMode2: compMode2 ?? this.compMode2,
      sensorSubsystemHealth2:
          sensorSubsystemHealth2 ?? this.sensorSubsystemHealth2,
      sensorSubsystemHealth3:
          sensorSubsystemHealth3 ?? this.sensorSubsystemHealth3,
      vcuSubsystemStatus: vcuSubsystemStatus ?? this.vcuSubsystemStatus,
      secCompStatus: secCompStatus ?? this.secCompStatus,
      latPlaceholder: latPlaceholder ?? this.latPlaceholder,
      longPlaceholder: longPlaceholder ?? this.longPlaceholder,
      jetsonHeartbeat: jetsonHeartbeat ?? this.jetsonHeartbeat,
      homeInitialization: homeInitialization ?? this.homeInitialization,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'motorFaults': motorFaults,
        'compInterfaceHealth2': compInterfaceHealth2,
        'lat': lat,
        'lon': lon,
        'batterySoc': batterySoc,
        'compModel': compModel,
        'sensorSubsystemHealth1': sensorSubsystemHealth1,
        'sensorSubsystemHealth4': sensorSubsystemHealth4,
        'compSubsystemStatus': compSubsystemStatus,
        'vcuSubsystemPowerState1': vcuSubsystemPowerState1,
        'vcuPowerSubsystemState2': vcuPowerSubsystemState2,
        'validityMotorFaults': validityMotorFaults,
        'mcFaults1': mcFaults1,
        'mcFaults2': mcFaults2,
        'contactorFault': contactorFault,
        'pduFault': pduFault,
        'powerSubsystemFaults1': powerSubsystemFaults1,
        'powerSubsystemFaults2': powerSubsystemFaults2,
        'vcuInterfaceHealth': vcuInterfaceHealth,
        'compInterfaceHealth1': compInterfaceHealth1,
        'homeLocation': homeLocation,
        'pduFaultExtended': pduFaultExtended,
        'powerSubsystemFaultsExtended': powerSubsystemFaultsExtended,
        'vcuInterfaceHealthExtended': vcuInterfaceHealthExtended,
        'vcuBusFaults': vcuBusFaults,
        'vcuInternalFaults': vcuInternalFaults,
        'vcuHardwareSafety': vcuHardwareSafety,
        'auxCanInterfaces': auxCanInterfaces,
        'computeNodeHealth': computeNodeHealth,
        'jetsonInterfaceHealth': jetsonInterfaceHealth,
        'visionGmslHealth': visionGmslHealth,
        'vcuStatus': vcuStatus,
        'batteryHvSoc': batteryHvSoc,
        'compMode2': compMode2,
        'sensorSubsystemHealth2': sensorSubsystemHealth2,
        'sensorSubsystemHealth3': sensorSubsystemHealth3,
        'vcuSubsystemStatus': vcuSubsystemStatus,
        'secCompStatus': secCompStatus,
        'latPlaceholder': latPlaceholder,
        'longPlaceholder': longPlaceholder,
        'jetsonHeartbeat': jetsonHeartbeat,
        'homeInitialization': homeInitialization,
      };

  factory UgvSystemInfo.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvSystemInfo.mavlinkEncodedLength) {
      var len = UgvSystemInfo.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var motorFaults = data_.getUint32(0, Endian.little);
    var compInterfaceHealth2 = data_.getUint32(4, Endian.little);
    var lat = data_.getInt32(8, Endian.little);
    var lon = data_.getInt32(12, Endian.little);
    var batterySoc = data_.getUint16(16, Endian.little);
    var compModel = data_.getUint16(18, Endian.little);
    var sensorSubsystemHealth1 = data_.getUint16(20, Endian.little);
    var sensorSubsystemHealth4 = data_.getUint16(22, Endian.little);
    var compSubsystemStatus = data_.getUint16(24, Endian.little);
    var vcuSubsystemPowerState1 = data_.getUint16(26, Endian.little);
    var vcuPowerSubsystemState2 = data_.getUint16(28, Endian.little);
    var validityMotorFaults = data_.getUint16(30, Endian.little);
    var mcFaults1 = data_.getUint16(32, Endian.little);
    var mcFaults2 = data_.getUint16(34, Endian.little);
    var contactorFault = data_.getUint16(36, Endian.little);
    var pduFault = data_.getUint16(38, Endian.little);
    var powerSubsystemFaults1 = data_.getUint16(40, Endian.little);
    var powerSubsystemFaults2 = data_.getUint16(42, Endian.little);
    var vcuInterfaceHealth = data_.getUint16(44, Endian.little);
    var compInterfaceHealth1 = data_.getUint16(46, Endian.little);
    var homeLocation = data_.getUint16(48, Endian.little);
    var pduFaultExtended = data_.getUint16(50, Endian.little);
    var powerSubsystemFaultsExtended = data_.getUint16(52, Endian.little);
    var vcuInterfaceHealthExtended = data_.getUint16(54, Endian.little);
    var vcuBusFaults = data_.getUint16(56, Endian.little);
    var vcuInternalFaults = data_.getUint16(58, Endian.little);
    var vcuHardwareSafety = data_.getUint16(60, Endian.little);
    var auxCanInterfaces = data_.getUint16(62, Endian.little);
    var computeNodeHealth = data_.getUint16(64, Endian.little);
    var jetsonInterfaceHealth = data_.getUint16(66, Endian.little);
    var visionGmslHealth = data_.getUint16(68, Endian.little);
    var vcuStatus = data_.getUint8(70);
    var batteryHvSoc = data_.getUint8(71);
    var compMode2 = data_.getUint8(72);
    var sensorSubsystemHealth2 = data_.getUint8(73);
    var sensorSubsystemHealth3 = data_.getUint8(74);
    var vcuSubsystemStatus = data_.getUint8(75);
    var secCompStatus = data_.getUint8(76);
    var latPlaceholder = data_.getUint8(77);
    var longPlaceholder = data_.getUint8(78);
    var jetsonHeartbeat = data_.getUint8(79);
    var homeInitialization = data_.getUint8(80);

    return UgvSystemInfo(
        motorFaults: motorFaults,
        compInterfaceHealth2: compInterfaceHealth2,
        lat: lat,
        lon: lon,
        batterySoc: batterySoc,
        compModel: compModel,
        sensorSubsystemHealth1: sensorSubsystemHealth1,
        sensorSubsystemHealth4: sensorSubsystemHealth4,
        compSubsystemStatus: compSubsystemStatus,
        vcuSubsystemPowerState1: vcuSubsystemPowerState1,
        vcuPowerSubsystemState2: vcuPowerSubsystemState2,
        validityMotorFaults: validityMotorFaults,
        mcFaults1: mcFaults1,
        mcFaults2: mcFaults2,
        contactorFault: contactorFault,
        pduFault: pduFault,
        powerSubsystemFaults1: powerSubsystemFaults1,
        powerSubsystemFaults2: powerSubsystemFaults2,
        vcuInterfaceHealth: vcuInterfaceHealth,
        compInterfaceHealth1: compInterfaceHealth1,
        homeLocation: homeLocation,
        pduFaultExtended: pduFaultExtended,
        powerSubsystemFaultsExtended: powerSubsystemFaultsExtended,
        vcuInterfaceHealthExtended: vcuInterfaceHealthExtended,
        vcuBusFaults: vcuBusFaults,
        vcuInternalFaults: vcuInternalFaults,
        vcuHardwareSafety: vcuHardwareSafety,
        auxCanInterfaces: auxCanInterfaces,
        computeNodeHealth: computeNodeHealth,
        jetsonInterfaceHealth: jetsonInterfaceHealth,
        visionGmslHealth: visionGmslHealth,
        vcuStatus: vcuStatus,
        batteryHvSoc: batteryHvSoc,
        compMode2: compMode2,
        sensorSubsystemHealth2: sensorSubsystemHealth2,
        sensorSubsystemHealth3: sensorSubsystemHealth3,
        vcuSubsystemStatus: vcuSubsystemStatus,
        secCompStatus: secCompStatus,
        latPlaceholder: latPlaceholder,
        longPlaceholder: longPlaceholder,
        jetsonHeartbeat: jetsonHeartbeat,
        homeInitialization: homeInitialization);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, motorFaults, Endian.little);
    data_.setUint32(4, compInterfaceHealth2, Endian.little);
    data_.setInt32(8, lat, Endian.little);
    data_.setInt32(12, lon, Endian.little);
    data_.setUint16(16, batterySoc, Endian.little);
    data_.setUint16(18, compModel, Endian.little);
    data_.setUint16(20, sensorSubsystemHealth1, Endian.little);
    data_.setUint16(22, sensorSubsystemHealth4, Endian.little);
    data_.setUint16(24, compSubsystemStatus, Endian.little);
    data_.setUint16(26, vcuSubsystemPowerState1, Endian.little);
    data_.setUint16(28, vcuPowerSubsystemState2, Endian.little);
    data_.setUint16(30, validityMotorFaults, Endian.little);
    data_.setUint16(32, mcFaults1, Endian.little);
    data_.setUint16(34, mcFaults2, Endian.little);
    data_.setUint16(36, contactorFault, Endian.little);
    data_.setUint16(38, pduFault, Endian.little);
    data_.setUint16(40, powerSubsystemFaults1, Endian.little);
    data_.setUint16(42, powerSubsystemFaults2, Endian.little);
    data_.setUint16(44, vcuInterfaceHealth, Endian.little);
    data_.setUint16(46, compInterfaceHealth1, Endian.little);
    data_.setUint16(48, homeLocation, Endian.little);
    data_.setUint16(50, pduFaultExtended, Endian.little);
    data_.setUint16(52, powerSubsystemFaultsExtended, Endian.little);
    data_.setUint16(54, vcuInterfaceHealthExtended, Endian.little);
    data_.setUint16(56, vcuBusFaults, Endian.little);
    data_.setUint16(58, vcuInternalFaults, Endian.little);
    data_.setUint16(60, vcuHardwareSafety, Endian.little);
    data_.setUint16(62, auxCanInterfaces, Endian.little);
    data_.setUint16(64, computeNodeHealth, Endian.little);
    data_.setUint16(66, jetsonInterfaceHealth, Endian.little);
    data_.setUint16(68, visionGmslHealth, Endian.little);
    data_.setUint8(70, vcuStatus);
    data_.setUint8(71, batteryHvSoc);
    data_.setUint8(72, compMode2);
    data_.setUint8(73, sensorSubsystemHealth2);
    data_.setUint8(74, sensorSubsystemHealth3);
    data_.setUint8(75, vcuSubsystemStatus);
    data_.setUint8(76, secCompStatus);
    data_.setUint8(77, latPlaceholder);
    data_.setUint8(78, longPlaceholder);
    data_.setUint8(79, jetsonHeartbeat);
    data_.setUint8(80, homeInitialization);
    return data_;
  }
}

/// Provides relative power-on uptime and absolute Unix Epoch timestamps from Compute node.
///
/// SYSTEM_TIME
class SystemTime implements MavlinkMessage {
  static const int msgId = 2;

  static const int crcExtra = 137;

  static const int mavlinkEncodedLength = 12;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 10-17. Unix Epoch absolute time signature tracking slot. Expression value: current global clock timestamp measured in microseconds elapsed since Jan 1, 1970 (UTC).
  ///
  /// MAVLink type: uint64_t
  ///
  /// time_unix_usec
  final uint64_t timeUnixUsec;

  /// Bytes: 18-21. Uptime counter tracking. Expression value: continuous clock tracking representing internal relative time in milliseconds since the central compute system initially initialized power-on execution.
  ///
  /// MAVLink type: uint32_t
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  SystemTime({
    required this.timeUnixUsec,
    required this.timeBootMs,
  });

  SystemTime.fromJson(Map<String, dynamic> json)
      : timeUnixUsec = json['timeUnixUsec'],
        timeBootMs = json['timeBootMs'];
  SystemTime copyWith({
    uint64_t? timeUnixUsec,
    uint32_t? timeBootMs,
  }) {
    return SystemTime(
      timeUnixUsec: timeUnixUsec ?? this.timeUnixUsec,
      timeBootMs: timeBootMs ?? this.timeBootMs,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'timeUnixUsec': timeUnixUsec,
        'timeBootMs': timeBootMs,
      };

  factory SystemTime.parse(ByteData data_) {
    if (data_.lengthInBytes < SystemTime.mavlinkEncodedLength) {
      var len = SystemTime.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeUnixUsec = BigInt.from((data_.getUint32(0, Endian.little) +
        data_.getUint32(4, Endian.little)));
    var timeBootMs = data_.getUint32(8, Endian.little);

    return SystemTime(timeUnixUsec: timeUnixUsec, timeBootMs: timeBootMs);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint64(0, timeUnixUsec.toInt(), Endian.little);
    data_.setUint32(8, timeBootMs, Endian.little);
    return data_;
  }
}

/// Unfiltered hardware localization metrics streaming direct from the tracking receiver module.
///
/// GPS_RAW_INT
class GpsRawInt implements MavlinkMessage {
  static const int msgId = 24;

  static const int crcExtra = 24;

  static const int mavlinkEncodedLength = 30;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 10-17. Microsecond precision master system navigation clock tracking loop snapshot. Returns absolute Unix Epoch time tracking parameters or time baseline directly since system initialization boot up.
  ///
  /// MAVLink type: uint64_t
  ///
  /// time_usec
  final uint64_t timeUsec;

  /// Bytes: 18-21. Latitude coordinate (WGS84). Returns true vehicle coordinates scaled directly into integer values format via mathematical factor degrees multiplied by 1E7. Expected execution boundaries range: -900000000 to 900000000.
  ///
  /// MAVLink type: int32_t
  ///
  /// lat
  final int32_t lat;

  /// Bytes: 22-25. Longitude coordinate (WGS84). Returns true vehicle coordinates scaled directly into integer values format via mathematical factor degrees multiplied by 1E7. Expected execution boundaries range: -1800000000 to 1800000000.
  ///
  /// MAVLink type: int32_t
  ///
  /// lon
  final int32_t lon;

  /// Bytes: 26-29. Altitude parameter calculated above Mean Sea Level (MSL). Expression value: returns physical distance unit value measured directly in millimeters.
  ///
  /// MAVLink type: int32_t
  ///
  /// alt
  final int32_t alt;

  /// Bytes: 30-31. Horizontal position dilution of precision (HDOP) uncertainty index parameter. Expression value: true uncertainty value multiplied by a factor constant of 100. Unknown error status value fallback returns 65535.
  ///
  /// MAVLink type: uint16_t
  ///
  /// eph
  final uint16_t eph;

  /// Bytes: 32-33. Vertical position dilution of precision (VDOP) uncertainty index parameter. Expression value: true uncertainty multiplied by 100 (Not used by Compute, defaults to constant 65535 Unknown fallback status).
  ///
  /// MAVLink type: uint16_t
  ///
  /// epv
  final uint16_t epv;

  /// Bytes: 34-35. Ground speed velocity tracking calculated by navigation hardware. Expression value: target tracking metrics returning metric values measured in centimeters per second (cm/s). Unknown status value returns 65535.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vel
  final uint16_t vel;

  /// Bytes: 36-37. Course over ground vehicle locomotion heading path alignment tracker orientation angle. Expected parameters range: 0 to 35999 centidegrees. Out of boundaries return 36000-65534, Unknown status returns 65535.
  ///
  /// MAVLink type: uint16_t
  ///
  /// cog
  final uint16_t cog;

  /// Byte: 38. Fix quality mapping index value. Mapped as: 0: GPS_FIX_TYPE_NO_GPS, 1: GPS_FIX_TYPE_NO_FIX, 2: GPS_FIX_TYPE_3D_FIX, 3: GPS_FIX_TYPE_2D_FIX, 4: GPS_FIX_TYPE_DGPS, 5: GPS_FIX_TYPE_RTK_FLOAT, 6: GPS_FIX_TYPE_RTK_FIXED. 7-255 are Invalid.
  ///
  /// MAVLink type: uint8_t
  ///
  /// fix_type
  final uint8_t fixType;

  /// Byte: 39. Total count tracking active positioning space vehicle elements locked in the tracking process loop. Returns true sat counter value tracking elements inside space arrays 0-254. Unknown status returns 255.
  ///
  /// MAVLink type: uint8_t
  ///
  /// satellites_visible
  final uint8_t satellitesVisible;

  GpsRawInt({
    required this.timeUsec,
    required this.lat,
    required this.lon,
    required this.alt,
    required this.eph,
    required this.epv,
    required this.vel,
    required this.cog,
    required this.fixType,
    required this.satellitesVisible,
  });

  GpsRawInt.fromJson(Map<String, dynamic> json)
      : timeUsec = json['timeUsec'],
        lat = json['lat'],
        lon = json['lon'],
        alt = json['alt'],
        eph = json['eph'],
        epv = json['epv'],
        vel = json['vel'],
        cog = json['cog'],
        fixType = json['fixType'],
        satellitesVisible = json['satellitesVisible'];
  GpsRawInt copyWith({
    uint64_t? timeUsec,
    int32_t? lat,
    int32_t? lon,
    int32_t? alt,
    uint16_t? eph,
    uint16_t? epv,
    uint16_t? vel,
    uint16_t? cog,
    uint8_t? fixType,
    uint8_t? satellitesVisible,
  }) {
    return GpsRawInt(
      timeUsec: timeUsec ?? this.timeUsec,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      alt: alt ?? this.alt,
      eph: eph ?? this.eph,
      epv: epv ?? this.epv,
      vel: vel ?? this.vel,
      cog: cog ?? this.cog,
      fixType: fixType ?? this.fixType,
      satellitesVisible: satellitesVisible ?? this.satellitesVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'timeUsec': timeUsec,
        'lat': lat,
        'lon': lon,
        'alt': alt,
        'eph': eph,
        'epv': epv,
        'vel': vel,
        'cog': cog,
        'fixType': fixType,
        'satellitesVisible': satellitesVisible,
      };

  factory GpsRawInt.parse(ByteData data_) {
    if (data_.lengthInBytes < GpsRawInt.mavlinkEncodedLength) {
      var len = GpsRawInt.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeUsec = BigInt.from((data_.getUint32(0, Endian.little) +
        data_.getUint32(4, Endian.little)));
    var lat = data_.getInt32(8, Endian.little);
    var lon = data_.getInt32(12, Endian.little);
    var alt = data_.getInt32(16, Endian.little);
    var eph = data_.getUint16(20, Endian.little);
    var epv = data_.getUint16(22, Endian.little);
    var vel = data_.getUint16(24, Endian.little);
    var cog = data_.getUint16(26, Endian.little);
    var fixType = data_.getUint8(28);
    var satellitesVisible = data_.getUint8(29);

    return GpsRawInt(
        timeUsec: timeUsec,
        lat: lat,
        lon: lon,
        alt: alt,
        eph: eph,
        epv: epv,
        vel: vel,
        cog: cog,
        fixType: fixType,
        satellitesVisible: satellitesVisible);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint64(0, timeUsec.toInt(), Endian.little);
    data_.setInt32(8, lat, Endian.little);
    data_.setInt32(12, lon, Endian.little);
    data_.setInt32(16, alt, Endian.little);
    data_.setUint16(20, eph, Endian.little);
    data_.setUint16(22, epv, Endian.little);
    data_.setUint16(24, vel, Endian.little);
    data_.setUint16(26, cog, Endian.little);
    data_.setUint8(28, fixType);
    data_.setUint8(29, satellitesVisible);
    return data_;
  }
}

/// Spatial dynamics orientation vector tracking relative rotational plane movements derived from the IMU hardware.
///
/// ATTITUDE
class Attitude implements MavlinkMessage {
  static const int msgId = 30;

  static const int crcExtra = 39;

  static const int mavlinkEncodedLength = 28;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Bytes: 10-13. Uptime tracking tracking index register validating timestamp inputs. Expression value: tracking elapsed time in milliseconds directly since initial compute hardware boot up.
  ///
  /// MAVLink type: uint32_t
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  /// Bytes: 14-17. Spatial vehicle roll orientation angle state vector parameter mapping. Value expected: angular metrics scaled in radians format bounding limits within parameters range -pi to +pi.
  ///
  /// MAVLink type: float
  ///
  /// roll
  final float roll;

  /// Bytes: 18-21. Spatial vehicle pitch orientation angle state vector parameter mapping. Value expected: angular metrics scaled in radians format bounding limits within parameters range -pi to +pi.
  ///
  /// MAVLink type: float
  ///
  /// pitch
  final float pitch;

  /// Bytes: 22-25. Spatial vehicle yaw orientation angle state vector parameter mapping. Value expected: angular metrics scaled in radians format bounding limits within parameters range -pi to +pi.
  ///
  /// MAVLink type: float
  ///
  /// yaw
  final float yaw;

  /// Bytes: 26-29. Spatial angular displacement rate tracking vector mapping covering system roll acceleration changes. Expected tracking values parameter boundaries match ranges limits from -2.78 to 2.78 rad/s.
  ///
  /// MAVLink type: float
  ///
  /// rollspeed
  final float rollspeed;

  /// Bytes: 30-33. Spatial angular displacement rate tracking vector mapping covering system pitch acceleration changes (Not used by Compute, hardcoded constant placeholder to NA).
  ///
  /// MAVLink type: float
  ///
  /// pitchspeed
  final float pitchspeed;

  /// Bytes: 34-37. Spatial angular displacement rate tracking vector mapping covering system yaw acceleration changes (Not used by Compute, hardcoded constant placeholder to NA).
  ///
  /// MAVLink type: float
  ///
  /// yawspeed
  final float yawspeed;

  Attitude({
    required this.timeBootMs,
    required this.roll,
    required this.pitch,
    required this.yaw,
    required this.rollspeed,
    required this.pitchspeed,
    required this.yawspeed,
  });

  Attitude.fromJson(Map<String, dynamic> json)
      : timeBootMs = json['timeBootMs'],
        roll = json['roll'],
        pitch = json['pitch'],
        yaw = json['yaw'],
        rollspeed = json['rollspeed'],
        pitchspeed = json['pitchspeed'],
        yawspeed = json['yawspeed'];
  Attitude copyWith({
    uint32_t? timeBootMs,
    float? roll,
    float? pitch,
    float? yaw,
    float? rollspeed,
    float? pitchspeed,
    float? yawspeed,
  }) {
    return Attitude(
      timeBootMs: timeBootMs ?? this.timeBootMs,
      roll: roll ?? this.roll,
      pitch: pitch ?? this.pitch,
      yaw: yaw ?? this.yaw,
      rollspeed: rollspeed ?? this.rollspeed,
      pitchspeed: pitchspeed ?? this.pitchspeed,
      yawspeed: yawspeed ?? this.yawspeed,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'timeBootMs': timeBootMs,
        'roll': roll,
        'pitch': pitch,
        'yaw': yaw,
        'rollspeed': rollspeed,
        'pitchspeed': pitchspeed,
        'yawspeed': yawspeed,
      };

  factory Attitude.parse(ByteData data_) {
    if (data_.lengthInBytes < Attitude.mavlinkEncodedLength) {
      var len = Attitude.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeBootMs = data_.getUint32(0, Endian.little);
    var roll = data_.getFloat32(4, Endian.little);
    var pitch = data_.getFloat32(8, Endian.little);
    var yaw = data_.getFloat32(12, Endian.little);
    var rollspeed = data_.getFloat32(16, Endian.little);
    var pitchspeed = data_.getFloat32(20, Endian.little);
    var yawspeed = data_.getFloat32(24, Endian.little);

    return Attitude(
        timeBootMs: timeBootMs,
        roll: roll,
        pitch: pitch,
        yaw: yaw,
        rollspeed: rollspeed,
        pitchspeed: pitchspeed,
        yawspeed: yawspeed);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timeBootMs, Endian.little);
    data_.setFloat32(4, roll, Endian.little);
    data_.setFloat32(8, pitch, Endian.little);
    data_.setFloat32(12, yaw, Endian.little);
    data_.setFloat32(16, rollspeed, Endian.little);
    data_.setFloat32(20, pitchspeed, Endian.little);
    data_.setFloat32(24, yawspeed, Endian.little);
    return data_;
  }
}

class MavlinkDialectUgvcustom implements MavlinkDialect {
  static const int mavlinkVersion = 0;

  @override
  int get version => mavlinkVersion;

  @override
  MavlinkMessage? parse(int messageID, ByteData data) {
    switch (messageID) {
      case 0:
        return Heartbeat.parse(data);
      case 111:
        return Timesync.parse(data);
      case 76:
        return CommandLong.parse(data);
      case 69:
        return ManualControl.parse(data);
      case 109:
        return RadioStatus.parse(data);
      case 50001:
        return UgvSystemInfo.parse(data);
      case 2:
        return SystemTime.parse(data);
      case 24:
        return GpsRawInt.parse(data);
      case 30:
        return Attitude.parse(data);
      default:
        return null;
    }
  }

  @override
  int crcExtra(int messageID) {
    switch (messageID) {
      case 0:
        return Heartbeat.crcExtra;
      case 111:
        return Timesync.crcExtra;
      case 76:
        return CommandLong.crcExtra;
      case 69:
        return ManualControl.crcExtra;
      case 109:
        return RadioStatus.crcExtra;
      case 50001:
        return UgvSystemInfo.crcExtra;
      case 2:
        return SystemTime.crcExtra;
      case 24:
        return GpsRawInt.crcExtra;
      case 30:
        return Attitude.crcExtra;
      default:
        return -1;
    }
  }
}

String convertMavlinkCharListToString(List<int>? charList) {
  if (charList == null) {
    return "";
  }
  List<int> trimmedName = [];
  for (int character in charList) {
    if (character != 0x00) {
      trimmedName.add(character);
    }
  }

  String decodedName = "";
  try {
    decodedName = ascii.decode(trimmedName);
  } on FormatException catch (e) {
    print("Format Excepetion on ascii converstion: $e, returning empty string");
  } catch (e) {
    print("Parse error: $e");
  }

  return decodedName;
}

Uint8List convertStringtoMavlinkCharList(String inputString, {int? length}) {
  // Use passed length if it's there otherwise just use size of the input string
  length = length ?? inputString.length;
  Uint8List charList = Uint8List(length);
  const asciiEncoder = AsciiEncoder();
  Uint8List stringAsList = asciiEncoder.convert(inputString);

  for (var i = 0; i < stringAsList.length; i++) {
    charList[i] = stringAsList[i];
  }
  return charList;
}
