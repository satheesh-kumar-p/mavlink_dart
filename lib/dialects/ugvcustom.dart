import 'dart:typed_data';
import 'package:dart_mavlink/mavlink_dialect.dart';
import 'package:dart_mavlink/mavlink_message.dart';
import 'package:dart_mavlink/types.dart';
import 'dart:convert';

/// MAVLINK component type reported in HEARTBEAT message. Flight controllers must report the type of the vehicle on which they are mounted (e.g. MAV_TYPE_OCTOROTOR). All other components must report a value appropriate for their type (e.g. a camera must use MAV_TYPE_CAMERA).
///
/// MAV_TYPE
typedef MavType = int;

/// Generic micro air vehicle
///
/// MAV_TYPE_GENERIC
const MavType mavTypeGeneric = 0;

/// Onboard companion controller
///
/// MAV_TYPE_ONBOARD_CONTROLLER
const MavType mavTypeOnboardController = 18;

/// Micro air vehicle / autopilot classes. This identifies the individual model.
///
/// MAV_AUTOPILOT
typedef MavAutopilot = int;

/// Generic autopilot, full support for everything
///
/// MAV_AUTOPILOT_GENERIC
const MavAutopilot mavAutopilotGeneric = 0;

/// No valid autopilot, e.g. a GCS or other MAVLink component
///
/// MAV_AUTOPILOT_INVALID
const MavAutopilot mavAutopilotInvalid = 8;

///
/// MAV_STATE
typedef MavState = int;

/// Uninitialized system, state is unknown.
///
/// MAV_STATE_UNINIT
const MavState mavStateUninit = 0;

/// System is grounded and on standby. It can be launched any time.
///
/// MAV_STATE_STANDBY
const MavState mavStateStandby = 3;

/// System is active and might be already airborne. Motors are engaged.
///
/// MAV_STATE_ACTIVE
const MavState mavStateActive = 4;

/// Commands to be executed by the MAV. They can be executed on user request, or as part of a mission script. If the action is used in a mission, the parameter mapping to the waypoint/mission message is as follows: Param 1, Param 2, Param 3, Param 4, X: Param 5, Y:Param 6, Z:Param 7. This command list is similar what ARINC 424 is for commercial aircraft: A data format how to interpret waypoint/mission data. NaN and INT32_MAX may be used in float/integer params (respectively) to indicate optional/default values (e.g. to use the component's current yaw or latitude rather than a specific value). See https://mavlink.io/en/guide/xml_schema.html#MAV_CMD for information about the structure of the MAV_CMD entries
///
/// MAV_CMD
typedef MavCmd = int;

/// Set system mode.
///
/// MAV_CMD_DO_SET_MODE
const MavCmd mavCmdDoSetMode = 176;

/// Arms / Disarms a component
///
/// MAV_CMD_COMPONENT_ARM_DISARM
const MavCmd mavCmdComponentArmDisarm = 400;

/// Request the target system(s) emit a single instance of a specified message (i.e. a "one-shot" version of MAV_CMD_SET_MESSAGE_INTERVAL).
///
/// MAV_CMD_REQUEST_MESSAGE
const MavCmd mavCmdRequestMessage = 512;

/// Command to change drive mode of UGV
///
/// MAV_CMD_DRIVE_MODE
const MavCmd mavCmdDriveMode = 31900;

/// Command to change light state of UGV
///
/// MAV_CMD_LIGHT_CONTROL
const MavCmd mavCmdLightControl = 31901;

/// Result from a MAVLink command (MAV_CMD)
///
/// MAV_RESULT
typedef MavResult = int;

/// Command is valid (is supported and has valid parameters), and was executed.
///
/// MAV_RESULT_ACCEPTED
const MavResult mavResultAccepted = 0;

/// Command is valid, but cannot be executed at this time. This is used to indicate a problem that should be fixed just by waiting (e.g. a state machine is busy, can't arm because have not got GPS lock, etc.). Retrying later should work.
///
/// MAV_RESULT_TEMPORARILY_REJECTED
const MavResult mavResultTemporarilyRejected = 1;

/// Command is invalid; it is supported but one or more parameter values are invalid (i.e. parameter reserved, value allowed by spec but not supported by flight stack, and so on). Retrying the same command and parameters will not work.
///
/// MAV_RESULT_DENIED
const MavResult mavResultDenied = 2;

/// Command is not supported (unknown).
///
/// MAV_RESULT_UNSUPPORTED
const MavResult mavResultUnsupported = 3;

/// Command is valid, but execution has failed. This is used to indicate any non-temporary or unexpected problem, i.e. any problem that must be fixed before the command can succeed/be retried. For example, attempting to write a file when out of memory, attempting to arm when sensors are not calibrated, etc.
///
/// MAV_RESULT_FAILED
const MavResult mavResultFailed = 4;

/// Command is valid and is being executed. This will be followed by further progress updates, i.e. the component may send further COMMAND_ACK messages with result MAV_RESULT_IN_PROGRESS (at a rate decided by the implementation), and must terminate by sending a COMMAND_ACK message with final result of the operation. The COMMAND_ACK.progress field can be used to indicate the progress of the operation.
///
/// MAV_RESULT_IN_PROGRESS
const MavResult mavResultInProgress = 5;

/// Command has been cancelled (as a result of receiving a COMMAND_CANCEL message).
///
/// MAV_RESULT_CANCELLED
const MavResult mavResultCancelled = 6;

/// Command is only accepted when sent as a COMMAND_LONG.
///
/// MAV_RESULT_COMMAND_LONG_ONLY
const MavResult mavResultCommandLongOnly = 7;

/// Command is only accepted when sent as a COMMAND_INT.
///
/// MAV_RESULT_COMMAND_INT_ONLY
const MavResult mavResultCommandIntOnly = 8;

/// Command is invalid because a frame is required and the specified frame is not supported.
///
/// MAV_RESULT_COMMAND_UNSUPPORTED_MAV_FRAME
const MavResult mavResultCommandUnsupportedMavFrame = 9;

/// WIP.
/// Command has been rejected because source system is not in control of the target system/component.
///
/// MAV_RESULT_NOT_IN_CONTROL
const MavResult mavResultNotInControl = 10;

/// Enum used to indicate true or false (also: success or failure, enabled or disabled, active or inactive).
///
/// MAV_BOOL
typedef MavBool = int;

/// False.
///
/// MAV_BOOL_FALSE
const MavBool mavBoolFalse = 0;

/// True.
///
/// MAV_BOOL_TRUE
const MavBool mavBoolTrue = 1;

/// Used to indicate the current state of the extra feature buttons
///
/// PUSH_BUTTONS
typedef PushButtons = int;

/// a single short press of extra feature 1 button.
///
/// EXTRA_FEATURE_1_PRESS
const PushButtons extraFeature1Press = 1;

/// a long press of extra feature 1 button.
///
/// EXTRA_FEATURE_1_LONG_PRESS
const PushButtons extraFeature1LongPress = 2;

/// a single short press of extra feature 2 button.
///
/// EXTRA_FEATURE_2_PRESS
const PushButtons extraFeature2Press = 4;

/// a long press of extra feature 2 button.
///
/// EXTRA_FEATURE_2_LONG_PRESS
const PushButtons extraFeature2LongPress = 8;

/// Used to indicate the position of the tristate toggle switches.
///
/// TOGGLE_SWITCH_POS
typedef ToggleSwitchPos = int;

/// 0x01 Forward Direction
///
/// FORWARD_DIRECTION
const ToggleSwitchPos forwardDirection = 1;

/// 0x02 Reverse Direction
///
/// REVERSE_DIRECTION
const ToggleSwitchPos reverseDirection = 2;

/// 0x04 Medium Speed
///
/// MEDIUM_SPEED
const ToggleSwitchPos mediumSpeed = 4;

/// 0x08 High Speed
///
/// HIGH_SPEED
const ToggleSwitchPos highSpeed = 8;

/// These flags encode the MAV mode, see MAV_MODE enum for useful combinations.
///
/// MAV_MODE_FLAG
typedef MavModeFlag = int;

