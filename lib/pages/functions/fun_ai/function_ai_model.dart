import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/http/app_exception.dart';

mixin _Protocol {}

/// palylist选择 model
class FunctionAiModel extends BaseListMoreModel<dynamic> with _Protocol {
  FunctionAiModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    scrollController = ScrollController();
  }
  TextEditingController controller = TextEditingController();

  @override
  Future<bool> initData() async {
    setBusy(busy: true);
    return super.initData();
  }

  @override
  Future<List<dynamic>> loadRefreshListData({int? pageNum}) async {
    return getMsgFromBox();
  }

  ///发送消息
  Future<void> sendMsg(String msg) async {
    final loading = await EasyLoading.show();

    await putMsgInBox(msg, 1);

    //1、发出请求
    try {
      final apiResponse = await get(
        'https://api.a20safe.com/api.php',
        params: {
          'api': 51,
          'key': 'eac190d8b34c0e57443b77b44deed248',
          'text': msg,
        },
      );

      await apiResponse.map(
        success: (success) async {
          debugPrint('success:${json.encode(success.value.data[0])}');

          //2、插入数据库
          await putMsgInBox(json.encode(success.value.data[0]), 2);
        },
        error: (error) async {
          //2、插入数据库
          await putMsgInBox(error.exception.errorBean?.msg ?? '', 2);
        },
      );
    } on Exception catch (e) {
      debugPrint('e:${e.toString()}');
    } finally {
      //3、刷新列表
      await initData();
      debugPrint('list.length:${list.length - 1}');
      scrollController
          ?.jumpTo((scrollController?.position.maxScrollExtent ?? 0) + 150);
      controller.clear();
      await EasyLoading.dismiss();
    }
  }

  ///从box获取信息
  Future<List<dynamic>> getMsgFromBox() async {
    final box = await getChatBox();

    final rst = <dynamic>[];

    for (var i = 0; i < box.values.length; i++) {
      rst.add(box.getAt(i));
    }

    debugPrint('getMsgFromBox:${json.encode(rst)}');

    if (ObjectUtil.isEmptyList(rst)) {
      return [];
    }
    return rst;
  }

  ///向box存信息
  Future<void> putMsgInBox(String msg, int type) async {
    debugPrint('putMsgInBoxStart: type:$type|msg:$msg');

    final box = await getChatBox();

    await box.add({'type': type, 'msg': msg});
  }

  ///获取box实例
  Future<Box> getChatBox() async {
    return Hive.openBox('AiChatList');

    /*  await Hive.openBox('AiChatList');
    
    // Create a box collection
    final collection = await BoxCollection.open(
      'AiChatList', // Name of your database
      {'chat'}, // Names of your boxes
      path: AppData
          .hiveDirectoryPath, // Path where to store your boxes (Only used in Flutter / Dart IO)
      key: HiveAesCipher([
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
      ]), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
    );

    return collection.openBox<Map>('chat');*/
  }
}
