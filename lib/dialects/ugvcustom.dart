import 'dart:typed_data';
import 'package:mavlink_dart/mavlink_dialect.dart';
import 'package:mavlink_dart/mavlink_message.dart';
import 'package:mavlink_dart/types.dart';
import 'dart:convert';

///
/// MAV_COMPONENT
typedef MavComponent = int;

/// Ground Control Station (GCS) Component ID.
///
/// MAV_COMP_ID_MISSIONPLANNER
const MavComponent mavCompIdMissionplanner = 190;

/// Compute Node (COMP) Component ID on the UGV.
///
/// MAV_COMP_ID_ONBOARD_COMPUTER
const MavComponent mavCompIdOnboardComputer = 191;

///
/// MAV_TYPE
typedef MavType = int;

/// Ground control station.
///
/// MAV_TYPE_GCS
const MavType mavTypeGcs = 6;

/// Onboard computer component.
///
/// MAV_TYPE_ONBOARD_CONTROLLER
const MavType mavTypeOnboardController = 18;

///
/// MAV_AUTOPILOT
typedef MavAutopilot = int;

/// No autopilot, generic system node.
///
/// MAV_AUTOPILOT_INVALID
const MavAutopilot mavAutopilotInvalid = 8;

///
/// MAV_MODE_FLAG
typedef MavModeFlag = int;

/// Custom mode parameters active.
///
/// MAV_MODE_FLAG_CUSTOM_MODE_ENABLED
const MavModeFlag mavModeFlagCustomModeEnabled = 1;

///
/// MAV_STATE
typedef MavState = int;

/// System is grounded and facing standby checks.
///
/// MAV_STATE_STANDBY
const MavState mavStateStandby = 3;

/// System is actively running operations.
///
/// MAV_STATE_ACTIVE
const MavState mavStateActive = 4;

///
/// MAV_CMD
typedef MavCmd = int;

/// Sets the custom operational mode state.
///
/// MAV_CMD_DO_SET_MODE
const MavCmd mavCmdDoSetMode = 176;

/// Sets or resets home coordinate boundaries.
///
/// MAV_CMD_DO_SET_HOME
const MavCmd mavCmdDoSetHome = 179;

/// Arms or disarms the actuator control modules.
///
/// MAV_CMD_COMPONENT_ARM_DISARM
const MavCmd mavCmdComponentArmDisarm = 400;

/// Sets the drive speed loop rules and configurations.
///
/// MAV_CMD_DRIVE_MODE
const MavCmd mavCmdDriveMode = 31900;

/// Toggles light module electrical relays on/off.
///
/// MAV_CMD_LIGHT_CONTROL
const MavCmd mavCmdLightControl = 31901;

/// Controls target active video feeds and marker overlays.
///
/// MAV_CMD_CAMERA_MARKER_CONTROL
const MavCmd mavCmdCameraMarkerControl = 31902;

/// Forces emergency deceleration and engine cutoff loop.
///
/// MAV_CMD_EMERGENCY_STOP
const MavCmd mavCmdEmergencyStop = 31904;

///
/// GPS_FIX_TYPE
typedef GpsFixType = int;

/// No GPS connected.
///
/// GPS_FIX_TYPE_NO_GPS
const GpsFixType gpsFixTypeNoGps = 0;

/// GPS connected, no fix achieved.
///
/// GPS_FIX_TYPE_NO_FIX
const GpsFixType gpsFixTypeNoFix = 1;

/// 2D Position Fix.
///
/// GPS_FIX_TYPE_2D_FIX
const GpsFixType gpsFixType2dFix = 2;

/// 3D Position Fix.
///
/// GPS_FIX_TYPE_3D_FIX
const GpsFixType gpsFixType3dFix = 3;

/// DGPS correction active.
///
/// GPS_FIX_TYPE_DGPS
const GpsFixType gpsFixTypeDgps = 4;

/// RTK Float mode precision active.
///
/// GPS_FIX_TYPE_RTK_FLOAT
const GpsFixType gpsFixTypeRtkFloat = 5;