/// 0b10000000 MAV safety set to armed. Motors are enabled / running / can start. Ready to fly. Additional note: this flag is to be ignore when sent in the command MAV_CMD_DO_SET_MODE and MAV_CMD_COMPONENT_ARM_DISARM shall be used instead. The flag can still be used to report the armed state.
///
/// MAV_MODE_FLAG_SAFETY_ARMED
const MavModeFlag mavModeFlagSafetyArmed = 128;

/// 0b01000000 remote control input is enabled.
///
/// MAV_MODE_FLAG_MANUAL_INPUT_ENABLED
const MavModeFlag mavModeFlagManualInputEnabled = 64;

/// 0b00100000 hardware in the loop simulation. All motors / actuators are blocked, but internal software is full operational.
///
/// MAV_MODE_FLAG_HIL_ENABLED
const MavModeFlag mavModeFlagHilEnabled = 32;

/// 0b00010000 system stabilizes electronically its attitude (and optionally position). It needs however further control inputs to move around.
///
/// MAV_MODE_FLAG_STABILIZE_ENABLED
const MavModeFlag mavModeFlagStabilizeEnabled = 16;

/// 0b00001000 guided mode enabled, system flies waypoints / mission items.
///
/// MAV_MODE_FLAG_GUIDED_ENABLED
const MavModeFlag mavModeFlagGuidedEnabled = 8;

/// 0b00000100 autonomous mode enabled, system finds its own goal positions. Guided flag can be set or not, depends on the actual implementation.
///
/// MAV_MODE_FLAG_AUTO_ENABLED
const MavModeFlag mavModeFlagAutoEnabled = 4;

/// 0b00000010 system has a test mode enabled. This flag is intended for temporary system tests and should not be used for stable implementations.
///
/// MAV_MODE_FLAG_TEST_ENABLED
const MavModeFlag mavModeFlagTestEnabled = 2;

/// 0b00000001 system-specific custom mode is enabled. When using this flag to enable a custom mode all other flags should be ignored.
///
/// MAV_MODE_FLAG_CUSTOM_MODE_ENABLED
const MavModeFlag mavModeFlagCustomModeEnabled = 1;

/// These encode the sub systems whose status is sent as part of the UGV_MASTER_HEALTH message.
///
/// UGV_COMP_BITMASK
typedef UgvCompBitmask = int;

/// 0x01 Atlas Compute
///
/// UGV_COMP_COMP_COMPUTE
const UgvCompBitmask ugvCompCompCompute = 1;

/// 0x02 Vehicle Control Unit (VCU)
///
/// UGV_COMP_VCU
const UgvCompBitmask ugvCompVcu = 2;

/// 0x04 Motor Controller (left)
///
/// UGV_COMP_LEFT_MOTOR
const UgvCompBitmask ugvCompLeftMotor = 4;

/// 0x08 Motor Controller (right)
///
/// UGV_COMP_RIGHT_MOTOR
const UgvCompBitmask ugvCompRightMotor = 8;

/// 0x10 Battery Management System (BMS)
///
/// UGV_COMP_BMS
const UgvCompBitmask ugvCompBms = 16;

/// 0x20 Power Distribution Unit (PDU)
///
/// UGV_COMP_PDU
const UgvCompBitmask ugvCompPdu = 32;

/// 0x40 UHF radio
///
/// UGV_COMP_UHF_RADIO
const UgvCompBitmask ugvCompUhfRadio = 64;

/// 0x80 Display
///
/// UGV_COMP_DISPLAY
const UgvCompBitmask ugvCompDisplay = 128;

/// 0x100 Hand controller
///
/// UGV_COMP_HAND_CTRL
const UgvCompBitmask ugvCompHandCtrl = 256;

/// 0x200 Ground Control Station (GCS)
///
/// UGV_COMP_GCS
const UgvCompBitmask ugvCompGcs = 512;

/// Enum used to indicate the errors present in Motors
///
/// UGV_MOTOR_ERROR
typedef UgvMotorError = int;

/// 0x01 Motor Over Speed
///
/// UGV_MOTOR_ERROR_OVER_SPEED
const UgvMotorError ugvMotorErrorOverSpeed = 1;

/// 0x02 Motor Overload
///
/// UGV_MOTOR_ERROR_OVERLOAD
const UgvMotorError ugvMotorErrorOverload = 2;

/// 0x04 Motor Phase Loss
///
/// UGV_MOTOR_ERROR_PHASE_LOSS
const UgvMotorError ugvMotorErrorPhaseLoss = 4;

/// 0x08 Motor Brake Fault
///
/// UGV_MOTOR_ERROR_BRAKE_FAULT
const UgvMotorError ugvMotorErrorBrakeFault = 8;

/// 0x10 Motor Encoder Fault
///
/// UGV_MOTOR_ERROR_ENCODER_FAULT
const UgvMotorError ugvMotorErrorEncoderFault = 16;

/// 0x20 Motor Over Temperature
///
/// UGV_MOTOR_ERROR_OVER_TEMPERATURE
const UgvMotorError ugvMotorErrorOverTemperature = 32;

/// 0x40 Motor Hall Fault
///
/// UGV_MOTOR_ERROR_HALL_FAULT
const UgvMotorError ugvMotorErrorHallFault = 64;

/// 0x80 Motor Stalled Fault
///
/// UGV_MOTOR_ERROR_STALLED
const UgvMotorError ugvMotorErrorStalled = 128;

/// Enum used to indicate the errors present in Motor Controller
///
/// UGV_MOTOR_CTRL_ERROR
typedef UgvMotorCtrlError = int;

/// 0x01 Drive Fault
///
/// UGV_MOTOR_CTRL_ERROR_DRIVE
const UgvMotorCtrlError ugvMotorCtrlErrorDrive = 1;

/// 0x02 Over Current
///
/// UGV_MOTOR_CTRL_ERROR_OVER_CURRENT
const UgvMotorCtrlError ugvMotorCtrlErrorOverCurrent = 2;

/// 0x04 Over Pressure
///
/// UGV_MOTOR_CTRL_ERROR_OVER_PRESSURE
const UgvMotorCtrlError ugvMotorCtrlErrorOverPressure = 4;

/// 0x08 Under Voltage
///
/// UGV_MOTOR_CTRL_ERROR_UNDER_VOLTAGE
const UgvMotorCtrlError ugvMotorCtrlErrorUnderVoltage = 8;

/// 0x10 Over Temperature
///
/// UGV_MOTOR_CTRL_ERROR_OVER_TEMPERATURE
const UgvMotorCtrlError ugvMotorCtrlErrorOverTemperature = 16;

/// 0x20 CAN Communication Fault
///
/// UGV_MOTOR_CTRL_ERROR_CAN_COMM
const UgvMotorCtrlError ugvMotorCtrlErrorCanComm = 32;

/// Operator mode in which the UGV operates in. Mode A signifies hand controller, Mode B signifies GCS
///
/// UGV_MAIN_MODE
typedef UgvMainMode = int;

/// Mode A, hand controller
///
/// MODE_A
const UgvMainMode modeA = 1;

/// Mode B, GCS
///
/// MODE_B
const UgvMainMode modeB = 2;

/// Operator submode in which the UGV operates in.
///
/// UGV_SUB_MODE
typedef UgvSubMode = int;

/// no active submode
///
/// NONE
const UgvSubMode none = 0;

/// Hold submode, used when UGV is temporarily in halt.
///
/// HOLD
const UgvSubMode hold = 10;

/// Operator speed mode in which the UGV operates in.
///
/// UGV_SPEED_MODE
typedef UgvSpeedMode = int;

/// low speed mode
///
/// UGV_SPEED_LOW
const UgvSpeedMode ugvSpeedLow = 1;

/// medium speed mode
///
/// UGV_SPEED_MEDIUM
const UgvSpeedMode ugvSpeedMedium = 2;

/// high speed mode
///
/// UGV_SPEED_HIGH
const UgvSpeedMode ugvSpeedHigh = 3;

/// Operator drive mode in which the UGV operates in.
///
/// UGV_DRIVE_MODE
typedef UgvDriveMode = int;

/// speed mode
///
/// SPEED
const UgvDriveMode speed = 1;

/// torque mode
///
/// TORQUE
const UgvDriveMode torque = 2;

/// torque with speed limit mode
///
/// TORQUE_WITH_SPEED_LIMIT
const UgvDriveMode torqueWithSpeedLimit = 3;

/// position mode
///
/// POSITION
const UgvDriveMode position = 4;

