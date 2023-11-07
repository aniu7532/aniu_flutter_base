import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME framework
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // Show debugPrint
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart'; // Device info
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart'; // Dio Inspector
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI kitsCode
import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/http/dio_util.dart';
import 'package:musico/http/http_override.dart';
import 'package:musico/utils/app_crash_util.dart';
import 'package:musico/utils/store_util.dart';
import 'package:musico/utils/strings.dart';

void realRunApp(bool needUme) {
  AppCrashChain.capture(
    () {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light, // 状态栏字体颜色（白色）
          statusBarColor: Colors.transparent, // 状态栏背景色
        ),
      );
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );

      HttpOverrides.global = MyHttpOverrides();
      if (needUme) {
        runApp(const UMEWidget(child: MyApp()));
      } else {
        runApp(
          const MyApp(),
        );
      }
    },
  );
}

Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();

  final openUmeStr = await storeUtil.fetchValue(AppConst.keyUme);

  final openUmeBool = openUmeStr?.stringToBool();

  ///调用一下DioUtil 来初始化dio
  DioUtil.instance.initDio();
  if (openUmeBool ?? false) {
    //关闭ume
    await storeUtil.saveValue(AppConst.keyUme, 'false');

    ///打开Ume的情况

    PluginManager.instance // Register plugin kits
      ..register(const WidgetInfoInspector())
      ..register(const WidgetDetailInspector())
      ..register(const ColorSucker())
      ..register(AlignRuler())
      ..register(const ColorPicker()) // New feature
      ..register(const TouchIndicator())
      ..register(CpuInfoPage())
      ..register(const DeviceInfoPanel())
      ..register(Console())
      ..register(DioInspector(dio: dio));
    realRunApp(true);
  } else {
    ///关闭Ume的情况
    realRunApp(false);
  }
}