/// RTK Fixed centimeter-level accuracy locked.
///
/// GPS_FIX_TYPE_RTK_FIXED
const GpsFixType gpsFixTypeRtkFixed = 6;

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

  /// Custom mode index selection register [Bytes 13-16].
  ///
  /// MAVLink type: uint32_t
  ///
  /// custom_mode
  final uint32_t customMode;

  /// Type of component entity [Bytes 10].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavType]
  ///
  /// type
  final MavType type;

  /// Autopilot software platform layout [Bytes 11].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavAutopilot]
  ///
  /// autopilot
  final MavAutopilot autopilot;

  /// System wide flag bitmask profile configuration [Bytes 12].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavModeFlag]
  ///
  /// base_mode
  final MavModeFlag baseMode;

  /// System runtime status flag monitor code [Bytes 17].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavState]
  ///
  /// system_status
  final MavState systemStatus;

  /// Internal communication library handshake version indicator [Bytes 18].
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
    MavType? type,
    MavAutopilot? autopilot,
    MavModeFlag? baseMode,
    MavState? systemStatus,
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

/// Synchronization mechanism keeping master system loops closely aligned.
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

  /// Time synchronization payload marker segment 1 (us) [Bytes 10-17].
  ///
  /// MAVLink type: int64_t
  ///
  /// tc1
  final int64_t tc1;

  /// Time synchronization payload marker segment 2 (us) [Bytes 18-25].
  ///
  /// MAVLink type: int64_t
  ///
  /// ts1
  final int64_t ts1;

  /// Target routing address system field [Bytes 26].
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Target routing address component identifier block [Bytes 27].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavComponent]
  ///
  /// target_component
  final MavComponent targetComponent;

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
    MavComponent? targetComponent,
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

/// Standard action execution block transmitting state adjustments across the link.
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

  /// Action execution argument slot 1 [Bytes 15-18].
  ///
  /// MAVLink type: float
  ///
  /// param1
  final float param1;

  /// Action execution argument slot 2 [Bytes 19-22].
  ///
  /// MAVLink type: float
  ///
  /// param2
  final float param2;

  /// Action execution argument slot 3 [Bytes 23-26].
  ///
  /// MAVLink type: float
  ///
  /// param3
  final float param3;

  /// Action execution argument slot 4 [Bytes 27-30].
  ///
  /// MAVLink type: float
  ///
  /// param4
  final float param4;

  /// Action execution argument slot 5 [Bytes 31-34].
  ///
  /// MAVLink type: float
  ///
  /// param5
  final float param5;

  /// Action execution argument slot 6 [Bytes 35-38].
  ///
  /// MAVLink type: float
  ///
  /// param6
  final float param6;

  /// Action execution argument slot 7 [Bytes 39-42].
  ///
  /// MAVLink type: float
  ///
  /// param7
  final float param7;

  /// Target internal action identifier profile code [Bytes 12-13].
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [MavCmd]
  ///
  /// command
  final MavCmd command;

  /// System sequence destination validation field [Bytes 10].
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Component destination routing index location [Bytes 11].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavComponent]
  ///
  /// target_component
  final MavComponent targetComponent;

  /// Retransmission counter register validating frame history [Bytes 14].
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
    MavCmd? command,
    uint8_t? targetSystem,
    MavComponent? targetComponent,
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

/// On-the-fly movement interface routing user command inputs down to direct locomotion controllers.
///
/// MANUAL_CONTROL
class ManualControl implements MavlinkMessage {
  static const int msgId = 69;

  static const int crcExtra = 65;

  static const int mavlinkEncodedLength = 30;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Scaled forward and reverse vector velocity command coordinate [Bytes 11-12].
  ///
  /// MAVLink type: int16_t
  ///
  /// X
  final int16_t x;

  /// Scaled port and starboard displacement velocity control argument [Bytes 13-14].
  ///
  /// MAVLink type: int16_t
  ///
  /// Y
  final int16_t y;

  /// Z-axis elevation parameters placeholder [Bytes 15-16].
  ///
  /// MAVLink type: int16_t
  ///
  /// Z
  final int16_t z;

  /// Rotational angular direction modifier [Bytes 17-18].
  ///
  /// MAVLink type: int16_t
  ///
  /// R
  final int16_t r;

  /// Bitmap capturing states of standard inputs panel [Bytes 19-20].
  ///
  /// MAVLink type: uint16_t
  ///
  /// buttons
  final uint16_t buttons;

  /// Extended layout joystick button registration checklist [Bytes 21-22].
  ///
  /// MAVLink type: uint16_t
  ///
  /// buttons2
  final uint16_t buttons2;