/// Reason for sub-mode change.
///
/// MODE_CHANGE_REASON
typedef ModeChangeReason = int;

/// submode changed due to GCS command
///
/// GCS_COMMAND
const ModeChangeReason gcsCommand = 0;

/// submode changed due to activation of failsafe
///
/// FAILSAFE
const ModeChangeReason failsafe = 1;

/// submode changed due to sensor fault
///
/// SENSOR_FAULT
const ModeChangeReason sensorFault = 2;

/// submode change due to loss of communication
///
/// COMM_LOSS
const ModeChangeReason commLoss = 3;

///
/// Generic subsystem communication and health status.
/// Used for motor controllers, batteries, PDUs, and other subsystems.
///
///
/// UGV_HEALTH_STATE
typedef UgvHealthState = int;

/// Reserved state.
///
/// RESERVED_STATE
const UgvHealthState reservedState = 0;

/// No communication with subsystem.
///
/// NO_COMMUNICATION_STATE
const UgvHealthState noCommunicationState = 1;

/// Subsystem communicating and healthy.
///
/// COMMUNICATING_HEALTHY_STATE
const UgvHealthState communicatingHealthyState = 2;

/// Subsystem communicating but unhealthy. Fault present.
///
/// FAULT_STATE
const UgvHealthState faultState = 3;

/// The heartbeat message shows that a system or component is present and responding. The type and autopilot fields (along with the message component id), allow the receiving system to treat further messages from this system appropriately (e.g. by laying out the user interface based on the autopilot). This microservice is documented at https://mavlink.io/en/services/heartbeat.html
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

  /// A bitfield for use for autopilot-specific flags
  ///
  /// MAVLink type: uint32_t
  ///
  /// custom_mode
  final uint32_t customMode;

  /// Vehicle or component type. For a flight controller component the vehicle type (quadrotor, helicopter, etc.). For other components the component type (e.g. camera, gimbal, etc.). This should be used in preference to component id for identifying the component type.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavType]
  ///
  /// type
  final MavType type;

  /// Autopilot type / class. Use MAV_AUTOPILOT_INVALID for components that are not flight controllers.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavAutopilot]
  ///
  /// autopilot
  final MavAutopilot autopilot;

  /// System mode bitmap.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavModeFlag]
  ///
  /// base_mode
  final MavModeFlag baseMode;

  /// System status flag.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavState]
  ///
  /// system_status
  final MavState systemStatus;

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

///
/// Time synchronization message.
/// The message is used for both timesync requests and responses.
/// The request is sent with `ts1=syncing component timestamp` and `tc1=0`, and may be broadcast or targeted to a specific system/component.
/// The response is sent with `ts1=syncing component timestamp` (mirror back unchanged), and `tc1=responding component timestamp`, with the `target_system` and `target_component` set to ids of the original request.
/// Systems can determine if they are receiving a request or response based on the value of `tc`.
/// If the response has `target_system==target_component==0` the remote system has not been updated to use the component IDs and cannot reliably timesync; the requester may report an error.
/// Timestamps are UNIX Epoch time or time since system boot in nanoseconds (the timestamp format can be inferred by checking for the magnitude of the number; generally it doesn't matter as only the offset is used).
/// The message sequence is repeated numerous times with results being filtered/averaged to estimate the offset.
/// See also: https://mavlink.io/en/services/timesync.html.
///
///
/// TIMESYNC
class Timesync implements MavlinkMessage {
  static const int msgId = 111;

  static const int crcExtra = 34;

  static const int mavlinkEncodedLength = 18;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Time sync timestamp 1. Syncing: 0. Responding: Timestamp of responding component.
  ///
  /// MAVLink type: int64_t
  ///
  /// units: ns
  ///
  /// tc1
  final int64_t tc1;

  /// Time sync timestamp 2. Timestamp of syncing component (mirrored in response).
  ///
  /// MAVLink type: int64_t
  ///
  /// units: ns
  ///
  /// ts1
  final int64_t ts1;

  /// Target system id. Request: 0 (broadcast) or id of specific system. Response must contain system id of the requesting component.
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Target component id. Request: 0 (broadcast) or id of specific component. Response must contain component id of the requesting component.
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
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

/// Send a command with up to seven parameters to the MAV. COMMAND_INT is generally preferred when sending MAV_CMD commands that include positional information; it offers higher precision and allows the MAV_FRAME to be specified (which may otherwise be ambiguous, particularly for altitude). The command microservice is documented at https://mavlink.io/en/services/command.html
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

  /// Parameter 1 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param1
  final float param1;

  /// Parameter 2 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param2
  final float param2;

  /// Parameter 3 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param3
  final float param3;

  /// Parameter 4 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param4
  final float param4;

  /// Parameter 5 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param5
  final float param5;

  /// Parameter 6 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param6
  final float param6;

  /// Parameter 7 (for the specific command).
  ///
  /// MAVLink type: float
  ///
  /// param7
  final float param7;

  /// Command ID (of command to send).
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [MavCmd]
  ///
  /// command
  final MavCmd command;

  /// System which should execute the command
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Component which should execute the command, 0 for all components
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_component
  final uint8_t targetComponent;

  /// 0: First transmission of this command. 1-255: Confirmation transmissions (e.g. for kill command)
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

/// Report status of a command. Includes feedback whether the command was executed. The command microservice is documented at https://mavlink.io/en/services/command.html
///
/// COMMAND_ACK
class CommandAck implements MavlinkMessage {
  static const int msgId = 77;

  static const int crcExtra = 143;

  static const int mavlinkEncodedLength = 10;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Command ID (of acknowledged command).
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [MavCmd]
  ///
  /// command
  final MavCmd command;

  /// Result of command.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavResult]
  ///
  /// result
  final MavResult result;

  /// The progress percentage when result is MAV_RESULT_IN_PROGRESS. Values: [0-100], or UINT8_MAX if the progress is unknown.
  ///
  /// MAVLink type: uint8_t
  ///
  /// units: %
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// progress
  final uint8_t progress;

  /// Additional result information. Can be set with a command-specific enum containing command-specific error reasons for why the command might be denied. If used, the associated enum must be documented in the corresponding MAV_CMD (this enum should have a 0 value to indicate "unused" or "unknown").
  ///
  /// MAVLink type: int32_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// result_param2
  final int32_t resultParam2;

  /// System ID of the target recipient. This is the ID of the system that sent the command for which this COMMAND_ACK is an acknowledgement.
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Component ID of the target recipient. This is the ID of the system that sent the command for which this COMMAND_ACK is an acknowledgement.
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// target_component
  final uint8_t targetComponent;

  CommandAck({
    required this.command,
    required this.result,
    required this.progress,
    required this.resultParam2,
    required this.targetSystem,
    required this.targetComponent,
  });

