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

  /// MAVLink version, not writable by user, gets added by protocol because of magic data type: uint8_t_mavlink_version
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

/// Provides aggregated health and status of all subsystems. ICD: COMP_UGV_STATUS. Direction: Compute broadcast. Frequency: 1 Hz. Payload length: 55 bytes.
///
/// UGV_SYSTEM_INFO
class UgvSystemInfo implements MavlinkMessage {
  static const int msgId = 50001;

  static const int crcExtra = 88;

  static const int mavlinkEncodedLength = 55;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Byte 19 (Bit 0): L band radio UGV Ethernet Communication fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 1): L band radio UGV Firmware fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 2): L band radio UGV Local RSSI/Noise fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 3): L band radio UGV Temperature fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 4): L band link connection Heartbeat fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 5): L band link connection Remote RSSI Fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 6): L band link health Local RSSI Fault. 0: Fault not present, 1: Fault present. Byte 19 (Bit 7): L band link health Remote RSSI Fault. 0: Fault not present, 1: Fault present. Byte 20 (Bit 0): L band link health Local noise fault. 0: Fault not present, 1: Fault present. Byte 20 (Bit 1): L band link health Remote noise fault. 0: Fault not present, 1: Fault present. Byte 20 (Bit 2): L band link health SNR Fault. 0: Fault not present, 1: Fault present. Byte 20 (Bit 3): L band link health Packet loss fault. 0: Fault not present, 1: Fault present. Byte 20 (Bit 4): L band link health Heartbeat timeout fault. 0: Fault not present, 1: Fault present. Byte 20 (Bits 5-6): L band Link connection. Range 0-3. 0: Unknown, 1: Connected, 2: Disconnected, 3: Reserved. Byte 20 (Bit 7): Reserved for future use. Byte 21 (Bits 0-1): L band link health. Range 0-3. 0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty. Byte 21 (Bit 2): Ethernet switch GNSS Ping fault. 0: Fault not present, 1: Fault present. Byte 21 (Bit 3): Ethernet switch L Band radio ping fault. 0: Fault not present, 1: Fault present. Byte 21 (Bit 4): Ethernet switch 2D Lidar ping fault. 0: Fault not present, 1: Fault present. Byte 21 (Bit 5): Ethernet switch 3d Lidar ping fault. 0: Fault not present, 1: Fault present. Byte 21 (Bit 6): Ethernet switch secondary compute ping fault. 0: Fault not present, 1: Fault present. Byte 21 (Bit 7): GNSS Position validity error fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 0): GNSS Fix quality fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 1): GNSS Fix dimension fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 2): GNSS Satellite fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 3): GNSS HDOP Fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 4): GNSS Heading validity error fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 5): IMU Communication fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 6): IMU Data integrity fault. 0: Fault not present, 1: Fault present. Byte 22 (Bit 7): 2D Lidar Communication fault. 0: Fault not present, 1: Fault present.
  ///
  /// MAVLink type: uint32_t
  ///
  /// sensor_subsystem_health_3
  final uint32_t sensorSubsystemHealth3;

  /// Byte 25 (Bits 0-1): Aft Motor controller state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 25 (Bits 2-3): Forward Motor controller state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 25 (Bits 4-5): HV Battery state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 25 (Bits 6-7): LV Battery state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 26 (Bits 0-1): LV PDU state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 26 (Bits 2-3): DC DC (48V to 12V) state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 26 (Bits 4-5): HV PDU state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 26 (Bits 6-7): Forward left motor state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 27 (Bits 0-1): Aft left motor state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 27 (Bits 2-3): Forward right motor state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 27 (Bits 4-5): Aft right motor state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 27 (Bits 6-7): Main Compute state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 28 (Bits 0-1): LV Battery Charger State. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 28 (Bits 2-3): VCU state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 28 (Bits 4-7): Reserved for future use.
  ///
  /// MAVLink type: uint32_t
  ///
  /// vcu_subsystem_status
  final uint32_t vcuSubsystemStatus;

  /// Byte 31 (Bits 0-1): Forward motor controller power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 31 (Bits 2-3): Aft motor controller power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 31 (Bits 4-5): DC DC (48 V to 12 V) power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 31 (Bits 6-7): HV PDU power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 32 (Bits 0-1): LV PDU power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 32 (Bits 2-3): UHF radio power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 32 (Bits 4-5): LBAND radio power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 32 (Bits 6-7): Ethernet switch power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 33 (Bits 0-1): GNSS power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 33 (Bits 2-3): IMU power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 33 (Bits 4-5): 2D Lidar power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 33 (Bits 6-7): 3D Lidar power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 34 (Bits 0-1): VCU power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 34 (Bits 2-3): Main compute power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 34 (Bits 4-5): Secondary compute power state. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 34 (Bits 6-7): RGBD Camera Power State. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved.
  ///
  /// MAVLink type: uint32_t
  ///
  /// vcu_subsystem_power_state1
  final uint32_t vcuSubsystemPowerState1;

  /// Byte 36 (Bit 0): Aft motor controller Aft Port Motor overspeed. 0: Fault not present, 1: Fault present. Byte 36 (Bit 1): Aft motor controller Aft Port Motor overload. 0: Fault not present, 1: Fault present. Byte 36 (Bit 2): Aft motor controller Aft Port Motor phase loss. 0: Fault not present, 1: Fault present. Byte 36 (Bit 3): Aft motor controller Aft Port Motor brake. 0: Fault not present, 1: Fault present. Byte 36 (Bit 4): Aft motor controller Aft Port Motor encoder fault. 0: Fault not present, 1: Fault present. Byte 36 (Bit 5): Aft motor controller Aft Port Motor overtemperature. 0: Fault not present, 1: Fault present. Byte 36 (Bit 6): Aft motor controller Aft Port Motor Hall fault. 0: Fault not present, 1: Fault present. Byte 36 (Bit 7): Aft motor controller Aft Port Motor stalled. 0: Fault not present, 1: Fault present. Byte 37 (Bit 0): Aft motor controller Aft starboard Motor overspeed. 0: Fault not present, 1: Fault present. Byte 37 (Bit 1): Aft motor controller Aft starboard Motor overload. 0: Fault not present, 1: Fault present. Byte 37 (Bit 2): Aft motor controller Aft starboard Motor phase loss. 0: Fault not present, 1: Fault present. Byte 37 (Bit 3): Aft motor controller Aft starboard Motor brake. 0: Fault not present, 1: Fault present. Byte 37 (Bit 4): Aft motor controller Aft starboard Motor encoder fault. 0: Fault not present, 1: Fault present. Byte 37 (Bit 5): Aft motor controller Aft starboard Motor overtemperature. 0: Fault not present, 1: Fault present. Byte 37 (Bit 6): Aft motor controller Aft starboard Motor hall fault. 0: Fault not present, 1: Fault present. Byte 37 (Bit 7): Aft motor controller Aft starboard Motor stalled. 0: Fault not present, 1: Fault present. Byte 38 (Bit 0): Forward motor controller Forward port Motor overspeed. 0: Fault not present, 1: Fault present. Byte 38 (Bit 1): Forward motor controller Forward port Motor overload. 0: Fault not present, 1: Fault present. Byte 38 (Bit 2): Forward motor controller Forward port Motor phase loss. 0: Fault not present, 1: Fault present. Byte 38 (Bit 3): Forward motor controller Forward port Motor brake. 0: Fault not present, 1: Fault present. Byte 38 (Bit 4): Forward motor controller Forward port Motor encoder fault. 0: Fault not present, 1: Fault present. Byte 38 (Bit 5): Forward motor controller Forward port Motor over temperature. 0: Fault not present, 1: Fault present. Byte 38 (Bit 6): Forward motor controller Forward port Motor Hall fault. 0: Fault not present, 1: Fault present. Byte 38 (Bit 7): Forward motor controller Forward port Motor stalled. 0: Fault not present, 1: Fault present. Byte 39 (Bit 0): Forward motor controller Forward starboard Motor overspeed. 0: Fault not present, 1: Fault present. Byte 39 (Bit 1): Forward motor controller Forward starboard Motor overload. 0: Fault not present, 1: Fault present. Byte 39 (Bit 2): Forward motor controller Forward starboard Motor phase loss. 0: Fault not present, 1: Fault present. Byte 39 (Bit 3): Forward motor controller Forward starboard Motor brake. 0: Fault not present, 1: Fault present. Byte 39 (Bit 4): Forward motor controller Forward starboard Motor encoder fault. 0: Fault not present, 1: Fault present. Byte 39 (Bit 5): Forward motor controller Forward starboard Motor over temperature. 0: Fault not present, 1: Fault present. Byte 39 (Bit 6): Forward motor controller Forward starboard Motor hall fault. 0: Fault not present, 1: Fault present. Byte 39 (Bit 7): Forward motor controller Forward starboard Motor stalled. 0: Fault not present, 1: Fault present.
  ///
  /// MAVLink type: uint32_t
  ///
  /// motor_faults
  final uint32_t motorFaults;

  /// Bytes 57-60. Range -900000000 to 900000000. If Byte 56 (Bit 0) is set to 1, then lat value is valid. Scale = 1e-7.
  ///
  /// MAVLink type: int32_t
  ///
  /// lat
  final int32_t lat;

  /// Bytes 61-64. Range -1800000000 to 1800000000. If Byte 56 (Bit 0) is set to 1, then long value is valid. Scale = 1e-7.
  ///
  /// MAVLink type: int32_t
  ///
  /// lon
  final int32_t lon;

  /// Byte 11: LV battery SoC. Range 0-255. 0-100: valid percentage, 101-255: Invalid. Byte 12: HV battery SoC. Range 0-255. 0-100: valid percentage, 101-255: Invalid.
  ///
  /// MAVLink type: uint16_t
  ///
  /// battery_soc
  final uint16_t batterySoc;

  /// Byte 13 (Bits 0-3): Autonomy Mode. Range 0-15. 1: Mode A, 2: Mode B, 3: Mode C, 4: Mode D, 5: Mode E, 0 and 6-15: reserved. Byte 13 (Bits 4-5): Hold State. Range 0-3. 1: Disengaged, 2: Engaged, 0 and 3: Reserved. Byte 13 (Bits 6-7): Arm mode. Range 0-3. 1: Disarmed, 2: Armed, 3: Override, 0: Reserved. Byte 14 (Bits 0-3): Drive mode limit. Range 0-15. 1: Low, 2: Medium, 3: High, 0 and 4-15: reserved. Byte 14 (Bits 4-7): Drive Mode. Range 0-15. 1: Speed mode, 2: Torque mode, 3: Torque with speed limit, 0 and 4-15: reserved.
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_mode1
  final uint16_t compMode1;

  /// Byte 16 (Bit 0): UHF Radio Fault UART communication fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 1): UHF Radio fault Firmware fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 2): UHF Radio Fault Local RSSI/Noise fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 3): UHF Radio fault Temperature fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 4): UHF Link connection Heartbeat fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 5): UHF Link connection Remote RSSI fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 6): UHF Link Health Local RSSI Fault. 0: Fault not present, 1: Fault present. Byte 16 (Bit 7): UHF Link Health Remote RSSI Fault. 0: Fault not present, 1: Fault present. Byte 17 (Bit 0): UHF Link Health Local noise fault. 0: Fault not present, 1: Fault present. Byte 17 (Bit 1): UHF Link Health Remote noise fault. 0: Fault not present, 1: Fault present. Byte 17 (Bit 2): UHF Link Health SNR Fault. 0: Fault not present, 1: Fault present. Byte 17 (Bit 3): UHF Link Health Packet loss fault. 0: Fault not present, 1: Fault present. Byte 17 (Bit 4): UHF Link Health Heartbeat timeout fault. 0: Fault not present, 1: Fault present. Byte 17 (Bits 5-7): Reserved for future use.
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_1
  final uint16_t sensorSubsystemHealth1;

  /// Byte 23 (Bit 0): 2D Lidar Data integrity fault. 0: Fault not present, 1: Fault present. Byte 23 (Bit 1): 3D Lidar Communication fault. 0: Fault not present, 1: Fault present. Byte 23 (Bits 2-3): Forward-single camera Fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 23 (Bits 4-5): Forward-composite Camera fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 23 (Bits 6-7): Port Camera fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 24 (Bits 0-1): Starboard Camera fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 24 (Bits 2-3): Rear Camera fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 24 (Bits 4-5): Forward day/night Camera fault. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 24 (Bit 6): 3D Lidar Data integrity fault. 0: Fault not present, 1: Fault present. Byte 24 (Bit 7): Reserved for future use.
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_4
  final uint16_t sensorSubsystemHealth4;

  /// Byte 29 (Bits 0-1): UHF Radio - UGV State. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 29 (Bits 2-3): LBAND radio state. Range 0-3. 0: Unknown, 1: False, 2: True, 3: Reserved. Byte 29 (Bits 4-5): Ethernet switch state. Range 0-3. 0: Unknown, 1: False, 2: True, 3: Reserved. Byte 29 (Bits 6-7): GNSS state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 30 (Bits 0-1): IMU state. Range 0-3. 0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty. Byte 30 (Bits 2-3): 2D lidar state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 30 (Bits 4-5): 3D lidar state. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 30 (Bits 6-7): Reserved for future use.
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_subsystem_status
  final uint16_t compSubsystemStatus;

  /// Byte 41 (Bit 0): Aft motor controller Drive failure. 0: Fault not present, 1: Fault present. Byte 41 (Bit 1): Aft motor controller Overcurrent. 0: Fault not present, 1: Fault present. Byte 41 (Bit 2): Aft motor controller Overvoltage. 0: Fault not present, 1: Fault present. Byte 41 (Bit 3): Aft motor controller Under voltage. 0: Fault not present, 1: Fault present. Byte 41 (Bit 4): Aft motor controller UART Communication failure. 0: Fault not present, 1: Fault present. Byte 41 (Bit 5): Aft motor controller DC Bus voltage. 0: Fault not present, 1: Fault present. Byte 41 (Bit 6): Aft motor controller Over temperature. 0: Fault not present, 1: Fault present. Byte 41 (Bit 7): Aft motor controller CAN communication fault. 0: Fault not present, 1: Fault present. Byte 42 (Bit 0): Forward motor controller Drive failure. 0: Fault not present, 1: Fault present. Byte 42 (Bit 1): Forward motor controller Overcurrent. 0: Fault not present, 1: Fault present. Byte 42 (Bit 2): Forward motor controller Overvoltage. 0: Fault not present, 1: Fault present. Byte 42 (Bit 3): Forward motor controller Under voltage. 0: Fault not present, 1: Fault present. Byte 42 (Bit 4): Forward motor controller UART communication failure. 0: Fault not present, 1: Fault present. Byte 42 (Bit 5): Forward motor controller DC bus voltage. 0: Fault not present, 1: Fault present. Byte 42 (Bit 6): Forward motor controller Over temperature. 0: Fault not present, 1: Fault present. Byte 42 (Bit 7): Forward motor controller CAN communication loss. 0: Fault not present, 1: Fault present.
  ///
  /// MAVLink type: uint16_t
  ///
  /// mc_faults_1
  final uint16_t mcFaults1;

  /// Byte 46 (Bit 0): HV battery Single cell overvoltage. 0: Fault not present, 1: Fault present. Byte 46 (Bit 1): HV battery Single cell undervoltage. 0: Fault not present, 1: Fault present. Byte 46 (Bit 2): HV battery Pack overvoltage. 0: Fault not present, 1: Fault present. Byte 46 (Bit 3): HV battery Pack undervoltage. 0: Fault not present, 1: Fault present. Byte 46 (Bit 4): HV battery Charge over temperature. 0: Fault not present, 1: Fault present. Byte 46 (Bit 5): HV battery Charge low temperature. 0: Fault not present, 1: Fault present. Byte 46 (Bit 6): HV battery Discharge over temperature. 0: Fault not present, 1: Fault present. Byte 46 (Bit 7): HV battery Discharge low temperature. 0: Fault not present, 1: Fault present. Byte 47 (Bit 0): HV battery Charge overcurrent. 0: Fault not present, 1: Fault present. Byte 47 (Bit 1): HV battery Discharge overcurrent. 0: Fault not present, 1: Fault present. Byte 47 (Bit 2): HV battery Short circuit protection. 0: Fault not present, 1: Fault present. Byte 47 (Bit 3): HV battery Forward detection IC error. 0: Fault not present, 1: Fault present. Byte 47 (Bit 4): HV battery Software lock MOS. 0: Fault not present, 1: Fault present. Byte 47 (Bit 5): HV Battery Cycle life fault. 0: Fault not present, 1: Fault Present. Byte 47 (Bit 6): HV Battery Capacity fault. 0: Fault not present, 1: Fault Present. Byte 47 (Bit 7): LV Battery Battery deeply discharged. 0: Fault not present, 1: Fault Present.
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults1
  final uint16_t powerSubsystemFaults1;

  /// Byte 49 (Bit 0): CAN C Bus off. 0: No, 1: Yes. Byte 49 (Bit 1): CAN A Bus off. 0: No, 1: Yes. Byte 49 (Bit 2): CAN B Bus off. 0: No, 1: Yes. Byte 49 (Bit 3): Status of the Discete inputs fault. 0: No fault, 1: Fault. Byte 49 (Bit 4): Status of the Analog inputs fault. 0: No fault, 1: Fault. Byte 49 (Bit 5): Status of the High side output drivers fault. 0: No fault, 1: Fault. Byte 49 (Bit 6): Status of the Low side output drivers fault. 0: No fault, 1: Fault. Byte 49 (Bit 7): Supply voltage fault. 0: No fault, 1: Fault. Byte 50 (Bit 0): MCU watchdog fault. 0: No Fault, 1: Fault. Byte 50 (Bit 1): CPU Overload. 0: No, 1: Yes. Byte 50 (Bit 2): RAM fault. 0: No fault, 1: Fault. Byte 50 (Bit 3): Flash CRC Failure. 0: No Fault, 1: Fault. Byte 50 (Bit 4): FCC Active. 0: Active, 1: Inactive. Byte 50 (Bit 5): Safety SBC Fault. 0: No fault, 1: Fault. Byte 50 (Bit 6): Internal Temperature fault. 0: No fault, 1: Fault. Byte 50 (Bit 7): Boot Failure. 0: No fault, 1: Fault.
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_interface_health
  final uint16_t vcuInterfaceHealth;

  /// Byte 51 (Bit 0): Status of the Control CAN interface. 0: Inactive, 1: Active. Byte 51 (Bit 1): Status of the Auxiliary CAN interface. 0: Inactive, 1: Active. Byte 51 (Bit 2): Status of the Actuator CAN interface. 0: Inactive, 1: Active. Byte 51 (Bit 3): Status of the Forward motor controller serial interface. 0: Inactive, 1: Active. Byte 51 (Bit 4): Status of the Aft motor controller serial interface. 0: Inactive, 1: Active. Byte 51 (Bit 5): Status of the ethernet interface. 0: Inactive, 1: Active. Byte 51 (Bit 6): CPU load fault. 0: No fault, 1: Fault. Byte 51 (Bit 7): Memory fault. 0: No fault, 1: Fault. Byte 52 (Bit 0): Storage fault. 0: No fault, 1: Fault. Byte 52 (Bits 1-2): Secondary compute State. Range 0-3. 0: Unknown, 1: Healthy, 2: Faulty, 3: Reserved. Byte 52 (Bits 3-7): Reserved for future use.
  ///
  /// MAVLink type: uint16_t
  ///
  /// sec_comp_status
  final uint16_t secCompStatus;

  /// Byte 54 (Bit 0): Status of the Control CAN interface. 0: Inactive, 1: Active. Byte 54 (Bit 1): Status of the Auxiliary CAN interface. 0: Inactive, 1: Active. Byte 54 (Bit 2): Status of the Ethernet interface. 0: Inactive, 1: Active. Byte 54 (Bit 3): Status of Hand Controller Serial interface. 0: Inactive, 1: Active. Byte 54 (Bit 4): Vision Ethernet interface health. 0: Inactive, 1: Active. Byte 54 (Bit 5): Vision GMSL-1 interface health. 0: Inactive, 1: Active. Byte 54 (Bit 6): Vision GMSL-2 interface health. 0: Inactive, 1: Active. Byte 54 (Bit 7): Vision GMSL-3 interface health. 0: Inactive, 1: Active. Byte 55 (Bit 0): Vision GMSL-4 interface health. 0: Inactive, 1: Active. Byte 55 (Bit 1): Vision GMSL-5 interface health. 0: Inactive, 1: Active. Byte 55 (Bit 2): Vision GMSL-6 interface health. 0: Inactive, 1: Active. Byte 55 (Bit 3): Vision GMSL-7 interface health. 0: Inactive, 1: Active. Byte 55 (Bit 4): Vision GMSL-8 interface health. 0: Inactive, 1: Active. Byte 55 (Bits 5-7): Reserved for future use.
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_interface_health2
  final uint16_t compInterfaceHealth2;

  /// Byte 10 (Bits 0-1): VCU operational state. Range 0-3. 0: reserved, 1: Idle, 2: Key On, 3: Drive. Byte 10 (Bits 2-3): Charger connected state. Range 0-3. 0: Not connected, 1: connected, 2-3: Reserved. Byte 10 (Bits 4-5): Charging in progress state. Range 0-3. 0: Not charging, 1: Charging, 2-3: Reserved. Byte 10 (Bits 6-7): Tow state. Range 0-3. 0: Disengaged, 1: Engaged, 2-3: Reserved.
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_status
  final uint8_t vcuStatus;

  /// Byte 15 (Bits 0-1): On Vehicle emergency stop. Range 0-3. 1: Disengaged, 2: Engaged, 3: Disabled, 0: Reserved. Byte 15 (Bits 2-3): Remote emergency stop. Range 0-3. 1: Disengaged, 2: Engaged, 3: Disabled, 0: Reserved. Byte 15 (Bits 4-6): Selected camera stream. Range 0-7. 0: Reserved, 1: Forward single camera, 2: Port Camera, 3: Starboard camera, 4: Aft camera, 5: Day/Night camera, 6: Forward Composite camera, 7: Invalid. Byte 15 (Bit 7): Selected camera range marker on/off status. Range 0-1. 0: Range marker off, 1: Range marker on.
  ///
  /// MAVLink type: uint8_t
  ///
  /// comp_mode2
  final uint8_t compMode2;

  /// Byte 18 (Bits 0-1): UHF Link connection. Range 0-3. 0: Unknown, 1: Connected, 2: Disconnected, 3: Reserved. Byte 18 (Bits 2-3): UHF Link health. Range 0-3. 0: Unknown, 1: Healthy, 2: Degraded, 3: Faulty. Byte 18 (Bits 4-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// sensor_subsystem_health_2
  final uint8_t sensorSubsystemHealth2;

  /// Byte 35 (Bits 0-1): Head lights State. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 35 (Bits 2-3): Aft lights State. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 35 (Bits 4-5): Fog lights State. Range 0-3. 0: Unknown, 1: ON, 2: OFF, 3: Reserved. Byte 35 (Bits 6-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_power_subsystem_state2
  final uint8_t vcuPowerSubsystemState2;

  /// Byte 40 (Bit 0): Validity of the data of Aft motor. 0: Valid, 1: Invalid. Byte 40 (Bit 1): Validity of the data of Forward motor. 0: Valid, 1: Invalid. Byte 40 (Bits 2-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// validity_motor_faults
  final uint8_t validityMotorFaults;

  /// Byte 43 (Bit 0): Validity of the data of Aft motor controller. 0: Valid, 1: Invalid. Byte 43 (Bit 1): Validity of the data of Forward motor controller. 0: Valid, 1: Invalid. Byte 43 (Bits 2-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// mc_faults_2
  final uint8_t mcFaults2;

  /// Byte 44 (Bit 0): Pre-charge Contactor fault. 0: No, 1: Yes. Byte 44 (Bit 1): Motor controller contactor fault. 0: No, 1: Yes. Byte 44 (Bit 2): I/P DC-DC Contactor fault. 0: No, 1: Yes. Byte 44 (Bit 3): HV Charging contactor fault. 0: No, 1: Yes. Byte 44 (Bit 4): LV Charging contactor fault. 0: No, 1: Yes. Byte 44 (Bit 5): O/P DC-DC Contactor fault. 0: No, 1: Yes. Byte 44 (Bits 6-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// contactor_fault
  final uint8_t contactorFault;

  /// Byte 45 (Bit 0): Channel 1 Fault state. 0: No, 1: Fault. Byte 45 (Bit 1): Channel 2 Fault state. 0: No fault, 1: Fault. Byte 45 (Bit 2): Channel 3 Fault state. 0: No fault, 1: Fault. Byte 45 (Bit 3): Channel 4 Fault state. 0: No fault, 1: Fault. Byte 45 (Bit 4): Channel 5 Fault state. 0: No fault, 1: Fault. Byte 45 (Bit 5): Channel 6 Fault State. 0: No Fault, 1: Fault. Byte 45 (Bit 6): Channel 7 Fault state. 0: No fault, 1: Fault. Byte 45 (Bit 7): Channel 8 Fault state. 0: No Fault, 1: Fault.
  ///
  /// MAVLink type: uint8_t
  ///
  /// pdu_fault
  final uint8_t pduFault;

  /// Byte 48 (Bit 0): LV Battery Under voltage. 0: Fault not present, 1: Fault Present. Byte 48 (Bit 1): LV Battery Over Voltage. 0: Fault not present, 1: Fault Present. Byte 48 (Bit 2): LV Battery Load fault. 0: Fault not present, 1: Fault Present. Byte 48 (Bits 3-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// power_subsystem_faults2
  final uint8_t powerSubsystemFaults2;

  /// Byte 53 (Bit 0): Jetson Heartbeat. 0: Fault not present, 1: Fault present. Byte 53 (Bit 1): Temperature fault. 0: Fault not present, 1: Fault present. Byte 53 (Bit 2): Voltage Fault. 0: Fault not present, 1: Fault present. Byte 53 (Bit 3): CPU load fault. 0: Fault not present, 1: Fault present. Byte 53 (Bits 4-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// comp_interface_health1
  final uint8_t compInterfaceHealth1;

  /// Byte 56 (Bit 0): Home location status. 0: Not set, 1: Set. Byte 56 (Bit 1): Path saving status. 0: OFF, 1: ON. Byte 56 (Bits 2-7): Reserved for future use.
  ///
  /// MAVLink type: uint8_t
  ///
  /// home_location
  final uint8_t homeLocation;

  UgvSystemInfo({
    required this.sensorSubsystemHealth3,
    required this.vcuSubsystemStatus,
    required this.vcuSubsystemPowerState1,
    required this.motorFaults,
    required this.lat,
    required this.lon,
    required this.batterySoc,
    required this.compMode1,
    required this.sensorSubsystemHealth1,
    required this.sensorSubsystemHealth4,
    required this.compSubsystemStatus,
    required this.mcFaults1,
    required this.powerSubsystemFaults1,
    required this.vcuInterfaceHealth,
    required this.secCompStatus,
    required this.compInterfaceHealth2,
    required this.vcuStatus,
    required this.compMode2,
    required this.sensorSubsystemHealth2,
    required this.vcuPowerSubsystemState2,
    required this.validityMotorFaults,
    required this.mcFaults2,
    required this.contactorFault,
    required this.pduFault,
    required this.powerSubsystemFaults2,
    required this.compInterfaceHealth1,
    required this.homeLocation,
  });

  UgvSystemInfo.fromJson(Map<String, dynamic> json)
      : sensorSubsystemHealth3 = json['sensorSubsystemHealth3'],
        vcuSubsystemStatus = json['vcuSubsystemStatus'],
        vcuSubsystemPowerState1 = json['vcuSubsystemPowerState1'],
        motorFaults = json['motorFaults'],
        lat = json['lat'],
        lon = json['lon'],
        batterySoc = json['batterySoc'],
        compMode1 = json['compMode1'],
        sensorSubsystemHealth1 = json['sensorSubsystemHealth1'],
        sensorSubsystemHealth4 = json['sensorSubsystemHealth4'],
        compSubsystemStatus = json['compSubsystemStatus'],
        mcFaults1 = json['mcFaults1'],
        powerSubsystemFaults1 = json['powerSubsystemFaults1'],
        vcuInterfaceHealth = json['vcuInterfaceHealth'],
        secCompStatus = json['secCompStatus'],
        compInterfaceHealth2 = json['compInterfaceHealth2'],
        vcuStatus = json['vcuStatus'],
        compMode2 = json['compMode2'],
        sensorSubsystemHealth2 = json['sensorSubsystemHealth2'],
        vcuPowerSubsystemState2 = json['vcuPowerSubsystemState2'],
        validityMotorFaults = json['validityMotorFaults'],
        mcFaults2 = json['mcFaults2'],
        contactorFault = json['contactorFault'],
        pduFault = json['pduFault'],
        powerSubsystemFaults2 = json['powerSubsystemFaults2'],
        compInterfaceHealth1 = json['compInterfaceHealth1'],
        homeLocation = json['homeLocation'];
  UgvSystemInfo copyWith({
    uint32_t? sensorSubsystemHealth3,
    uint32_t? vcuSubsystemStatus,
    uint32_t? vcuSubsystemPowerState1,
    uint32_t? motorFaults,
    int32_t? lat,
    int32_t? lon,
    uint16_t? batterySoc,
    uint16_t? compMode1,
    uint16_t? sensorSubsystemHealth1,
    uint16_t? sensorSubsystemHealth4,
    uint16_t? compSubsystemStatus,
    uint16_t? mcFaults1,
    uint16_t? powerSubsystemFaults1,
    uint16_t? vcuInterfaceHealth,
    uint16_t? secCompStatus,
    uint16_t? compInterfaceHealth2,
    uint8_t? vcuStatus,
    uint8_t? compMode2,
    uint8_t? sensorSubsystemHealth2,
    uint8_t? vcuPowerSubsystemState2,
    uint8_t? validityMotorFaults,
    uint8_t? mcFaults2,
    uint8_t? contactorFault,
    uint8_t? pduFault,
    uint8_t? powerSubsystemFaults2,
    uint8_t? compInterfaceHealth1,
    uint8_t? homeLocation,
  }) {
    return UgvSystemInfo(
      sensorSubsystemHealth3:
          sensorSubsystemHealth3 ?? this.sensorSubsystemHealth3,
      vcuSubsystemStatus: vcuSubsystemStatus ?? this.vcuSubsystemStatus,
      vcuSubsystemPowerState1:
          vcuSubsystemPowerState1 ?? this.vcuSubsystemPowerState1,
      motorFaults: motorFaults ?? this.motorFaults,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      batterySoc: batterySoc ?? this.batterySoc,
      compMode1: compMode1 ?? this.compMode1,
      sensorSubsystemHealth1:
          sensorSubsystemHealth1 ?? this.sensorSubsystemHealth1,
      sensorSubsystemHealth4:
          sensorSubsystemHealth4 ?? this.sensorSubsystemHealth4,
      compSubsystemStatus: compSubsystemStatus ?? this.compSubsystemStatus,
      mcFaults1: mcFaults1 ?? this.mcFaults1,
      powerSubsystemFaults1:
          powerSubsystemFaults1 ?? this.powerSubsystemFaults1,
      vcuInterfaceHealth: vcuInterfaceHealth ?? this.vcuInterfaceHealth,
      secCompStatus: secCompStatus ?? this.secCompStatus,
      compInterfaceHealth2: compInterfaceHealth2 ?? this.compInterfaceHealth2,
      vcuStatus: vcuStatus ?? this.vcuStatus,
      compMode2: compMode2 ?? this.compMode2,
      sensorSubsystemHealth2:
          sensorSubsystemHealth2 ?? this.sensorSubsystemHealth2,
      vcuPowerSubsystemState2:
          vcuPowerSubsystemState2 ?? this.vcuPowerSubsystemState2,
      validityMotorFaults: validityMotorFaults ?? this.validityMotorFaults,
      mcFaults2: mcFaults2 ?? this.mcFaults2,
      contactorFault: contactorFault ?? this.contactorFault,
      pduFault: pduFault ?? this.pduFault,
      powerSubsystemFaults2:
          powerSubsystemFaults2 ?? this.powerSubsystemFaults2,
      compInterfaceHealth1: compInterfaceHealth1 ?? this.compInterfaceHealth1,
      homeLocation: homeLocation ?? this.homeLocation,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'sensorSubsystemHealth3': sensorSubsystemHealth3,
        'vcuSubsystemStatus': vcuSubsystemStatus,
        'vcuSubsystemPowerState1': vcuSubsystemPowerState1,
        'motorFaults': motorFaults,
        'lat': lat,
        'lon': lon,
        'batterySoc': batterySoc,
        'compMode1': compMode1,
        'sensorSubsystemHealth1': sensorSubsystemHealth1,
        'sensorSubsystemHealth4': sensorSubsystemHealth4,
        'compSubsystemStatus': compSubsystemStatus,
        'mcFaults1': mcFaults1,
        'powerSubsystemFaults1': powerSubsystemFaults1,
        'vcuInterfaceHealth': vcuInterfaceHealth,
        'secCompStatus': secCompStatus,
        'compInterfaceHealth2': compInterfaceHealth2,
        'vcuStatus': vcuStatus,
        'compMode2': compMode2,
        'sensorSubsystemHealth2': sensorSubsystemHealth2,
        'vcuPowerSubsystemState2': vcuPowerSubsystemState2,
        'validityMotorFaults': validityMotorFaults,
        'mcFaults2': mcFaults2,
        'contactorFault': contactorFault,
        'pduFault': pduFault,
        'powerSubsystemFaults2': powerSubsystemFaults2,
        'compInterfaceHealth1': compInterfaceHealth1,
        'homeLocation': homeLocation,
      };

  factory UgvSystemInfo.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvSystemInfo.mavlinkEncodedLength) {
      var len = UgvSystemInfo.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var sensorSubsystemHealth3 = data_.getUint32(0, Endian.little);
    var vcuSubsystemStatus = data_.getUint32(4, Endian.little);
    var vcuSubsystemPowerState1 = data_.getUint32(8, Endian.little);
    var motorFaults = data_.getUint32(12, Endian.little);
    var lat = data_.getInt32(16, Endian.little);
    var lon = data_.getInt32(20, Endian.little);
    var batterySoc = data_.getUint16(24, Endian.little);
    var compMode1 = data_.getUint16(26, Endian.little);
    var sensorSubsystemHealth1 = data_.getUint16(28, Endian.little);
    var sensorSubsystemHealth4 = data_.getUint16(30, Endian.little);
    var compSubsystemStatus = data_.getUint16(32, Endian.little);
    var mcFaults1 = data_.getUint16(34, Endian.little);
    var powerSubsystemFaults1 = data_.getUint16(36, Endian.little);
    var vcuInterfaceHealth = data_.getUint16(38, Endian.little);
    var secCompStatus = data_.getUint16(40, Endian.little);
    var compInterfaceHealth2 = data_.getUint16(42, Endian.little);
    var vcuStatus = data_.getUint8(44);
    var compMode2 = data_.getUint8(45);
    var sensorSubsystemHealth2 = data_.getUint8(46);
    var vcuPowerSubsystemState2 = data_.getUint8(47);
    var validityMotorFaults = data_.getUint8(48);
    var mcFaults2 = data_.getUint8(49);
    var contactorFault = data_.getUint8(50);
    var pduFault = data_.getUint8(51);
    var powerSubsystemFaults2 = data_.getUint8(52);
    var compInterfaceHealth1 = data_.getUint8(53);
    var homeLocation = data_.getUint8(54);

    return UgvSystemInfo(
        sensorSubsystemHealth3: sensorSubsystemHealth3,
        vcuSubsystemStatus: vcuSubsystemStatus,
        vcuSubsystemPowerState1: vcuSubsystemPowerState1,
        motorFaults: motorFaults,
        lat: lat,
        lon: lon,
        batterySoc: batterySoc,
        compMode1: compMode1,
        sensorSubsystemHealth1: sensorSubsystemHealth1,
        sensorSubsystemHealth4: sensorSubsystemHealth4,
        compSubsystemStatus: compSubsystemStatus,
        mcFaults1: mcFaults1,
        powerSubsystemFaults1: powerSubsystemFaults1,
        vcuInterfaceHealth: vcuInterfaceHealth,
        secCompStatus: secCompStatus,
        compInterfaceHealth2: compInterfaceHealth2,
        vcuStatus: vcuStatus,
        compMode2: compMode2,
        sensorSubsystemHealth2: sensorSubsystemHealth2,
        vcuPowerSubsystemState2: vcuPowerSubsystemState2,
        validityMotorFaults: validityMotorFaults,
        mcFaults2: mcFaults2,
        contactorFault: contactorFault,
        pduFault: pduFault,
        powerSubsystemFaults2: powerSubsystemFaults2,
        compInterfaceHealth1: compInterfaceHealth1,
        homeLocation: homeLocation);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, sensorSubsystemHealth3, Endian.little);
    data_.setUint32(4, vcuSubsystemStatus, Endian.little);
    data_.setUint32(8, vcuSubsystemPowerState1, Endian.little);
    data_.setUint32(12, motorFaults, Endian.little);
    data_.setInt32(16, lat, Endian.little);
    data_.setInt32(20, lon, Endian.little);
    data_.setUint16(24, batterySoc, Endian.little);
    data_.setUint16(26, compMode1, Endian.little);
    data_.setUint16(28, sensorSubsystemHealth1, Endian.little);
    data_.setUint16(30, sensorSubsystemHealth4, Endian.little);
    data_.setUint16(32, compSubsystemStatus, Endian.little);
    data_.setUint16(34, mcFaults1, Endian.little);
    data_.setUint16(36, powerSubsystemFaults1, Endian.little);
    data_.setUint16(38, vcuInterfaceHealth, Endian.little);
    data_.setUint16(40, secCompStatus, Endian.little);
    data_.setUint16(42, compInterfaceHealth2, Endian.little);
    data_.setUint8(44, vcuStatus);
    data_.setUint8(45, compMode2);
    data_.setUint8(46, sensorSubsystemHealth2);
    data_.setUint8(47, vcuPowerSubsystemState2);
    data_.setUint8(48, validityMotorFaults);
    data_.setUint8(49, mcFaults2);
    data_.setUint8(50, contactorFault);
    data_.setUint8(51, pduFault);
    data_.setUint8(52, powerSubsystemFaults2);
    data_.setUint8(53, compInterfaceHealth1);
    data_.setUint8(54, homeLocation);
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