  /// Pitch structural override variable tracking slot [Bytes 24-25].
  ///
  /// MAVLink type: int16_t
  ///
  /// S
  final int16_t s;

  /// Roll axis mapping configuration extension parameter [Bytes 26-27].
  ///
  /// MAVLink type: int16_t
  ///
  /// t
  final int16_t t;

  /// Auxiliary component execution parameter pipeline 1 [Bytes 28-29].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux1
  final int16_t aux1;

  /// Auxiliary component execution parameter pipeline 2 [Bytes 30-31].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux2
  final int16_t aux2;

  /// Auxiliary component execution parameter pipeline 3 [Bytes 32-33].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux3
  final int16_t aux3;

  /// Auxiliary component execution parameter pipeline 4 [Bytes 34-35].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux4
  final int16_t aux4;

  /// Auxiliary component execution parameter pipeline 5 [Bytes 36-37].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux5
  final int16_t aux5;

  /// Auxiliary component execution parameter pipeline 6 [Bytes 38-39].
  ///
  /// MAVLink type: int16_t
  ///
  /// aux6
  final int16_t aux6;

  /// Target execution identifier address tracking slot [Bytes 10].
  ///
  /// MAVLink type: uint8_t
  ///
  /// target
  final uint8_t target;

  /// Active extension layer verification flag tracking field status [Bytes 23].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enabled_extensions
  final uint8_t enabledExtensions;

  ManualControl({
    required this.x,
    required this.y,
    required this.z,
    required this.r,
    required this.buttons,
    required this.buttons2,
    required this.s,
    required this.t,
    required this.aux1,
    required this.aux2,
    required this.aux3,
    required this.aux4,
    required this.aux5,
    required this.aux6,
    required this.target,
    required this.enabledExtensions,
  });

  ManualControl.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'],
        r = json['r'],
        buttons = json['buttons'],
        buttons2 = json['buttons2'],
        s = json['s'],
        t = json['t'],
        aux1 = json['aux1'],
        aux2 = json['aux2'],
        aux3 = json['aux3'],
        aux4 = json['aux4'],
        aux5 = json['aux5'],
        aux6 = json['aux6'],
        target = json['target'],
        enabledExtensions = json['enabledExtensions'];
  ManualControl copyWith({
    int16_t? x,
    int16_t? y,
    int16_t? z,
    int16_t? r,
    uint16_t? buttons,
    uint16_t? buttons2,
    int16_t? s,
    int16_t? t,
    int16_t? aux1,
    int16_t? aux2,
    int16_t? aux3,
    int16_t? aux4,
    int16_t? aux5,
    int16_t? aux6,
    uint8_t? target,
    uint8_t? enabledExtensions,
  }) {
    return ManualControl(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      r: r ?? this.r,
      buttons: buttons ?? this.buttons,
      buttons2: buttons2 ?? this.buttons2,
      s: s ?? this.s,
      t: t ?? this.t,
      aux1: aux1 ?? this.aux1,
      aux2: aux2 ?? this.aux2,
      aux3: aux3 ?? this.aux3,
      aux4: aux4 ?? this.aux4,
      aux5: aux5 ?? this.aux5,
      aux6: aux6 ?? this.aux6,
      target: target ?? this.target,
      enabledExtensions: enabledExtensions ?? this.enabledExtensions,
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
        'buttons2': buttons2,
        's': s,
        't': t,
        'aux1': aux1,
        'aux2': aux2,
        'aux3': aux3,
        'aux4': aux4,
        'aux5': aux5,
        'aux6': aux6,
        'target': target,
        'enabledExtensions': enabledExtensions,
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
    var buttons2 = data_.getUint16(10, Endian.little);
    var s = data_.getInt16(12, Endian.little);
    var t = data_.getInt16(14, Endian.little);
    var aux1 = data_.getInt16(16, Endian.little);
    var aux2 = data_.getInt16(18, Endian.little);
    var aux3 = data_.getInt16(20, Endian.little);
    var aux4 = data_.getInt16(22, Endian.little);
    var aux5 = data_.getInt16(24, Endian.little);
    var aux6 = data_.getInt16(26, Endian.little);
    var target = data_.getUint8(28);
    var enabledExtensions = data_.getUint8(29);

    return ManualControl(
        x: x,
        y: y,
        z: z,
        r: r,
        buttons: buttons,
        buttons2: buttons2,
        s: s,
        t: t,
        aux1: aux1,
        aux2: aux2,
        aux3: aux3,
        aux4: aux4,
        aux5: aux5,
        aux6: aux6,
        target: target,
        enabledExtensions: enabledExtensions);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setInt16(0, x, Endian.little);
    data_.setInt16(2, y, Endian.little);
    data_.setInt16(4, z, Endian.little);
    data_.setInt16(6, r, Endian.little);
    data_.setUint16(8, buttons, Endian.little);
    data_.setUint16(10, buttons2, Endian.little);
    data_.setInt16(12, s, Endian.little);
    data_.setInt16(14, t, Endian.little);
    data_.setInt16(16, aux1, Endian.little);
    data_.setInt16(18, aux2, Endian.little);
    data_.setInt16(20, aux3, Endian.little);
    data_.setInt16(22, aux4, Endian.little);
    data_.setInt16(24, aux5, Endian.little);
    data_.setInt16(26, aux6, Endian.little);
    data_.setUint8(28, target);
    data_.setUint8(29, enabledExtensions);
    return data_;
  }
}

/// Aggregated status block mapping tracking boundaries, errors, power parameters, and state flags.
///
/// UGV_SYSTEM_INFO
class UgvSystemInfo implements MavlinkMessage {
  static const int msgId = 50001;