  CommandAck.fromJson(Map<String, dynamic> json)
      : command = json['command'],
        result = json['result'],
        progress = json['progress'],
        resultParam2 = json['resultParam2'],
        targetSystem = json['targetSystem'],
        targetComponent = json['targetComponent'];
  CommandAck copyWith({
    MavCmd? command,
    MavResult? result,
    uint8_t? progress,
    int32_t? resultParam2,
    uint8_t? targetSystem,
    uint8_t? targetComponent,
  }) {
    return CommandAck(
      command: command ?? this.command,
      result: result ?? this.result,
      progress: progress ?? this.progress,
      resultParam2: resultParam2 ?? this.resultParam2,
      targetSystem: targetSystem ?? this.targetSystem,
      targetComponent: targetComponent ?? this.targetComponent,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'command': command,
        'result': result,
        'progress': progress,
        'resultParam2': resultParam2,
        'targetSystem': targetSystem,
        'targetComponent': targetComponent,
      };

  factory CommandAck.parse(ByteData data_) {
    if (data_.lengthInBytes < CommandAck.mavlinkEncodedLength) {
      var len = CommandAck.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var command = data_.getUint16(0, Endian.little);
    var result = data_.getUint8(2);
    var progress = data_.getUint8(3);
    var resultParam2 = data_.getInt32(4, Endian.little);
    var targetSystem = data_.getUint8(8);
    var targetComponent = data_.getUint8(9);

    return CommandAck(
        command: command,
        result: result,
        progress: progress,
        resultParam2: resultParam2,
        targetSystem: targetSystem,
        targetComponent: targetComponent);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint16(0, command, Endian.little);
    data_.setUint8(2, result);
    data_.setUint8(3, progress);
    data_.setInt32(4, resultParam2, Endian.little);
    data_.setUint8(8, targetSystem);
    data_.setUint8(9, targetComponent);
    return data_;
  }
}

/// Manual (joystick) control message.
/// This message represents movement axes and button using standard joystick axes nomenclature. Unused axes can be disabled and buttons states are transmitted as individual on/off bits of a bitmask. For more information see https://mavlink.io/en/services/manual_control.html
///
/// MANUAL_CONTROL
class ManualControl implements MavlinkMessage {
  static const int msgId = 69;

  static const int crcExtra = 96;

  static const int mavlinkEncodedLength = 28;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// X-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to forward(1000)-backward(-1000) movement on a joystick and the pitch of a vehicle.
  ///
  /// MAVLink type: int16_t
  ///
  /// x
  final int16_t x;

  /// Y-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to left(-1000)-right(1000) movement on a joystick and the roll of a vehicle.
  ///
  /// MAVLink type: int16_t
  ///
  /// y
  final int16_t y;

  /// Z-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to a separate slider movement with maximum being 1000 and minimum being -1000 on a joystick and the thrust of a vehicle. Positive values are positive thrust, negative values are negative thrust.
  ///
  /// MAVLink type: int16_t
  ///
  /// z
  final int16_t z;

  /// R-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to a twisting of the joystick, with clockwise being 1000 and counter-clockwise being -1000, and the yaw of a vehicle.
  ///
  /// MAVLink type: int16_t
  ///
  /// r
  final int16_t r;

  /// A bitfield corresponding to the joystick buttons' 0-15 current state, 1 for pressed, 0 for released. The lowest bit corresponds to Button 1.
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [PushButtons]
  ///
  /// push_buttons
  final PushButtons pushButtons;

  /// The system to be controlled.
  ///
  /// MAVLink type: uint8_t
  ///
  /// target
  final uint8_t target;

  /// Set bits to 1 to indicate which of the following extension fields contain valid data: bit 0: pitch, bit 1: roll, bit 2: aux1, bit 3: aux2, bit 4: aux3, bit 5: aux4, bit 6: aux5, bit 7: aux6
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// enabled_extensions
  final uint8_t enabledExtensions;

  /// Pitch-only-axis, normalized to the range [-1000,1000]. Generally corresponds to pitch on vehicles with additional degrees of freedom. Valid if bit 0 of enabled_extensions field is set. Set to 0 if invalid.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// s
  final int16_t s;

  /// Roll-only-axis, normalized to the range [-1000,1000]. Generally corresponds to roll on vehicles with additional degrees of freedom. Valid if bit 1 of enabled_extensions field is set. Set to 0 if invalid.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// t
  final int16_t t;

  /// Aux continuous input field 1. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 2 of enabled_extensions field is set. 0 if bit 2 is unset.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux1
  final int16_t aux1;

  /// Aux continuous input field 2. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 3 of enabled_extensions field is set. 0 if bit 3 is unset.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux2
  final int16_t aux2;

  /// Aux continuous input field 3. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 4 of enabled_extensions field is set. 0 if bit 4 is unset.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux3
  final int16_t aux3;

  /// Aux continuous input field 4. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 5 of enabled_extensions field is set. 0 if bit 5 is unset.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux4
  final int16_t aux4;

  /// Aux continuous input field 5. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 6 of enabled_extensions field is set. 0 if bit 6 is unset.
  ///
  /// MAVLink type: int16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// aux5
  final int16_t aux5;

  /// Aux continuous input field 6. Normalized in the range [-1000,1000]. Purpose defined by recipient. Valid data if bit 7 of enabled_extensions field is set. 0 if bit 7 is unset.
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
    required this.pushButtons,
    required this.target,
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
        pushButtons = json['pushButtons'],
        target = json['target'],
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
    PushButtons? pushButtons,
    uint8_t? target,
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
      pushButtons: pushButtons ?? this.pushButtons,
      target: target ?? this.target,
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
        'pushButtons': pushButtons,
        'target': target,
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
    var pushButtons = data_.getUint16(8, Endian.little);
    var target = data_.getUint8(10);
    var enabledExtensions = data_.getUint8(11);
    var s = data_.getInt16(12, Endian.little);
    var t = data_.getInt16(14, Endian.little);
    var aux1 = data_.getInt16(16, Endian.little);
    var aux2 = data_.getInt16(18, Endian.little);
    var aux3 = data_.getInt16(20, Endian.little);
    var aux4 = data_.getInt16(22, Endian.little);
    var aux5 = data_.getInt16(24, Endian.little);
    var aux6 = data_.getInt16(26, Endian.little);

    return ManualControl(
        x: x,
        y: y,
        z: z,
        r: r,
        pushButtons: pushButtons,
        target: target,
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
    data_.setUint16(8, pushButtons, Endian.little);
    data_.setUint8(10, target);
    data_.setUint8(11, enabledExtensions);
    data_.setInt16(12, s, Endian.little);
    data_.setInt16(14, t, Endian.little);
    data_.setInt16(16, aux1, Endian.little);
    data_.setInt16(18, aux2, Endian.little);
    data_.setInt16(20, aux3, Endian.little);
    data_.setInt16(22, aux4, Endian.little);
    data_.setInt16(24, aux5, Endian.little);
    data_.setInt16(26, aux6, Endian.little);
    return data_;
  }
}

/// Status generated by radio and injected into MAVLink stream.
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

  /// Count of radio packet receive errors (since boot).
  ///
  /// MAVLink type: uint16_t
  ///
  /// rxerrors
  final uint16_t rxerrors;

  /// Count of error corrected radio packets (since boot).
  ///
  /// MAVLink type: uint16_t
  ///
  /// fixed
  final uint16_t fixed;

  /// Local (message sender) received signal strength indication in device-dependent units/scale. Values: [0-254], UINT8_MAX: invalid/unknown.
  ///
  /// MAVLink type: uint8_t
  ///
  /// rssi
  final uint8_t rssi;

  /// Remote (message receiver) signal strength indication in device-dependent units/scale. Values: [0-254], UINT8_MAX: invalid/unknown.
  ///
  /// MAVLink type: uint8_t
  ///
  /// remrssi
  final uint8_t remrssi;

  /// Remaining free transmitter buffer space.
  ///
  /// MAVLink type: uint8_t
  ///
  /// units: %
  ///
  /// txbuf
  final uint8_t txbuf;

  /// Local background noise level. These are device dependent RSSI values (scale as approx 2x dB on SiK radios). Values: [0-254], UINT8_MAX: invalid/unknown.
  ///
  /// MAVLink type: uint8_t
  ///
  /// noise
  final uint8_t noise;

  /// Remote background noise level. These are device dependent RSSI values (scale as approx 2x dB on SiK radios). Values: [0-254], UINT8_MAX: invalid/unknown.
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

/// Sensor and subsystem status information. Provides a compact representation of sensor/subsystem status and a few other basic statistics.
///
/// SYS_STATUS
class SysStatus implements MavlinkMessage {
  static const int msgId = 1;

  static const int crcExtra = 3;

  static const int mavlinkEncodedLength = 5;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Battery voltage, UINT16_MAX: Voltage not sent by autopilot
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: mV
  ///
  /// voltage_battery
  final uint16_t voltageBattery;

  /// Communication drop rate, (UART, I2C, SPI, CAN), dropped packets on all links (packets that were corrupted on reception on the MAV)
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: c%
  ///
  /// drop_rate_comm
  final uint16_t dropRateComm;

  /// Battery energy remaining, -1: Battery remaining energy not sent by autopilot
  ///
  /// MAVLink type: int8_t
  ///
  /// units: %
  ///
  /// battery_remaining
  final int8_t batteryRemaining;

  SysStatus({
    required this.voltageBattery,
    required this.dropRateComm,
    required this.batteryRemaining,
  });

  SysStatus.fromJson(Map<String, dynamic> json)
      : voltageBattery = json['voltageBattery'],
        dropRateComm = json['dropRateComm'],
        batteryRemaining = json['batteryRemaining'];
  SysStatus copyWith({
    uint16_t? voltageBattery,
    uint16_t? dropRateComm,
    int8_t? batteryRemaining,
  }) {
    return SysStatus(
      voltageBattery: voltageBattery ?? this.voltageBattery,
      dropRateComm: dropRateComm ?? this.dropRateComm,
      batteryRemaining: batteryRemaining ?? this.batteryRemaining,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'voltageBattery': voltageBattery,
        'dropRateComm': dropRateComm,
        'batteryRemaining': batteryRemaining,
      };

  factory SysStatus.parse(ByteData data_) {
    if (data_.lengthInBytes < SysStatus.mavlinkEncodedLength) {
      var len = SysStatus.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var voltageBattery = data_.getUint16(0, Endian.little);
    var dropRateComm = data_.getUint16(2, Endian.little);
    var batteryRemaining = data_.getInt8(4);

    return SysStatus(
        voltageBattery: voltageBattery,
        dropRateComm: dropRateComm,
        batteryRemaining: batteryRemaining);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint16(0, voltageBattery, Endian.little);
    data_.setUint16(2, dropRateComm, Endian.little);
    data_.setInt8(4, batteryRemaining);
    return data_;
  }
}

/// The system time is the time of the sender's master clock.
/// This can be emitted by flight controllers, onboard computers, or other components in the MAVLink network.
/// Components that are using a less reliable time source, such as a battery-backed real time clock, can choose to match their system clock to that of a system that indicates a more recent time.
/// This allows more broadly accurate date stamping of logs, and so on.
/// If precise time synchronization is needed then use TIMESYNC instead.
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

  /// Timestamp (UNIX epoch time).
  ///
  /// MAVLink type: uint64_t
  ///
  /// units: us
  ///
  /// time_unix_usec
  final uint64_t timeUnixUsec;

  /// Timestamp (time since system boot).
  ///
  /// MAVLink type: uint32_t
  ///
  /// units: ms
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

///
/// Reports subsystem communication and health status of the UGV platform.
/// Each subsystem uses 2-bit encoding:
/// 0x01 = No communication
/// 0x10 = Communicating and healthy
/// 0x11 = Communicating and unhealthy (fault present)
/// 0x00 = Reserved
///
///
/// UGV_SYSTEM_INFO
class UgvSystemInfo implements MavlinkMessage {
  static const int msgId = 50001;

  static const int crcExtra = 128;

  static const int mavlinkEncodedLength = 37;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts1_hour
  final uint8_t ts1Hour;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts1_minute
  final uint8_t ts1Minute;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts1_second
  final uint8_t ts1Second;

  ///
  /// Packed subsystem health information.
  ///
  /// Bit 0-1 : Left Motor Controller Health
  /// Bit 2-3 : Right Motor Controller Health
  /// Bit 4-5 : HV Battery Health
  /// Bit 6-7 : LV Battery Health
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvHealthState]
  ///
  /// subsystem_health_1
  final UgvHealthState subsystemHealth1;

  ///
  /// Bit 0-1 : LV PDU
  /// Bit 2-3 : DC-DC 48V to 12V
  /// Bit 4-5 : DC-DC 12V to 5V
  /// Bit 6-7 : VCU
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvHealthState]
  ///
  /// subsystem_health_2
  final UgvHealthState subsystemHealth2;

  ///
  /// Bit 0-1 : Front Left Motor
  /// Bit 2-3 : Rear Left Motor
  /// Bit 4-5 : Front Right Motor
  /// Bit 6-7 : Rear Right Motor
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvHealthState]
  ///
  /// subsystem_health_3
  final UgvHealthState subsystemHealth3;

  ///
  /// Bit 0-1 : UHF Radio
  /// Bit 2-3 : LBAND Radio
  /// Bit 4-5 : Compute
  /// Bit 6-7 : Reserved
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvHealthState]
  ///
  /// subsystem_health_4
  final UgvHealthState subsystemHealth4;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts2_hour
  final uint8_t ts2Hour;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts2_minute
  final uint8_t ts2Minute;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts2_second
  final uint8_t ts2Second;

