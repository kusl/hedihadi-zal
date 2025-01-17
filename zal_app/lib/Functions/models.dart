// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:color_print/color_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:zal/Functions/utils.dart';

enum AmdOrNvidia { amd, nvidia }

enum RyzenOrIntel { ryzen, intel }

enum ProgramTimesTimeframe { today, yesterday }

enum StorageType { SSD, HDD }

enum stressTestType { Ram, Cpu, Gpu }

enum SortBy { Name, Memory }

enum DataType { Hardwares, TaskManager }

enum SocketDataType {
  roomClients,
  pcData,
  notifications,
  drives,
  directory,
  file,
  informationText,
  fileComplete,
  gpuProcesses,
  fpsData,
  processIcon,
  runningProcesses
}

enum NewNotificationKey { Gpu, Cpu, Ram, Storage, Network }

enum NewNotificationFactorType { Higher, Lower }

enum FileType { file, folder }

enum FileProviderState { downloading, rebuilding, complete }

enum MoveFileType { move, copy }

enum SortFilesBy {
  nameAscending,
  nameDescending,
  sizeAscending,
  sizeDescending,
  dateModifiedAscending,
  dateModifiedDescending,
  dateCreatedAscending,
  dateCreatedDescending,
}

class ComputerAddress {
  String name;
  String ip;
  ComputerAddress({
    required this.name,
    required this.ip,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'ip': ip,
    };
  }