  static const int crcExtra = 39;

  static const int mavlinkEncodedLength = 81;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Power configurations tracking modules validation registers [Bytes 31-33].
  ///
  /// MAVLink type: uint32_t
  ///
  /// motor_faults
  final uint32_t motorFaults;

  /// Aft/Forward dynamic motor system physical fault logs bitmask [Bytes 36-39].
  ///
  /// MAVLink type: uint32_t
  ///
  /// comp_interface_health_2
  final uint32_t compInterfaceHealth2;

  /// Home location latitude coordinate configuration space [Bytes 57-60].
  ///
  /// MAVLink type: int32_t
  ///
  /// lat
  final int32_t lat;

  /// Home location longitude coordinate configuration space [Bytes 61-64].
  ///
  /// MAVLink type: int32_t
  ///
  /// long
  final int32_t long;

  /// Low voltage battery systems structural storage evaluation [Byte 11].
  ///
  /// MAVLink type: uint16_t
  ///
  /// battery_soc
  final uint16_t batterySoc;

  /// Framework parameters identification tracking placeholder [Byte 14].
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_model
  final uint16_t compModel;

  /// Diagnostic matrix monitoring UHF interfaces and transceivers [Bytes 16-17].
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_1
  final uint16_t sensorSubsystemHealth1;

  /// L-Band high performance datalink interface logic monitors [Bytes 19-20].
  ///
  /// MAVLink type: uint16_t
  ///
  /// sensor_subsystem_health_4
  final uint16_t sensorSubsystemHealth4;

  /// Ethernet infrastructure switch status routing checks [Bytes 22-23].
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_subsystem_status
  final uint16_t compSubsystemStatus;

  /// Onboard peripheral cameras data lines check stream registry [Bytes 23-24].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_subsystem_power_state_1
  final uint16_t vcuSubsystemPowerState1;

  /// Motor power controllers dynamic hardware metrics checklist [Bytes 25-26].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_power_subsystem_state_2
  final uint16_t vcuPowerSubsystemState2;

  /// Traction battery banks configuration safety states matrix [Bytes 25-26].
  ///
  /// MAVLink type: uint16_t
  ///
  /// validity_motor_faults
  final uint16_t validityMotorFaults;

  /// Auxiliary subsystems power distributions state tracking registers [Bytes 26-27].
  ///
  /// MAVLink type: uint16_t
  ///
  /// mc_faults_1
  final uint16_t mcFaults1;

  /// Main core compute hardware operations logging profile bitmask [Bytes 27-28].
  ///
  /// MAVLink type: uint16_t
  ///
  /// mc_faults_2
  final uint16_t mcFaults2;

  /// Hardware co-processors tracking and memory space safety map [Bytes 28-29].
  ///
  /// MAVLink type: uint16_t
  ///
  /// contactor_fault
  final uint16_t contactorFault;

  /// Integrated UHF equipment system management loop trackers [Bytes 29-30].
  ///
  /// MAVLink type: uint16_t
  ///
  /// pdu_fault
  final uint16_t pduFault;