  ///
  /// soc percentage of remaining battery
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// battery_soc
  final uint8_t batterySoc;

  ///
  /// Current active main mode.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMainMode]
  ///
  /// main_mode
  final UgvMainMode mainMode;

  ///
  /// Current active sub mode.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvSubMode]
  ///
  /// sub_mode
  final UgvSubMode subMode;

  ///
  /// Current active speed mode.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvSpeedMode]
  ///
  /// speed_mode
  final UgvSpeedMode speedMode;

  ///
  /// Current active drive mode.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvDriveMode]
  ///
  /// drive_mode
  final UgvDriveMode driveMode;

  ///
  /// Current active drive mode.Arm(MAV_BOOL_FALSE = Disarm).
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavBool]
  ///
  /// arm_mode
  final MavBool armMode;

  ///
  /// Last main mode commanded by GCS.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMainMode]
  ///
  /// intended_main_mode
  final UgvMainMode intendedMainMode;

  ///
  /// Last sub mode commanded by GCS.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvSubMode]
  ///
  /// intended_sub_mode
  final UgvSubMode intendedSubMode;

  ///
  /// Last speed mode commanded by GCS.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvSpeedMode]
  ///
  /// intended_speed_mode
  final UgvSpeedMode intendedSpeedMode;

  ///
  /// Last drive mode commanded by GCS.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvDriveMode]
  ///
  /// intended_drive_mode
  final UgvDriveMode intendedDriveMode;

  ///
  /// Last arm mode commanded by GCS.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavBool]
  ///
  /// intended_arm_mode
  final MavBool intendedArmMode;

  ///
  /// Reason for last mode transition.
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [ModeChangeReason]
  ///
  /// mode_change_reason
  final ModeChangeReason modeChangeReason;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts3_hour
  final uint8_t ts3Hour;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts3_minute
  final uint8_t ts3Minute;

  /// no_definition
  ///
  /// MAVLink type: uint8_t
  ///
  /// ts3_second
  final uint8_t ts3Second;

  ///
  /// Rear Left Motor Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorError]
  ///
  /// rear_left_motor_faults
  final UgvMotorError rearLeftMotorFaults;

  ///
  /// Rear Right Motor Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorError]
  ///
  /// rear_right_motor_faults
  final UgvMotorError rearRightMotorFaults;

  ///
  /// Front Left Motor Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorError]
  ///
  /// front_left_motor_faults
  final UgvMotorError frontLeftMotorFaults;

  ///
  /// Front Right Motor Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorError]
  ///
  /// front_right_motor_faults
  final UgvMotorError frontRightMotorFaults;

  ///
  /// Rear Motor Controller Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorCtrlError]
  ///
  /// rear_mc_faults
  final UgvMotorCtrlError rearMcFaults;

  ///
  /// Front Motor Controller Faults
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [UgvMotorCtrlError]
  ///
  /// front_mc_faults
  final UgvMotorCtrlError frontMcFaults;

  /// Left Motor Controller Voltage (Unit: 0.1 V)
  ///
  /// MAVLink type: uint8_t
  ///
  /// rear_mc_voltage
  final uint8_t rearMcVoltage;

  /// Right Motor Controller Voltage (Unit: 0.1 V)
  ///
  /// MAVLink type: uint8_t
  ///
  /// front_mc_voltage
  final uint8_t frontMcVoltage;

  /// Left Motor Controller Temperature (Unit: 1 Degree Celsius)
  ///
  /// MAVLink type: uint8_t
  ///
  /// rear_mc_temperature
  final uint8_t rearMcTemperature;

  /// Right Motor Controller Temperature (Unit: 1 Degree Celsius)
  ///
  /// MAVLink type: uint8_t
  ///
  /// front_mc_temperature
  final uint8_t frontMcTemperature;

  ///
  /// bit 0: head light state
  /// bit 1: front fog light state
  /// bit 2: rear light state
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// light_status
  final uint8_t lightStatus;

  ///
  /// bit 0: lv pdu channel 1 state
  /// bit 1: lv pdu channel 2 state
  /// bit 2: lv pdu channel 3 state
  /// bit 3: lv pdu channel 4 state
  /// bit 4: lv pdu channel 5 state
  /// bit 5: lv pdu channel 6 state
  /// bit 6: lv pdu channel 7 state
  /// bit 7: lv pdu channel 8 state
  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// pdu_channel_status
  final uint8_t pduChannelStatus;

