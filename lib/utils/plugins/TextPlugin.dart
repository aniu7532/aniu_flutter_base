import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/utils/toast_util.dart';

class TextPlugin {
  factory TextPlugin() => _instance;

  TextPlugin._internal();

  ///
  ///构建单例
  ///利用 私有构造函数、私有静态变量、factory关键字、late关键字
  static late final TextPlugin _instance = TextPlugin._internal();

  // 在 Flutter 代码中创建一个平台通道
  final platform = const MethodChannel(AppConst.chanelNameTest);

  // 注册方法，等待被原生通过invokeMethod唤起
  Future<dynamic> nativeCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getUsbQrcode':
        //获取参数
        String paramsFromNative = await methodCall.arguments;
        print('原生android传递过来的参数为------ $paramsFromNative');
        MyToast.showToast(paramsFromNative);
        return paramsFromNative;
    }
  }

  Future<void> getDataFromUsb(
      Future<dynamic> Function(MethodCall call)? handler) async {
    platform.setMethodCallHandler(handler);
  }
}