  /// L-Band base component operational limits validation registers [Bytes 29-30].
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_1
  final uint16_t powerSubsystemFaults1;

  /// GNSS hardware navigation system internal health bitfield [Bytes 29-30].
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_2
  final uint16_t powerSubsystemFaults2;

  /// IMU sensor array internal health logging profile indexes [Bytes 30-31].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_interface_health
  final uint16_t vcuInterfaceHealth;

  /// Lidar scanners and imaging equipment rail relays status registers [Bytes 33-35].
  ///
  /// MAVLink type: uint16_t
  ///
  /// comp_interface_health_1
  final uint16_t compInterfaceHealth1;

  /// Motor power controller communication metrics check loop validation [Bytes 41-42].
  ///
  /// MAVLink type: uint16_t
  ///
  /// home_location
  final uint16_t homeLocation;

  /// Power delivery system structural routing diagnostics profile register [Byte 45].
  ///
  /// MAVLink type: uint16_t
  ///
  /// pdu_fault_extended
  final uint16_t pduFaultExtended;

  /// HV cell arrays voltage threshold validation parameters block [Bytes 45-46].
  ///
  /// MAVLink type: uint16_t
  ///
  /// power_subsystem_faults_extended
  final uint16_t powerSubsystemFaultsExtended;

  /// HV/LV storage systems hardware protection criteria check codes [Bytes 46-48].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_interface_health_extended
  final uint16_t vcuInterfaceHealthExtended;

  /// Dynamic CAN physical connection networks state status registers [Bytes 49-50].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_bus_faults
  final uint16_t vcuBusFaults;

  /// Discrete and analog subsystem inputs monitoring loop parameters [Bytes 49-50].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_internal_faults
  final uint16_t vcuInternalFaults;

  /// Watchdogs, logic loops, safety SBC components check registries [Bytes 50-51].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vcu_hardware_safety
  final uint16_t vcuHardwareSafety;

  /// Auxiliary sensor CAN connection lanes link validation maps [Bytes 51-52].
  ///
  /// MAVLink type: uint16_t
  ///
  /// aux_can_interfaces
  final uint16_t auxCanInterfaces;

  /// Secondary computational system operational parameters byte indices [Bytes 51-52].
  ///
  /// MAVLink type: uint16_t
  ///
  /// compute_node_health
  final uint16_t computeNodeHealth;

  /// Vision and camera line logical network interfaces validation status [Byte 54].
  ///
  /// MAVLink type: uint16_t
  ///
  /// jetson_interface_health
  final uint16_t jetsonInterfaceHealth;

  /// GMSL camera streaming hardware lane connection checking profiles [Bytes 54-55].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vision_gmsl_health
  final uint16_t visionGmslHealth;

  /// VCU execution state indicators tracking flag [Byte 10].
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_status
  final uint8_t vcuStatus;

  /// High voltage traction block battery fuel level status indicator [Byte 12].
  ///
  /// MAVLink type: uint8_t
  ///
  /// battery_hv_soc
  final uint8_t batteryHvSoc;

  /// Autonomy structural selection parameters block [Byte 13].
  ///
  /// MAVLink type: uint8_t
  ///
  /// comp_mode2
  final uint8_t compMode2;

  /// Communication peripheral subsystem health status bitfield [Byte 15].
  ///
  /// MAVLink type: uint8_t
  ///
  /// sensor_subsystem_health_2
  final uint8_t sensorSubsystemHealth2;

  /// UHF communication interface and data pipeline tracking index [Byte 18].
  ///
  /// MAVLink type: uint8_t
  ///
  /// sensor_subsystem_health_3
  final uint8_t sensorSubsystemHealth3;

  /// L-Band structural diagnostic loop quality metric tracking register [Byte 21].
  ///
  /// MAVLink type: uint8_t
  ///
  /// vcu_subsystem_status
  final uint8_t vcuSubsystemStatus;

  /// Diagnostic array verification status tracking registry check code [Byte 40].
  ///
  /// MAVLink type: uint8_t
  ///
  /// sec_comp_status
  final uint8_t secCompStatus;

  /// Execution loop analytics data validation status flag registry [Byte 43].
  ///
  /// MAVLink type: uint8_t
  ///
  /// lat_placeholder
  final uint8_t latPlaceholder;