  UgvSystemInfo({
    required this.ts1Hour,
    required this.ts1Minute,
    required this.ts1Second,
    required this.subsystemHealth1,
    required this.subsystemHealth2,
    required this.subsystemHealth3,
    required this.subsystemHealth4,
    required this.ts2Hour,
    required this.ts2Minute,
    required this.ts2Second,
    required this.batterySoc,
    required this.mainMode,
    required this.subMode,
    required this.speedMode,
    required this.driveMode,
    required this.armMode,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.intendedSpeedMode,
    required this.intendedDriveMode,
    required this.intendedArmMode,
    required this.modeChangeReason,
    required this.ts3Hour,
    required this.ts3Minute,
    required this.ts3Second,
    required this.rearLeftMotorFaults,
    required this.rearRightMotorFaults,
    required this.frontLeftMotorFaults,
    required this.frontRightMotorFaults,
    required this.rearMcFaults,
    required this.frontMcFaults,
    required this.rearMcVoltage,
    required this.frontMcVoltage,
    required this.rearMcTemperature,
    required this.frontMcTemperature,
    required this.lightStatus,
    required this.pduChannelStatus,
  });

  UgvSystemInfo.fromJson(Map<String, dynamic> json)
      : ts1Hour = json['ts1Hour'],
        ts1Minute = json['ts1Minute'],
        ts1Second = json['ts1Second'],
        subsystemHealth1 = json['subsystemHealth1'],
        subsystemHealth2 = json['subsystemHealth2'],
        subsystemHealth3 = json['subsystemHealth3'],
        subsystemHealth4 = json['subsystemHealth4'],
        ts2Hour = json['ts2Hour'],
        ts2Minute = json['ts2Minute'],
        ts2Second = json['ts2Second'],
        batterySoc = json['batterySoc'],
        mainMode = json['mainMode'],
        subMode = json['subMode'],
        speedMode = json['speedMode'],
        driveMode = json['driveMode'],
        armMode = json['armMode'],
        intendedMainMode = json['intendedMainMode'],
        intendedSubMode = json['intendedSubMode'],
        intendedSpeedMode = json['intendedSpeedMode'],
        intendedDriveMode = json['intendedDriveMode'],
        intendedArmMode = json['intendedArmMode'],
        modeChangeReason = json['modeChangeReason'],
        ts3Hour = json['ts3Hour'],
        ts3Minute = json['ts3Minute'],
        ts3Second = json['ts3Second'],
        rearLeftMotorFaults = json['rearLeftMotorFaults'],
        rearRightMotorFaults = json['rearRightMotorFaults'],
        frontLeftMotorFaults = json['frontLeftMotorFaults'],
        frontRightMotorFaults = json['frontRightMotorFaults'],
        rearMcFaults = json['rearMcFaults'],
        frontMcFaults = json['frontMcFaults'],
        rearMcVoltage = json['rearMcVoltage'],
        frontMcVoltage = json['frontMcVoltage'],
        rearMcTemperature = json['rearMcTemperature'],
        frontMcTemperature = json['frontMcTemperature'],
        lightStatus = json['lightStatus'],
        pduChannelStatus = json['pduChannelStatus'];
  UgvSystemInfo copyWith({
    uint8_t? ts1Hour,
    uint8_t? ts1Minute,
    uint8_t? ts1Second,
    UgvHealthState? subsystemHealth1,
    UgvHealthState? subsystemHealth2,
    UgvHealthState? subsystemHealth3,
    UgvHealthState? subsystemHealth4,
    uint8_t? ts2Hour,
    uint8_t? ts2Minute,
    uint8_t? ts2Second,
    uint8_t? batterySoc,
    UgvMainMode? mainMode,
    UgvSubMode? subMode,
    UgvSpeedMode? speedMode,
    UgvDriveMode? driveMode,
    MavBool? armMode,
    UgvMainMode? intendedMainMode,
    UgvSubMode? intendedSubMode,
    UgvSpeedMode? intendedSpeedMode,
    UgvDriveMode? intendedDriveMode,
    MavBool? intendedArmMode,
    ModeChangeReason? modeChangeReason,
    uint8_t? ts3Hour,
    uint8_t? ts3Minute,
    uint8_t? ts3Second,
    UgvMotorError? rearLeftMotorFaults,
    UgvMotorError? rearRightMotorFaults,
    UgvMotorError? frontLeftMotorFaults,
    UgvMotorError? frontRightMotorFaults,
    UgvMotorCtrlError? rearMcFaults,
    UgvMotorCtrlError? frontMcFaults,
    uint8_t? rearMcVoltage,
    uint8_t? frontMcVoltage,
    uint8_t? rearMcTemperature,
    uint8_t? frontMcTemperature,
    uint8_t? lightStatus,
    uint8_t? pduChannelStatus,
  }) {
    return UgvSystemInfo(
      ts1Hour: ts1Hour ?? this.ts1Hour,
      ts1Minute: ts1Minute ?? this.ts1Minute,
      ts1Second: ts1Second ?? this.ts1Second,
      subsystemHealth1: subsystemHealth1 ?? this.subsystemHealth1,
      subsystemHealth2: subsystemHealth2 ?? this.subsystemHealth2,
      subsystemHealth3: subsystemHealth3 ?? this.subsystemHealth3,
      subsystemHealth4: subsystemHealth4 ?? this.subsystemHealth4,
      ts2Hour: ts2Hour ?? this.ts2Hour,
      ts2Minute: ts2Minute ?? this.ts2Minute,
      ts2Second: ts2Second ?? this.ts2Second,
      batterySoc: batterySoc ?? this.batterySoc,
      mainMode: mainMode ?? this.mainMode,
      subMode: subMode ?? this.subMode,
      speedMode: speedMode ?? this.speedMode,
      driveMode: driveMode ?? this.driveMode,
      armMode: armMode ?? this.armMode,
      intendedMainMode: intendedMainMode ?? this.intendedMainMode,
      intendedSubMode: intendedSubMode ?? this.intendedSubMode,
      intendedSpeedMode: intendedSpeedMode ?? this.intendedSpeedMode,
      intendedDriveMode: intendedDriveMode ?? this.intendedDriveMode,
      intendedArmMode: intendedArmMode ?? this.intendedArmMode,
      modeChangeReason: modeChangeReason ?? this.modeChangeReason,
      ts3Hour: ts3Hour ?? this.ts3Hour,
      ts3Minute: ts3Minute ?? this.ts3Minute,
      ts3Second: ts3Second ?? this.ts3Second,
      rearLeftMotorFaults: rearLeftMotorFaults ?? this.rearLeftMotorFaults,
      rearRightMotorFaults: rearRightMotorFaults ?? this.rearRightMotorFaults,
      frontLeftMotorFaults: frontLeftMotorFaults ?? this.frontLeftMotorFaults,
      frontRightMotorFaults:
          frontRightMotorFaults ?? this.frontRightMotorFaults,
      rearMcFaults: rearMcFaults ?? this.rearMcFaults,
      frontMcFaults: frontMcFaults ?? this.frontMcFaults,
      rearMcVoltage: rearMcVoltage ?? this.rearMcVoltage,
      frontMcVoltage: frontMcVoltage ?? this.frontMcVoltage,
      rearMcTemperature: rearMcTemperature ?? this.rearMcTemperature,
      frontMcTemperature: frontMcTemperature ?? this.frontMcTemperature,
      lightStatus: lightStatus ?? this.lightStatus,
      pduChannelStatus: pduChannelStatus ?? this.pduChannelStatus,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'ts1Hour': ts1Hour,
        'ts1Minute': ts1Minute,
        'ts1Second': ts1Second,
        'subsystemHealth1': subsystemHealth1,
        'subsystemHealth2': subsystemHealth2,
        'subsystemHealth3': subsystemHealth3,
        'subsystemHealth4': subsystemHealth4,
        'ts2Hour': ts2Hour,
        'ts2Minute': ts2Minute,
        'ts2Second': ts2Second,
        'batterySoc': batterySoc,
        'mainMode': mainMode,
        'subMode': subMode,
        'speedMode': speedMode,
        'driveMode': driveMode,
        'armMode': armMode,
        'intendedMainMode': intendedMainMode,
        'intendedSubMode': intendedSubMode,
        'intendedSpeedMode': intendedSpeedMode,
        'intendedDriveMode': intendedDriveMode,
        'intendedArmMode': intendedArmMode,
        'modeChangeReason': modeChangeReason,
        'ts3Hour': ts3Hour,
        'ts3Minute': ts3Minute,
        'ts3Second': ts3Second,
        'rearLeftMotorFaults': rearLeftMotorFaults,
        'rearRightMotorFaults': rearRightMotorFaults,
        'frontLeftMotorFaults': frontLeftMotorFaults,
        'frontRightMotorFaults': frontRightMotorFaults,
        'rearMcFaults': rearMcFaults,
        'frontMcFaults': frontMcFaults,
        'rearMcVoltage': rearMcVoltage,
        'frontMcVoltage': frontMcVoltage,
        'rearMcTemperature': rearMcTemperature,
        'frontMcTemperature': frontMcTemperature,
        'lightStatus': lightStatus,
        'pduChannelStatus': pduChannelStatus,
      };

  factory UgvSystemInfo.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvSystemInfo.mavlinkEncodedLength) {
      var len = UgvSystemInfo.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var ts1Hour = data_.getUint8(0);
    var ts1Minute = data_.getUint8(1);
    var ts1Second = data_.getUint8(2);
    var subsystemHealth1 = data_.getUint8(3);
    var subsystemHealth2 = data_.getUint8(4);
    var subsystemHealth3 = data_.getUint8(5);
    var subsystemHealth4 = data_.getUint8(6);
    var ts2Hour = data_.getUint8(7);
    var ts2Minute = data_.getUint8(8);
    var ts2Second = data_.getUint8(9);
    var batterySoc = data_.getUint8(10);
    var mainMode = data_.getUint8(11);
    var subMode = data_.getUint8(12);
    var speedMode = data_.getUint8(13);
    var driveMode = data_.getUint8(14);
    var armMode = data_.getUint8(15);
    var intendedMainMode = data_.getUint8(16);
    var intendedSubMode = data_.getUint8(17);
    var intendedSpeedMode = data_.getUint8(18);
    var intendedDriveMode = data_.getUint8(19);
    var intendedArmMode = data_.getUint8(20);
    var modeChangeReason = data_.getUint8(21);
    var ts3Hour = data_.getUint8(22);
    var ts3Minute = data_.getUint8(23);
    var ts3Second = data_.getUint8(24);
    var rearLeftMotorFaults = data_.getUint8(25);
    var rearRightMotorFaults = data_.getUint8(26);
    var frontLeftMotorFaults = data_.getUint8(27);
    var frontRightMotorFaults = data_.getUint8(28);
    var rearMcFaults = data_.getUint8(29);
    var frontMcFaults = data_.getUint8(30);
    var rearMcVoltage = data_.getUint8(31);
    var frontMcVoltage = data_.getUint8(32);
    var rearMcTemperature = data_.getUint8(33);
    var frontMcTemperature = data_.getUint8(34);
    var lightStatus = data_.getUint8(35);
    var pduChannelStatus = data_.getUint8(36);

    return UgvSystemInfo(
        ts1Hour: ts1Hour,
        ts1Minute: ts1Minute,
        ts1Second: ts1Second,
        subsystemHealth1: subsystemHealth1,
        subsystemHealth2: subsystemHealth2,
        subsystemHealth3: subsystemHealth3,
        subsystemHealth4: subsystemHealth4,
        ts2Hour: ts2Hour,
        ts2Minute: ts2Minute,
        ts2Second: ts2Second,
        batterySoc: batterySoc,
        mainMode: mainMode,
        subMode: subMode,
        speedMode: speedMode,
        driveMode: driveMode,
        armMode: armMode,
        intendedMainMode: intendedMainMode,
        intendedSubMode: intendedSubMode,
        intendedSpeedMode: intendedSpeedMode,
        intendedDriveMode: intendedDriveMode,
        intendedArmMode: intendedArmMode,
        modeChangeReason: modeChangeReason,
        ts3Hour: ts3Hour,
        ts3Minute: ts3Minute,
        ts3Second: ts3Second,
        rearLeftMotorFaults: rearLeftMotorFaults,
        rearRightMotorFaults: rearRightMotorFaults,
        frontLeftMotorFaults: frontLeftMotorFaults,
        frontRightMotorFaults: frontRightMotorFaults,
        rearMcFaults: rearMcFaults,
        frontMcFaults: frontMcFaults,
        rearMcVoltage: rearMcVoltage,
        frontMcVoltage: frontMcVoltage,
        rearMcTemperature: rearMcTemperature,
        frontMcTemperature: frontMcTemperature,
        lightStatus: lightStatus,
        pduChannelStatus: pduChannelStatus);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint8(0, ts1Hour);
    data_.setUint8(1, ts1Minute);
    data_.setUint8(2, ts1Second);
    data_.setUint8(3, subsystemHealth1);
    data_.setUint8(4, subsystemHealth2);
    data_.setUint8(5, subsystemHealth3);
    data_.setUint8(6, subsystemHealth4);
    data_.setUint8(7, ts2Hour);
    data_.setUint8(8, ts2Minute);
    data_.setUint8(9, ts2Second);
    data_.setUint8(10, batterySoc);
    data_.setUint8(11, mainMode);
    data_.setUint8(12, subMode);
    data_.setUint8(13, speedMode);
    data_.setUint8(14, driveMode);
    data_.setUint8(15, armMode);
    data_.setUint8(16, intendedMainMode);
    data_.setUint8(17, intendedSubMode);
    data_.setUint8(18, intendedSpeedMode);
    data_.setUint8(19, intendedDriveMode);
    data_.setUint8(20, intendedArmMode);
    data_.setUint8(21, modeChangeReason);
    data_.setUint8(22, ts3Hour);
    data_.setUint8(23, ts3Minute);
    data_.setUint8(24, ts3Second);
    data_.setUint8(25, rearLeftMotorFaults);
    data_.setUint8(26, rearRightMotorFaults);
    data_.setUint8(27, frontLeftMotorFaults);
    data_.setUint8(28, frontRightMotorFaults);
    data_.setUint8(29, rearMcFaults);
    data_.setUint8(30, frontMcFaults);
    data_.setUint8(31, rearMcVoltage);
    data_.setUint8(32, frontMcVoltage);
    data_.setUint8(33, rearMcTemperature);
    data_.setUint8(34, frontMcTemperature);
    data_.setUint8(35, lightStatus);
    data_.setUint8(36, pduChannelStatus);
    return data_;
  }
}