  factory ComputerAddress.fromMap(Map<String, dynamic> map) {
    return ComputerAddress(
      name: map['name'] as String,
      ip: map['ip'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComputerAddress.fromJson(String source) => ComputerAddress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ComputerAddress other) {
    if (identical(this, other)) return true;

    return other.name == name && other.ip == ip;
  }

  @override
  int get hashCode => name.hashCode ^ ip.hashCode;
}

class ConnectionEstablishment {
  final bool isConnectedToServer;
  final bool isComputerOnlineOnServer;
  final bool isWebrtcConnected;
  final bool hasReceivedData;
  final bool shouldShowConnectedWidget;
  final bool isConnectedToLocalServer;
  ConnectionEstablishment({
    required this.isConnectedToServer,
    required this.isComputerOnlineOnServer,
    required this.isWebrtcConnected,
    required this.hasReceivedData,
    required this.shouldShowConnectedWidget,
    required this.isConnectedToLocalServer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectionEstablishment &&
        other.isConnectedToServer == isConnectedToServer &&
        other.isComputerOnlineOnServer == isComputerOnlineOnServer &&
        other.isWebrtcConnected == isWebrtcConnected &&
        other.hasReceivedData == hasReceivedData &&
        other.shouldShowConnectedWidget == shouldShowConnectedWidget &&
        other.isConnectedToLocalServer == isConnectedToLocalServer;
  }

  @override
  int get hashCode {
    return isConnectedToServer.hashCode ^
        isComputerOnlineOnServer.hashCode ^
        isWebrtcConnected.hashCode ^
        hasReceivedData.hashCode ^
        shouldShowConnectedWidget.hashCode ^
        isConnectedToLocalServer.hashCode;
  }
}

class GpuProcess {
  final int pid;
  final String? icon;
  final int usage;
  final String name;
  GpuProcess({
    required this.pid,
    required this.icon,
    required this.usage,
    required this.name,
  });

  factory GpuProcess.fromMap(MapEntry<String, dynamic> map) {
    return GpuProcess(
      pid: map.value['pid']?.toInt() ?? 0,
      icon: (map.value['icon'] as String?),
      usage: map.value['usage']?.toInt() ?? 0,
      name: map.key,
    );
  }

  factory GpuProcess.fromJson(String source) => GpuProcess.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GpuProcess && other.pid == pid;
  }

  @override
  int get hashCode {
    return pid.hashCode ^ icon.hashCode ^ usage.hashCode ^ name.hashCode;
  }
}

class MoveFileModel {
  final FileData file;
  final MoveFileType moveType;
  MoveFileModel({
    required this.file,
    required this.moveType,
  });
}

class FileProviderModel {
  FileData? file;
  int lastBiggestByte;
  FileProviderState fileProviderState;
  FileProviderModel({
    required this.file,
    required this.lastBiggestByte,
    required this.fileProviderState,
  });

  FileProviderModel copyWith({
    FileData? file,
    int? lastBiggestByte,
    FileProviderState? fileProviderState,
  }) {
    return FileProviderModel(
      file: file ?? this.file,
      lastBiggestByte: lastBiggestByte ?? this.lastBiggestByte,
      fileProviderState: fileProviderState ?? this.fileProviderState,
    );
  }
}

class FileData {
  final String name;

  final String? extension;
  final String directory;

  ///in bytes
  final int size;
  FileType fileType;
  final DateTime dateCreated;
  final DateTime dateModified;
  FileData({
    required this.name,
    this.extension,
    required this.directory,
    required this.size,
    required this.fileType,
    required this.dateCreated,
    required this.dateModified,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    if (extension != null) {
      result.addAll({'extension': extension});
    }
    result.addAll({'directory': directory});
    result.addAll({'size': size});
    result.addAll({'fileType': fileType.name});
    result.addAll({'dateCreated': dateCreated.millisecondsSinceEpoch});
    result.addAll({'dateModified': dateModified.millisecondsSinceEpoch});

    return result;
  }

  factory FileData.fromMap(Map<String, dynamic> map) {
    return FileData(
      name: map['name'] ?? '',
      extension: map['extension'],
      directory: map['directory'] ?? '',
      size: map['size']?.toInt() ?? 0,
      fileType: FileType.values.byName(map['fileType']),
      dateCreated: map['dateCreated'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateCreated']) : DateTime.fromMillisecondsSinceEpoch(0),
      dateModified: map['dateModified'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateModified']) : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  String toJson() => json.encode(toMap());

  factory FileData.fromJson(String source) => FileData.fromMap(json.decode(source));
}

class SocketData {
  SocketDataType type;
  dynamic data;
  SocketData({
    required this.data,
    required this.type,
  });
}

///used for creating new notification, this object holds the key's children with the unit of measurement.
class NotificationKeyWithUnit {
  String keyName;
  String unit;

  ///if [displayName] isn't null, it'll be shown instead of keyName.
  String? displayName;
  NotificationKeyWithUnit({required this.keyName, required this.unit, this.displayName});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationKeyWithUnit && other.keyName == keyName && other.unit == unit;
  }

  @override
  int get hashCode => keyName.hashCode ^ unit.hashCode;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'keyName': keyName});
    result.addAll({'unit': unit});
    if (displayName != null) {
      result.addAll({'displayName': displayName});
    }

    return result;
  }

  factory NotificationKeyWithUnit.fromMap(Map<String, dynamic> map) {
    return NotificationKeyWithUnit(
      keyName: map['keyName'] ?? '',
      unit: map['unit'] ?? '',
      displayName: map['displayName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationKeyWithUnit.fromJson(String source) => NotificationKeyWithUnit.fromMap(json.decode(source));
}

///this model is used for creating a new notification
class NotificationData {
  final NewNotificationKey? key;
  final NotificationKeyWithUnit? childKey;
  final NewNotificationFactorType? factorType;
  final double? factorValue;
  final int? secondsThreshold;
  bool suspended;
  NotificationData({
    this.key,
    this.childKey,
    this.factorType,
    this.factorValue,
    this.secondsThreshold,
    this.suspended = false,
  });

  NotificationData copyWith({
    NewNotificationKey? key,
    NotificationKeyWithUnit? childKey,
    NewNotificationFactorType? factorType,
    double? factorValue,
    int? secondsThreshold,
    bool? suspended,
  }) {
    return NotificationData(
      key: key ?? this.key,
      childKey: childKey ?? this.childKey,
      factorType: factorType ?? this.factorType,
      factorValue: factorValue ?? this.factorValue,
      secondsThreshold: secondsThreshold ?? this.secondsThreshold,
      suspended: suspended ?? this.suspended,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (key != null) {
      result.addAll({'key': key!.name.toString()});
    }
    if (childKey != null) {
      result.addAll({'childKey': childKey!.toMap()});
    }
    if (factorType != null) {
      result.addAll({'factorType': factorType!.name.toString()});
    }
    if (factorValue != null) {
      result.addAll({'factorValue': factorValue});
    }
    if (secondsThreshold != null) {
      result.addAll({'secondsThreshold': secondsThreshold});
    }
    result.addAll({'suspended': suspended});
    return result;
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      key: map['key'] != null ? NewNotificationKey.values[map['key']] : null,
      childKey: map['childKey'] != null ? NotificationKeyWithUnit.fromMap(map['childKey']) : null,
      factorType: map['factorType'] != null ? NewNotificationFactorType.values[map['factorType']] : null,
      factorValue: double.parse(map['factorValue'].toString()),
      secondsThreshold: map['secondsThreshold']?.toInt(),
      suspended: map['suspended'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) => NotificationData.fromMap(json.decode(source));
}

///this is solely used in home_screen for gpus widget
class ComputerDataWithBuildContext {
  final ComputerData computerData;
  final BuildContext context;
  ComputerDataWithBuildContext({
    required this.computerData,
    required this.context,
  });
}

class FpsData {
  List<double> fpsList;
  double currentFps;
  double averageFps;
  double fps01Low;
  double fps001Low;

  calculateFps() {
    final sortedFps = List<double>.from(fpsList);
    sortedFps.sort((a, b) => a.compareTo(b));
    fps01Low = calculatePercentile(sortedFps, 0.01).toPrecision(2);
    fps001Low = calculatePercentile(sortedFps, 0.001).toPrecision(2);
    double totalFPS = sortedFps.reduce((a, b) => a + b);
    averageFps = totalFPS / fpsList.length;
  }

  addFps(double fps) {
    fpsList.add(fps);
  }

  double calculatePercentile(List<double> data, double percentile) {
    double realIndex = (percentile) * (data.length - 1);
    int index = realIndex.toInt();
    double frac = realIndex - index;
    if (index + 1 < data.length) {
      return data[index] * (1 - frac) + data[index + 1] * frac;
    } else {
      return data[index];
    }
  }

  FpsData({
    required this.fpsList,
    required this.currentFps,
    required this.fps01Low,
    required this.fps001Low,
    required this.averageFps,
  });

  FpsData copyWith({
    List<double>? fpsList,
    double? currentFps,
    double? averageFps,
    double? fps01Low,
    double? fps001Low,
    DateTime? date,
  }) {
    return FpsData(
      fpsList: fpsList ?? this.fpsList,
      currentFps: currentFps ?? this.currentFps,
      averageFps: averageFps ?? this.averageFps,
      fps01Low: fps01Low ?? this.fps01Low,
      fps001Low: fps001Low ?? this.fps001Low,
    );
  }
}

///used to keep track of highest values in fps screen
class FpsComputerData {
  final ComputerData computerData;
  final Map<String, num> highestValues;
  FpsComputerData({
    required this.computerData,
    required this.highestValues,
  });
}

class FpsRecord {
  FpsData fpsData;
  String presetName;

  ///how long the fps was running, in formatted text.
  String presetDuration;
  String? note;

  FpsRecord({
    required this.fpsData,
    required this.presetName,
    required this.presetDuration,
    this.note,
  });
}

///a class that contains fps and time, this is used to represent fps data on a line chart.
class FpsTime {
  double fps;
  DateTime time;
  FpsTime({
    required this.fps,
    required this.time,
  });
}

class ProgramTimeScreenData {
  Map<DateTime, int> dates;
  int totalYear;
  ProgramTimeScreenData({
    required this.dates,
    required this.totalYear,
  });

  factory ProgramTimeScreenData.fromMap(Map<String, dynamic> map) {
    Map<DateTime, int> result = {};
    for (final data in map['dates'].entries) {
      DateTime dateTime = DateFormat("yyyy-MM-dd").parse(data.key);
      result[dateTime] = data.value;
    }
    return ProgramTimeScreenData(
      dates: result,
      totalYear: map['total_year']?.toInt() ?? 0,
    );
  }

  factory ProgramTimeScreenData.fromJson(String source) => ProgramTimeScreenData.fromMap(json.decode(source));
}

class ProgramTime {
  final String name;
  final int minutes;
  ProgramTime({
    required this.name,
    required this.minutes,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'total_minutes': minutes});

    return result;
  }

  factory ProgramTime.fromMap(Map<String, dynamic> map) {
    return ProgramTime(
      name: map['name'] ?? '',
      minutes: map['minutes'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgramTime.fromJson(String source) => ProgramTime.fromMap(json.decode(source));
}

class SocketObject {
  late Socket socket;
  Timer? timer;
  SocketObject(String localSocketAddress, {Map<String, dynamic> extraQueries = const {}}) {
    socket = io(
      localSocketAddress,
      <String, dynamic>{
        'transports': ['websocket'],
        'query': {
          ...extraQueries,
          'EIO': '4',
        },
      },
    );

    socket.on('connection', (_) {
      print('connect ${_.toString()}');
    });
    socket.on('connect_error', (a) {
      print('error $a');
    });
    socket.onDisconnect((_) {});
    socket.onConnect((_) {
      //join the room
      // joinRoom();
      //send a keep_alive event so the pc starts sending data
      //socket.emit("keep_alive", "");
    });
  }

  sendData(String to, String data) {
    socket.emit(to, {'data': data});
  }

  // initiateTaskmanager() {
  //   if (timer != null) {
  //     socket.emit("taskmanager_keep_alive", "hi");
  //     timer = Timer.periodic(Duration(seconds: 9), (Timer t) {
  //       socket.emit("taskmanager_keep_alive", "hi");
  //     });
  //   }
  // }
}

class Cpu {
  /// name of the cpu
  String name;

  /// in celcious
  double? temperature;

  /// power in watts
  double power;

  /// watts used by each core
  SplayTreeMap<String, double> powers = SplayTreeMap();

  /// clock speed in mhz for each core
  SplayTreeMap<String, double?> clocks = SplayTreeMap();

  /// overall load of the cpu in percentage;
  double load;

  /// load percentage of each core
  SplayTreeMap<String, double> loads = SplayTreeMap();

  /// voltage of each core
  SplayTreeMap<String, double> voltages = SplayTreeMap();

  //static information about the cpu
  CpuInfo? cpuInfo;
  Cpu({
    required this.name,
    required this.temperature,
    required this.power,
    required this.powers,
    required this.clocks,
    required this.load,
    required this.loads,
    required this.voltages,
    required this.cpuInfo,
  });

  factory Cpu.fromMap(Map<String, dynamic> map) {
    SplayTreeMap<String, double?> clocks = SplayTreeMap<String, double?>();
    for (final clock in Map<String, dynamic>.from(map['clocks']).entries) {
      if (clock.value == "NaN") {
        clocks[clock.key] = null;
      } else {
        clocks[clock.key] = clock.value;
      }
    }
    double? temperature = map['temperature']?.toDouble();
    if (temperature == null || temperature < 0.1) {
      temperature = null;
    }
    final cpu = Cpu(
      name: map['name'] ?? '',
      temperature: temperature,
      power: map['power']?.toDouble() ?? 0.0,
      powers: SplayTreeMap<String, double>.from(map['powers']),
      clocks: clocks,
      load: map['load']?.toDouble() ?? 0.0,
      loads: SplayTreeMap<String, double>.from(map['loads']),
      voltages: SplayTreeMap<String, double>.from(map['voltages']),
      cpuInfo: map['cpuInfo'] != null ? CpuInfo.fromMap(map['cpuInfo']) : null,
    );

    cpu.loads = SplayTreeMap<String, double>.from(map['loads'], (a, b) => extractFirstNumber(a).compareTo(extractFirstNumber(b)));
    cpu.clocks.removeWhere((key, value) => key.contains('Core') == false);
    if (cpu.clocks.containsValue(null) == false) {
      cpu.clocks = SplayTreeMap<String, double>.from(cpu.clocks, (a, b) => extractFirstNumber(a).compareTo(extractFirstNumber(b)));
    }
    return cpu;
  }
  static int extractFirstNumber(String input) {
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(input);
    if (match != null) {
      String numberString = match.group(0) ?? '-1';
      int? number = int.tryParse(numberString);
      if (number != null) {
        return number;
      }
    }
    return -1;
  }

  factory Cpu.fromJson(String source) => Cpu.fromMap(json.decode(source));
  factory Cpu.nullData() {
    return Cpu(
        name: "-1",
        temperature: -1,
        power: -1,
        powers: SplayTreeMap(),
        clocks: SplayTreeMap(),
        load: -1,
        loads: SplayTreeMap(),
        voltages: SplayTreeMap(),
        cpuInfo: CpuInfo(name: "-1", socket: "-1", speed: -1, busSpeed: -1, l2Cache: -1, l3Cache: -1, cores: -1, threads: -1));
  }

  double getAverageClock() {
    if (clocks.values.toList().contains(null)) return 0;

    final List<double> numbersList = List<double>.from(clocks.values.toList());
    if (numbersList.isEmpty) {
      return 0.0; // Return 0 if the list is empty to avoid division by zero
    }
    double sum = numbersList.reduce((value, element) => value + element);
    return sum / numbersList.length;
  }

  CpuCoreInfo getCpuCoreinfo(int index) {
    final clocksList = clocks.entries.toList();
    final loadsList = loads.entries.toList();
    final voltagesList = voltages.entries.toList();
    final powersList = powers.entries.toList();

    final clock = clocksList.length > (index) ? clocksList[index].value : null;
    final load = loadsList.length > (index) ? loadsList[index].value : null;
    final voltage = voltagesList.length > (index) ? voltagesList[index].value : null;
    final power = powersList.length > (index) ? powersList[index].value : null;
    return CpuCoreInfo(clock: clock, load: load, voltage: voltage, power: power);
  }
}

class CpuCoreInfo {
  double? clock;
  double? load;
  double? voltage;
  double? power;
  CpuCoreInfo({
    required this.clock,
    required this.load,
    required this.voltage,
    required this.power,
  });
}

class CpuInfo {
  String name;
  String socket;
  int speed;
  int busSpeed;
  int l2Cache;
  int l3Cache;
  int cores;
  int threads;
  CpuInfo({
    required this.name,
    required this.socket,
    required this.speed,
    required this.busSpeed,
    required this.l2Cache,
    required this.l3Cache,
    required this.cores,
    required this.threads,
  });

  factory CpuInfo.fromMap(Map<String, dynamic> map) {
    return CpuInfo(
      name: map['name'] ?? '',
      socket: map['socket'] ?? '',
      speed: map['speed']?.toInt() ?? 0,
      busSpeed: map['busSpeed']?.toInt() ?? 0,
      l2Cache: map['l2Cache']?.toInt() ?? 0,
      l3Cache: map['l3Cache']?.toInt() ?? 0,
      cores: map['cores']?.toInt() ?? 0,
      threads: map['threads']?.toInt() ?? 0,
    );
  }
  factory CpuInfo.fromJson(String source) => CpuInfo.fromMap(json.decode(source));
}

class Gpu {
  /// name of the gpu
  String name;

  /// core speed in mhz
  double coreSpeed;

  /// memory speed in mhz
  double memorySpeed;
  double fanSpeedPercentage;

  /// core load in percentage
  double corePercentage;

  ///power used by gpu in watts
  double power;

  ///memory used in megabytes
  double dedicatedMemoryUsed;

  ///in celcious
  double temperature;
  double voltage;
  int fps;
  Gpu({
    required this.name,
    required this.coreSpeed,
    required this.memorySpeed,
    required this.fanSpeedPercentage,
    required this.corePercentage,
    required this.power,
    required this.dedicatedMemoryUsed,
    required this.temperature,
    required this.voltage,
    required this.fps,
  });
  factory Gpu.nullData() {
    return Gpu(
      name: "-1",
      coreSpeed: -1,
      memorySpeed: -1,
      fanSpeedPercentage: -1,
      corePercentage: -1,
      power: -1,
      dedicatedMemoryUsed: -1,
      temperature: -1,
      voltage: -1,
      fps: -1,
    );
  }
  factory Gpu.fromMap(Map<String, dynamic> map) {
    return Gpu(
      name: map['name'] ?? '',
      coreSpeed: map['coreSpeed']?.toDouble() ?? 0.0,
      memorySpeed: map['memorySpeed']?.toDouble() ?? 0.0,
      fanSpeedPercentage: map['fanSpeedPercentage']?.toDouble() ?? 0.0,
      corePercentage: map['corePercentage']?.toDouble() ?? 0.0,
      power: map['power']?.toDouble() ?? 0.0,
      dedicatedMemoryUsed: map['dedicatedMemoryUsed']?.toDouble() ?? 0.0,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      voltage: map['voltage']?.toDouble() ?? 0.0,
      fps: (map['fps'] ?? 0).round(),
    );
  }

  factory Gpu.fromJson(String source) => Gpu.fromMap(json.decode(source));

  factory Gpu.max(Gpu oldGpu, Gpu newGpu) {
    return Gpu(
      name: newGpu.name,
      coreSpeed: oldGpu.coreSpeed < newGpu.coreSpeed ? newGpu.coreSpeed : oldGpu.coreSpeed,
      memorySpeed: oldGpu.memorySpeed < newGpu.memorySpeed ? newGpu.memorySpeed : oldGpu.memorySpeed,
      fanSpeedPercentage: oldGpu.fanSpeedPercentage < newGpu.fanSpeedPercentage ? newGpu.fanSpeedPercentage : oldGpu.fanSpeedPercentage,
      corePercentage: oldGpu.corePercentage < newGpu.corePercentage ? newGpu.corePercentage : oldGpu.corePercentage,
      power: oldGpu.power < newGpu.power ? newGpu.power : oldGpu.power,
      dedicatedMemoryUsed: oldGpu.dedicatedMemoryUsed < newGpu.dedicatedMemoryUsed ? newGpu.dedicatedMemoryUsed : oldGpu.dedicatedMemoryUsed,
      temperature: oldGpu.temperature < newGpu.temperature ? newGpu.temperature : oldGpu.temperature,
      voltage: oldGpu.voltage < newGpu.voltage ? newGpu.voltage : oldGpu.voltage,
      fps: oldGpu.fps < newGpu.fps ? newGpu.fps : oldGpu.fps,
    );
  }
}

class Battery {
  ///is the laptop being charged or not.
  bool isCharging;

  ///the amount of charge the battery has left, it's between 0 and 100
  int batteryPercentage;

  ///the remaining time before the battery runs out, in seconds.
  int lifeRemaining;

  ///whether the pc has a battery or not
  bool hasBattery;
  Battery({
    required this.isCharging,
    required this.batteryPercentage,
    required this.lifeRemaining,
    required this.hasBattery,
  });

  factory Battery.fromMap(Map<String, dynamic> map) {
    return Battery(
      isCharging: map['isCharging'] ?? false,
      batteryPercentage: map['life']?.toInt() ?? 0,
      lifeRemaining: map['lifeRemaining']?.toInt() ?? 0,
      hasBattery: map['hasBattery'] ?? false,
    );
  }
  factory Battery.nullData() {
    return Battery(
      isCharging: false,
      batteryPercentage: 0,
      lifeRemaining: 0,
      hasBattery: false,
    );
  }
  factory Battery.fromJson(String source) => Battery.fromMap(json.decode(source));
}

class NetworkSpeed {
  ///in bytes
  final int download;

  ///in bytes
  final int upload;

  NetworkSpeed({
    required this.download,
    required this.upload,
  });

  factory NetworkSpeed.fromMap(Map<String, dynamic> map) {
    return NetworkSpeed(
      download: map['download']?.toInt() ?? 0,
      upload: map['upload']?.toInt() ?? 0,
    );
  }
}

class ComputerData {
  late Map<String, dynamic> rawData;
  late Ram ram;
  late Cpu cpu;
  late Gpu gpu;
  late List<Storage> storages;
  late List<Monitor> monitors;
  late Motherboard motherboard;
  late Battery battery;
  late List<NetworkInterface> networkInterfaces;
  List<String>? availableGpus;
  List<TaskmanagerProcess>? taskmanagerProcesses;
  NetworkSpeed? networkSpeed;
  late bool isRunningAsAdminstrator;

  ///the data that's used inside charts will be saved here,
  ///for example if we want to make a chart for gpu loads, we will save the gpu loads of each second into this variable
  late Map<String, List<dynamic>> charts;

  ///this has the processes and their gpu utilization, we use this to auto detect game process.
  Map<int, double>? processesGpuUsage = {};

  ComputerData();

  ComputerData.construct(String data) {
    final parsedData = jsonDecode(data.replaceAll("'", '"'));
    rawData = parsedData;
    availableGpus = parsedData.containsKey("availableGpus") ? List<String>.from(parsedData['availableGpus']) : [];
    charts = parsedData.containsKey("charts") ? Map<String, List<dynamic>>.from(parsedData['charts']) : {};
    final computerData = parsedData['computerData'];
    isRunningAsAdminstrator = computerData['isAdminstrator'];
    processesGpuUsage = computerData["processesGpuUsage"] == null
        ? null
        : Map<String, double>.from(computerData["processesGpuUsage"]).map((key, value) => MapEntry(int.parse(key), value));
    if (computerData['ramData'] != null) {
      ram = Ram.fromMap(computerData['ramData']);
    } else {
      ram = Ram.nullData();
    }
    if (computerData['cpuData'] != null) {
      cpu = Cpu.fromMap(computerData['cpuData']);
    } else {
      cpu = Cpu.nullData();
    }

    if (computerData['gpuData'] != null) {
      gpu = Gpu.fromMap(computerData['gpuData']);
    } else {
      gpu = Gpu.nullData();
    }
    if (computerData['motherboardData'] != null) {
      motherboard = Motherboard.fromMap(computerData['motherboardData']);
    } else {
      motherboard = Motherboard.nullData();
    }
    if (computerData['batteryData'] != null) {
      battery = Battery.fromMap(computerData['batteryData']);
    } else {
      battery = Battery.nullData();
    }
    //battery = Battery(isCharging: true, batteryPercentage: 60, lifeRemaining: 94, hasBattery: true);
    if (computerData['storagesData'] != null) {
      storages = List<Map<String, dynamic>>.from(computerData['storagesData']).map((e) => Storage.fromMap(e)).toList();
    } else {
      storages = [Storage.nullData()];
    }
    storages.sort((a, b) => a.diskNumber.compareTo(b.diskNumber));
    if (computerData['monitorsData'] != null) {
      monitors = List<Map<String, dynamic>>.from(computerData['monitorsData']).map((e) => Monitor.fromMap(e)).toList();
    } else {
      monitors = [Monitor.nullData()];
    }
    if (computerData['primaryNetworkSpeed'] != null) networkSpeed = NetworkSpeed.fromMap(computerData["primaryNetworkSpeed"]);
    if (computerData.containsKey("taskmanagerData") && computerData['taskmanagerData'] != null) {
      taskmanagerProcesses = Map<String, dynamic>.from(computerData['taskmanagerData']).entries.map((e) => TaskmanagerProcess.fromMap(e)).toList();
    }
    if (computerData.containsKey("networkInterfaces")) {
      networkInterfaces = List<Map<String, dynamic>>.from(computerData['networkInterfaces']).map((e) => NetworkInterface.fromMap(e)).toList();
    }
  }
}

///we use this class to store the computer specs
class ComputerSpecs {
  String motherboardName;
  String ramSize;
  String gpuName;
  String cpuName;

  List<String> storages;
  List<String> monitors;
  ComputerSpecs({
    required this.motherboardName,
    required this.ramSize,
    required this.gpuName,
    required this.cpuName,
    required this.storages,
    required this.monitors,
  });
  factory ComputerSpecs.fromComputerData(ComputerData data) {
    return ComputerSpecs(
      motherboardName: data.motherboard.name,
      ramSize: "${(data.ram.memoryAvailable + data.ram.memoryUsed).toStringAsFixed(2)}GB",
      gpuName: data.gpu.name,
      cpuName: data.cpu.name,
      storages: data.storages.map((e) => '${(e.totalSize / 1024 / 1024 / 1024).round()} GB ${e.type}').toList(),
      monitors: data.monitors.map((e) => '${e.width} x ${e.height}${e.primary ? ' primary' : ''}').toList(),
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'motherboardName': motherboardName});
    result.addAll({'ramSize': ramSize});
    result.addAll({'gpuName': gpuName});
    result.addAll({'cpuName': cpuName});
    result.addAll({'storages': storages});
    result.addAll({'monitors': monitors});

    return result;
  }

  factory ComputerSpecs.fromMap(Map<String, dynamic> map) {
    return ComputerSpecs(
      motherboardName: map['motherboardName'] ?? '',
      ramSize: map['ramSize'] ?? '',
      gpuName: map["gpuName"] ?? '',
      cpuName: map['cpuName'] ?? '',
      storages: List<String>.from(map['storages']),
      monitors: List<String>.from(map['monitors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComputerSpecs.fromJson(String source) => ComputerSpecs.fromMap(json.decode(source));
}

class Storage {
  final int diskNumber;
  final int totalSize;
  final int freeSpace;
  final int temperature;
  final int readRate;
  final int writeRate;
  final String type;
  final List<Partition>? partitions;
  final Map<String, dynamic> info;
  final List<SmartAttribute> smartAttributes;
  Storage({
    required this.diskNumber,
    required this.totalSize,
    required this.freeSpace,
    required this.temperature,
    required this.readRate,
    required this.writeRate,
    required this.type,
    required this.partitions,
    required this.info,
    required this.smartAttributes,
  });
  String getDisplayName() {
    return "${truncateString(partitions?.firstOrNull?.label ?? type, 10)} | ${totalSize.toSize(decimals: 0)}";
  }

  factory Storage.fromMap(Map<String, dynamic> map) {
    List<Partition>? partitions;
    if (map.containsKey("partitions") && map['partitions'] != null) {
      partitions = List<Partition>.from(map['partitions']?.map((x) => Partition.fromMap(x)))..sort((b, a) => a.size.compareTo(b.size));
    }
    return Storage(
      diskNumber: map['diskNumber']?.toInt() ?? 0,
      totalSize: map['totalSize']?.toInt() ?? 0,
      freeSpace: map['freeSpace']?.toInt() ?? 0,
      temperature: map['temperature']?.toInt() ?? 0,
      readRate: map['readRate']?.toInt() ?? 0,
      writeRate: map['writeRate']?.toInt() ?? 0,
      type: map['type'] ?? '',
      partitions: partitions,
      smartAttributes: List<Map<String, dynamic>>.from(map['smartAttributes']).map((e) => SmartAttribute.fromMap(e)).toList(),
      info: map["info"],
    );
  }
  factory Storage.nullData() {
    return Storage(
      diskNumber: -1,
      totalSize: -1,
      freeSpace: -1,
      temperature: -1,
      readRate: -1,
      writeRate: -1,
      type: "HDD",
      partitions: null,
      smartAttributes: [],
      info: {},
    );
  }
  factory Storage.fromJson(String source) => Storage.fromMap(json.decode(source));
}

class Partition {
  final String driveLetter;
  final String label;
  final int size;
  final int freeSpace;
  Partition({
    required this.driveLetter,
    required this.label,
    required this.size,
    required this.freeSpace,
  });

  factory Partition.fromMap(Map<String, dynamic> map) {
    return Partition(
      driveLetter: map['driveLetter'] ?? '',
      label: map['label'] ?? '',
      size: map['size']?.toInt() ?? 0,
      freeSpace: map['freeSpace']?.toInt() ?? 0,
    );
  }

  factory Partition.fromJson(String source) => Partition.fromMap(json.decode(source));
}

class Motherboard {
  String name;
  double temperature;
  Motherboard({
    required this.name,
    required this.temperature,
  });

  factory Motherboard.fromMap(Map<String, dynamic> map) {
    return Motherboard(
      name: map['name'] ?? '',
      temperature: map['temperature']?.toDouble() ?? 0.0,
    );
  }
  factory Motherboard.nullData() {
    return Motherboard(
      name: '-1',
      temperature: -1,
    );
  }
  factory Motherboard.fromJson(String source) => Motherboard.fromMap(json.decode(source));
}

class TaskmanagerProcess {
  ///this contains the list of processes,
  ///sometimes a program runs multiple processes,
  ///for example, firefox has more than 8 processes when you use it, we combine all the processes and get a sum of the usage for that program.
  List<int> pids;
  String name;

  ///in megabytes
  double memoryUsage;
  double cpuPercent;
  Uint8List? icon;

  TaskmanagerProcess({
    required this.pids,
    required this.name,
    required this.memoryUsage,
    required this.cpuPercent,
    this.icon,
  });

  factory TaskmanagerProcess.fromMap(MapEntry<String, dynamic> data) {
    Uint8List? icon;
    if (data.value['icon'] != null) {
      icon = base64Decode(data.value['icon']);
    }
    return TaskmanagerProcess(
      pids: List<int>.from(data.value['pids'] ?? []),
      name: data.key,
      memoryUsage: data.value['memoryUsage']?.toDouble() ?? 0.0,
      cpuPercent: data.value['cpuPercent']?.toDouble() ?? 0.0,
      icon: icon,
      //networkUsage: (data['networkReadRate'] + data['networkWriteRate'])?.toDouble() ?? 0.0,
      //diskUsage: (data['diskReadRate'] + data['diskWriteRate'])?.toDouble() ?? 0.0,
    );
  }
}

class NetworkInterface {
  final String name;
  final String description;
  final bool isEnabled;
  final String id;
  final int bytesSent;
  final int bytesReceived;
  final bool isPrimary;
  NetworkInterface({
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.id,
    required this.bytesSent,
    required this.bytesReceived,
    required this.isPrimary,
  });

  factory NetworkInterface.fromMap(Map<String, dynamic> map) {
    return NetworkInterface(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isEnabled: (map['status'] ?? "Down") != "Down",
      id: map['id'] ?? '',
      bytesSent: map['bytesSent']?.toInt() ?? 0,
      bytesReceived: map['bytesReceived']?.toInt() ?? 0,
      isPrimary: map['isPrimary'] ?? false,
    );
  }

  factory NetworkInterface.fromJson(String source) => NetworkInterface.fromMap(json.decode(source));
}

class Monitor {
  String name;
  bool primary;
  int height;
  int width;
  int bitsPerPixel;
  Monitor({
    required this.name,
    required this.primary,
    required this.height,
    required this.width,
    required this.bitsPerPixel,
  });

  factory Monitor.fromMap(Map<String, dynamic> map) {
    return Monitor(
      name: map['name'] ?? '',
      primary: map['primary'] ?? false,
      height: map['height']?.toInt() ?? 0,
      width: map['width']?.toInt() ?? 0,
      bitsPerPixel: map['bitsPerPixel']?.toInt() ?? 0,
    );
  }
  factory Monitor.nullData() {
    return Monitor(
      name: '-1',
      primary: false,
      height: -1,
      width: -1,
      bitsPerPixel: -1,
    );
  }
  factory Monitor.fromJson(String source) => Monitor.fromMap(json.decode(source));
}

class Ram {
  ///in gigabytes
  final double memoryUsed;

  ///in gigabytes
  final double memoryAvailable;
  final int memoryUsedPercentage;
  final List<RamPiece> ramPieces;
  Ram({
    required this.memoryUsed,
    required this.memoryAvailable,
    required this.memoryUsedPercentage,
    required this.ramPieces,
  });

  factory Ram.fromMap(Map<String, dynamic> map) {
    return Ram(
      memoryUsed: map['memoryUsed'] ?? 0,
      memoryAvailable: map['memoryAvailable'] ?? 0,
      memoryUsedPercentage: map['memoryUsedPercentage']?.toInt() ?? 0,
      ramPieces: map['ramPiecesData'] != null ? List<RamPiece>.from(map['ramPiecesData']?.map((x) => RamPiece.fromMap(x))) : [],
    );
  }

  factory Ram.nullData() {
    return Ram(
      memoryUsed: -1,
      memoryAvailable: -1,
      memoryUsedPercentage: -1,
      ramPieces: [],
    );
  }
  factory Ram.fromJson(String source) => Ram.fromMap(json.decode(source));
}

class RamPiece {
  final int capacity;
  final String manufacturer;
  final String partNumber;
  final int clockSpeed;
  RamPiece({
    required this.capacity,
    required this.manufacturer,
    required this.partNumber,
    required this.clockSpeed,
  });

  factory RamPiece.fromMap(Map<String, dynamic> map) {
    return RamPiece(
      capacity: map['capacity']?.toInt() ?? 0,
      manufacturer: map['manufacturer'] ?? '',
      partNumber: map['partNumber'] ?? '',
      clockSpeed: map['speed']?.toInt() ?? 0,
    );
  }

  factory RamPiece.fromJson(String source) => RamPiece.fromMap(json.decode(source));
}

class SmartAttribute {
  final String attributeName;
  final int id;
  final int? currentValue;
  final int? worstValue;
  final int? threshold;
  final int rawValue;
  SmartAttribute({
    required this.attributeName,
    required this.id,
    required this.currentValue,
    required this.worstValue,
    required this.threshold,
    required this.rawValue,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'attributeName': attributeName});
    result.addAll({'id': id});
    result.addAll({'currentValue': currentValue});
    result.addAll({'worstValue': worstValue});
    result.addAll({'threshold': threshold});
    result.addAll({'rawValue': rawValue});

    return result;
  }

  factory SmartAttribute.fromMap(Map<String, dynamic> map) {
    return SmartAttribute(
      attributeName: map['attributeName'] ?? '',
      id: int.tryParse(map['id']) ?? 0,
      currentValue: map['currentValue']?.toInt(),
      worstValue: map['worstValue']?.toInt(),
      threshold: map['threshold']?.toInt(),
      rawValue: map['rawValue']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SmartAttribute.fromJson(String source) => SmartAttribute.fromMap(json.decode(source));
}

class DataIsNullException implements Exception {
  DataIsNullException();
}

class NetworkPrefixIsNull implements Exception {
  NetworkPrefixIsNull();
}

class ComputerOfflineException implements Exception {
  ComputerOfflineException();
}

class NotConnectedToSocketException implements Exception {
  NotConnectedToSocketException();
}

class ErrorParsingComputerData implements Exception {
  final String data;
  final Object error;
  ErrorParsingComputerData(this.data, this.error);
}

class TooEarlyToReturnError implements Exception {
  TooEarlyToReturnError();
}
