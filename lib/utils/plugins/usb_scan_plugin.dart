import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musico/const/app_const.dart';

class UsbScantPlugin {
  factory UsbScantPlugin() => _instance;

  UsbScantPlugin._internal();

  ///
  ///构建单例
  ///利用 私有构造函数、私有静态变量、factory关键字、late关键字
  static late final UsbScantPlugin _instance = UsbScantPlugin._internal();

  // 在 Flutter 代码中创建一个平台通道
  static const platform = MethodChannel(AppConst.chanelNameTest);

  ///
  /// 初始化usb服务
  ///
  static Future<void> initUsbScanService() async {
    // 在 Flutter 代码中调用 Android 方法
    try {
      final result = await platform.invokeMethod(
          'initUsbScan', {'param1': 'value1', 'param2': 'value2'});
      debugPrint('在 Flutter 代码中调用 Android 方法 ------${result}');
      //注册方法
      platform.setMethodCallHandler(nativeCallHandler);
      // 处理返回结果
    } on PlatformException catch (e) {
      // 处理异常
      debugPrint('初始化usb服务异常: ${e.message}');
    }
  }

  // 注册方法，等待被原生通过invokeMethod唤起
  static Future<dynamic> nativeCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getCode':
        debugPrint('原生android传递过来的参数为------${methodCall.arguments}');
        //获取参数
        String paramsFromNative = await methodCall.arguments['invokeKey'];
        print('原生android传递过来的参数为------ $paramsFromNative');
        return '你好，这个是从flutter回传给NA的数据';
      case 'usbStateChange':
        debugPrint('原生android传递过来的参数为------${methodCall.arguments}');
        //获取参数
        String paramsFromNative = await methodCall.arguments['invokeKey'];
        print('原生android传递过来的参数为------ $paramsFromNative');
        return '你好，这个是从flutter回传给NA的数据';
    }
  }
}