/// Describes the current software version along with checksum of the particular component of UGV system.
///
/// UGV_COMPONENT_VERSION
class UgvComponentVersion implements MavlinkMessage {
  static const int msgId = 50002;

  static const int crcExtra = 161;

  static const int mavlinkEncodedLength = 38;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Software version. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// software_version
  final uint32_t softwareVersion;

  /// SHA 256 Checksum of the build
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// checksum
  final List<int8_t> checksum;

  /// Target system id. Request: 0 (broadcast) or id of specific system. Response must contain system id of the requesting component.
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_system
  final uint8_t targetSystem;

  /// Target component id. Request: 0 (broadcast) or id of specific component. Response must contain component id of the requesting component.
  ///
  /// MAVLink type: uint8_t
  ///
  /// target_component
  final uint8_t targetComponent;

  UgvComponentVersion({
    required this.softwareVersion,
    required this.checksum,
    required this.targetSystem,
    required this.targetComponent,
  });

  UgvComponentVersion.fromJson(Map<String, dynamic> json)
      : softwareVersion = json['softwareVersion'],
        checksum = List<int>.from(json['checksum']),
        targetSystem = json['targetSystem'],
        targetComponent = json['targetComponent'];
  UgvComponentVersion copyWith({
    uint32_t? softwareVersion,
    List<int8_t>? checksum,
    uint8_t? targetSystem,
    uint8_t? targetComponent,
  }) {
    return UgvComponentVersion(
      softwareVersion: softwareVersion ?? this.softwareVersion,
      checksum: checksum ?? this.checksum,
      targetSystem: targetSystem ?? this.targetSystem,
      targetComponent: targetComponent ?? this.targetComponent,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'softwareVersion': softwareVersion,
        'checksum': checksum,
        'targetSystem': targetSystem,
        'targetComponent': targetComponent,
      };

  factory UgvComponentVersion.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvComponentVersion.mavlinkEncodedLength) {
      var len = UgvComponentVersion.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var softwareVersion = data_.getUint32(0, Endian.little);
    var checksum = MavlinkMessage.asUint8List(data_, 4, 32);
    var targetSystem = data_.getUint8(36);
    var targetComponent = data_.getUint8(37);

    return UgvComponentVersion(
        softwareVersion: softwareVersion,
        checksum: checksum,
        targetSystem: targetSystem,
        targetComponent: targetComponent);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, softwareVersion, Endian.little);
    MavlinkMessage.setUint8List(data_, 4, checksum);
    data_.setUint8(36, targetSystem);
    data_.setUint8(37, targetComponent);
    return data_;
  }
}