  /// High-current isolation relay monitoring map structural index [Byte 44].
  ///
  /// MAVLink type: uint8_t
  ///
  /// long_placeholder
  final uint8_t longPlaceholder;

  /// Jetson core hardware processor interaction validation loop status [Byte 53].
  ///
  /// MAVLink type: uint8_t
  ///
  /// jetson_heartbeat
  final uint8_t jetsonHeartbeat;

  /// Home coordinate parameters confirmation status registry flags [Byte 56].
  ///
  /// MAVLink type: uint8_t
  ///
  /// home_initialization
  final uint8_t homeInitialization;

  UgvSystemInfo({
    required this.motorFaults,
    required this.compInterfaceHealth2,
    required this.lat,
    required this.long,
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
        long = json['long'],
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
    int32_t? long,
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
      long: long ?? this.long,
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
        'long': long,
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
    var long = data_.getInt32(12, Endian.little);
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
        long: long,
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
    data_.setInt32(12, long, Endian.little);
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

/// Provides standard master reference alignment tracking vectors from Compute.
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

  /// Unix Epoch absolute time signature tracking slot (us) [Bytes 10-17].
  ///
  /// MAVLink type: uint64_t
  ///
  /// time_unix_usec
  final uint64_t timeUnixUsec;

  /// Uptime tracker registering standard internal millisecond metrics [Bytes 18-21].
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

/// Transmits raw navigation payload metrics streaming directly from the receiver.
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

  /// Microsecond precision system localization time clock marker [Bytes 10-17].
  ///
  /// MAVLink type: uint64_t
  ///
  /// time_usec
  final uint64_t timeUsec;

  /// Latitude (WGS84), expressed as degrees * 1E7 [Bytes 18-21].
  ///
  /// MAVLink type: int32_t
  ///
  /// lat
  final int32_t lat;

  /// Longitude (WGS84), expressed as degrees * 1E7 [Bytes 22-25].
  ///
  /// MAVLink type: int32_t
  ///
  /// lon
  final int32_t lon;

  /// Altitude (MSL), expressed in millimeters [Bytes 26-29].
  ///
  /// MAVLink type: int32_t
  ///
  /// alt
  final int32_t alt;

  /// Accuracy of the horizontal position multiplied by 100 [Bytes 30-31].
  ///
  /// MAVLink type: uint16_t
  ///
  /// eph
  final uint16_t eph;

  /// Accuracy of the vertical position multiplied by 100 [Bytes 32-33].
  ///
  /// MAVLink type: uint16_t
  ///
  /// epv
  final uint16_t epv;

  /// Speed calculated by GNSS in cm/s [Bytes 34-35].
  ///
  /// MAVLink type: uint16_t
  ///
  /// vel
  final uint16_t vel;

  /// Reported heading vector in centidegrees [Bytes 36-37].
  ///
  /// MAVLink type: uint16_t
  ///
  /// cog
  final uint16_t cog;

  /// Satellite lock configuration state reference index [Byte 38].
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [GpsFixType]
  ///
  /// fix_type
  final GpsFixType fixType;

  /// Number of active tracked space elements locked [Byte 39].
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
    GpsFixType? fixType,
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

/// Transmits system roll, pitch, yaw angles along with spatial angular displacement rates.
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

  /// Uptime tracking index validating standard timestamp inputs [Bytes 10-13].
  ///
  /// MAVLink type: uint32_t
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  /// Roll orientation coordinate parameter (radians) [Bytes 14-17].
  ///
  /// MAVLink type: float
  ///
  /// roll
  final float roll;

  /// Pitch orientation coordinate parameter (radians) [Bytes 18-21].
  ///
  /// MAVLink type: float
  ///
  /// pitch
  final float pitch;

  /// Yaw orientation coordinate parameter (radians) [Bytes 22-25].
  ///
  /// MAVLink type: float
  ///
  /// yaw
  final float yaw;

  /// Roll rotational displacement rate tracking slot (rad/s) [Bytes 26-29].
  ///
  /// MAVLink type: float
  ///
  /// rollspeed
  final float rollspeed;

  /// Pitch rotational velocity tracking slot (rad/s) [Bytes 30-33].
  ///
  /// MAVLink type: float
  ///
  /// pitchspeed
  final float pitchspeed;

  /// Yaw rotational velocity tracking slot (rad/s) [Bytes 34-37].
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
