import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/pages/functions/fun_ai/function_ai.dart';

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

  final db = FirebaseFirestore.instance;

  ///发送消息
  Future<void> sendMsg(String msg) async {
    final loading = await EasyLoading.show();

    //1、发出请求
    try {
      await putMsgInBox(msg, ChatMsgType.send);

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
          final aiAnswer = success.value.data[0];

          debugPrint('success:${json.encode(aiAnswer)}');

          //2、插入数据库
          await putMsgInBox(json.encode(aiAnswer), ChatMsgType.receive);
        },
        error: (error) async {
          //2、插入数据库
          await putMsgInBox(
              error.exception.errorBean?.msg ?? '', ChatMsgType.receive);
        },
      );
    } on Exception catch (e) {
      await EasyLoading.dismiss();
      debugPrint('e:${e.toString()}');
    } finally {
      //3、刷新列表
      await initData();
      debugPrint('list.length:${list.length - 1}');
      scrollController
          ?.jumpTo((scrollController?.position.maxScrollExtent ?? 0));
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
  Future<void> putMsgInBox(String msg, ChatMsgType type) async {
    debugPrint('putMsgInBoxStart: type:$type|msg:$msg');

    final box = await getChatBox();

    final msgMap = {'type': type.index, 'msg': msg};

    await box.add(msgMap);

    //存到fb
    await db.collection('AiChatList').add(msgMap).then(
          (DocumentReference doc) =>
              print('aiAnswers added with ID: ${doc.id}'),
        );
  }

  ///获取box实例
  Future<Box> getChatBox() async {
    return Hive.openBox('AiChatList');
  }
}
