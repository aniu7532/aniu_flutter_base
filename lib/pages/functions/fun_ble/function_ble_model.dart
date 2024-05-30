import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:musico/base/view_state_model.dart';

///  model
class FunctionBleModel extends ViewStateModel {
  FunctionBleModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  List<ScanResult> get scanResults => _scanResults;
  List<BluetoothDevice> get systemDevices => _systemDevices;
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  Future<void> initData() async {
    return super.initData();
  }

  @override
  Future? loadData() async {
    await openBluetooth();
  }

  Future<void> openBluetooth() async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    scanDevices();
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
      debugPrint('bluetooth not supported by this device');
      return;
    }

    // handle bluetooth on & off
    // note: for iOS the initial state is typically BluetoothAdapterState.unknown
    // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
    final subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      debugPrint('bluetooth state is : $state');
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
        scanDevices();
      } else {
        // show an error to the user, etc
      }
    });

    // turn on bluetooth ourself if we can
    // for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // cancel to prevent duplicate listeners
    await subscription.cancel();
  }

  Future<void> scanDevices() async {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    }, onError: (e) {
      debugPrint('bluetooth found devices : ${json.encode(e)}');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      debugPrint('bluetooth _isScanning : $state');
    });

    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      debugPrint('bluetooth System Devices Error: ${json.encode(e)}');
    }
    try {
      await FlutterBluePlus.startScan(
          androidUsesFineLocation: true, timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('bluetooth startScan Error: ${json.encode(e)}');
    }
  }

  //处理扫描结果
  void _handlerScanResult(ScanResult result) {
// 获取manufacturerData中的数据
    final manufacturerData = result.advertisementData.manufacturerData;

// 假设设备名称存储在manufacturerData的76键对应的值中
    List<int>? deviceNameData = manufacturerData[76];

// 假设设备名称是UTF-8编码的字符串
    String deviceName = String.fromCharCodes(deviceNameData ?? []);

// 打印设备名称
    print('设备名称：$deviceName');
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connect().then((value) async {
      debugPrint('bluetooth connected : }');
    });
  }

  void onOpen(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        print(
            'onConnectPressed  Service: ${service.uuid}, Characteristic: ${json.encode(characteristic)}');
      }
    }
  }
}