/// Describes the current software version along with checksum of whole UGV system
///
/// UGV_SUBSYSTEM_VERSION
class UgvSubsystemVersion implements MavlinkMessage {
  static const int msgId = 50003;

  static const int crcExtra = 50;

  static const int mavlinkEncodedLength = 181;

  @override
  int get mavlinkMessageId => msgId;

  @override
  int get mavlinkCrcExtra => crcExtra;

  /// Software version of component 1. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// component1_sw
  final uint32_t component1Sw;

  /// Software version of component 2. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// component2_sw
  final uint32_t component2Sw;

  /// Software version of component 3. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// component3_sw
  final uint32_t component3Sw;

  /// Software version of component 4. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// component4_sw
  final uint32_t component4Sw;

  /// Software version of component 5. The recommended format is SEMVER: 'major.minor.patch'  (any format may be used). The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint32_t
  ///
  /// component5_sw
  final uint32_t component5Sw;

  /// Type of the subsystem software.
  ///
  /// MAVLink type: uint8_t
  ///
  /// type
  final uint8_t type;

  /// Software checksum of component 1. The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// component1_checksum
  final List<int8_t> component1Checksum;

  /// Software checksum of component 2. The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// component2_checksum
  final List<int8_t> component2Checksum;

  /// Software checksum of component 3. The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// component3_checksum
  final List<int8_t> component3Checksum;

  /// Software checksum of component 4. The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// component4_checksum
  final List<int8_t> component4Checksum;

  /// Software checksum of component 5. The field must be zero terminated if it has a value. The field is optional and can be empty/all zeros.
  ///
  /// MAVLink type: uint8_t[32]
  ///
  /// component5_checksum
  final List<int8_t> component5Checksum;

  UgvSubsystemVersion({
    required this.component1Sw,
    required this.component2Sw,
    required this.component3Sw,
    required this.component4Sw,
    required this.component5Sw,
    required this.type,
    required this.component1Checksum,
    required this.component2Checksum,
    required this.component3Checksum,
    required this.component4Checksum,
    required this.component5Checksum,
  });

  UgvSubsystemVersion.fromJson(Map<String, dynamic> json)
      : component1Sw = json['component1Sw'],
        component2Sw = json['component2Sw'],
        component3Sw = json['component3Sw'],
        component4Sw = json['component4Sw'],
        component5Sw = json['component5Sw'],
        type = json['type'],
        component1Checksum = List<int>.from(json['component1Checksum']),
        component2Checksum = List<int>.from(json['component2Checksum']),
        component3Checksum = List<int>.from(json['component3Checksum']),
        component4Checksum = List<int>.from(json['component4Checksum']),
        component5Checksum = List<int>.from(json['component5Checksum']);
  UgvSubsystemVersion copyWith({
    uint32_t? component1Sw,
    uint32_t? component2Sw,
    uint32_t? component3Sw,
    uint32_t? component4Sw,
    uint32_t? component5Sw,
    uint8_t? type,
    List<int8_t>? component1Checksum,
    List<int8_t>? component2Checksum,
    List<int8_t>? component3Checksum,
    List<int8_t>? component4Checksum,
    List<int8_t>? component5Checksum,
  }) {
    return UgvSubsystemVersion(
      component1Sw: component1Sw ?? this.component1Sw,
      component2Sw: component2Sw ?? this.component2Sw,
      component3Sw: component3Sw ?? this.component3Sw,
      component4Sw: component4Sw ?? this.component4Sw,
      component5Sw: component5Sw ?? this.component5Sw,
      type: type ?? this.type,
      component1Checksum: component1Checksum ?? this.component1Checksum,
      component2Checksum: component2Checksum ?? this.component2Checksum,
      component3Checksum: component3Checksum ?? this.component3Checksum,
      component4Checksum: component4Checksum ?? this.component4Checksum,
      component5Checksum: component5Checksum ?? this.component5Checksum,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'component1Sw': component1Sw,
        'component2Sw': component2Sw,
        'component3Sw': component3Sw,
        'component4Sw': component4Sw,
        'component5Sw': component5Sw,
        'type': type,
        'component1Checksum': component1Checksum,
        'component2Checksum': component2Checksum,
        'component3Checksum': component3Checksum,
        'component4Checksum': component4Checksum,
        'component5Checksum': component5Checksum,
      };

  factory UgvSubsystemVersion.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvSubsystemVersion.mavlinkEncodedLength) {
      var len = UgvSubsystemVersion.mavlinkEncodedLength - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var component1Sw = data_.getUint32(0, Endian.little);
    var component2Sw = data_.getUint32(4, Endian.little);
    var component3Sw = data_.getUint32(8, Endian.little);
    var component4Sw = data_.getUint32(12, Endian.little);
    var component5Sw = data_.getUint32(16, Endian.little);
    var type = data_.getUint8(20);
    var component1Checksum = MavlinkMessage.asUint8List(data_, 21, 32);
    var component2Checksum = MavlinkMessage.asUint8List(data_, 53, 32);
    var component3Checksum = MavlinkMessage.asUint8List(data_, 85, 32);
    var component4Checksum = MavlinkMessage.asUint8List(data_, 117, 32);
    var component5Checksum = MavlinkMessage.asUint8List(data_, 149, 32);

    return UgvSubsystemVersion(
        component1Sw: component1Sw,
        component2Sw: component2Sw,
        component3Sw: component3Sw,
        component4Sw: component4Sw,
        component5Sw: component5Sw,
        type: type,
        component1Checksum: component1Checksum,
        component2Checksum: component2Checksum,
        component3Checksum: component3Checksum,
        component4Checksum: component4Checksum,
        component5Checksum: component5Checksum);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, component1Sw, Endian.little);
    data_.setUint32(4, component2Sw, Endian.little);
    data_.setUint32(8, component3Sw, Endian.little);
    data_.setUint32(12, component4Sw, Endian.little);
    data_.setUint32(16, component5Sw, Endian.little);
    data_.setUint8(20, type);
    MavlinkMessage.setUint8List(data_, 21, component1Checksum);
    MavlinkMessage.setUint8List(data_, 53, component2Checksum);
    MavlinkMessage.setUint8List(data_, 85, component3Checksum);
    MavlinkMessage.setUint8List(data_, 117, component4Checksum);
    MavlinkMessage.setUint8List(data_, 149, component5Checksum);
    return data_;
  }
}

class MavlinkDialectUgvcustom implements MavlinkDialect {
  static const int mavlinkVersion = 2;

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
      case 77:
        return CommandAck.parse(data);
      case 69:
        return ManualControl.parse(data);
      case 109:
        return RadioStatus.parse(data);
      case 1:
        return SysStatus.parse(data);
      case 2:
        return SystemTime.parse(data);
      case 50001:
        return UgvSystemInfo.parse(data);
      case 50002:
        return UgvComponentVersion.parse(data);
      case 50003:
        return UgvSubsystemVersion.parse(data);
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
      case 77:
        return CommandAck.crcExtra;
      case 69:
        return ManualControl.crcExtra;
      case 109:
        return RadioStatus.crcExtra;
      case 1:
        return SysStatus.crcExtra;
      case 2:
        return SystemTime.crcExtra;
      case 50001:
        return UgvSystemInfo.crcExtra;
      case 50002:
        return UgvComponentVersion.crcExtra;
      case 50003:
        return UgvSubsystemVersion.crcExtra;
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
