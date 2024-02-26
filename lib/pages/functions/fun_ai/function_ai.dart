import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/functions/fun_ai/function_ai_model.dart';
import 'package:musico/pages/functions/fun_ai/widget/chat_bubble.dart';

/// Ai功能模块
class FunctionAiPage extends BasePage {
  FunctionAiPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams) {}

  @override
  State<FunctionAiPage> createState() => _FunctionAiPageState();
}

class _FunctionAiPageState extends BasePageState<FunctionAiPage>
    with ListMoreSearchPageStateMixin<FunctionAiPage, FunctionAiModel> {
  @override
  FunctionAiModel initModel() {
    return FunctionAiModel(requestParam: widget.requestParams);
  }

  @override
  Widget getItemWidget(item, index) {
    return ChatBubble(
      send: item['type'] == 1,
      title: item['type'] == 1 ? null : json.decode(item['msg'])['question'],
      text: item['type'] == 1 ? item['msg'] : json.decode(item['msg'])['reply'],
    );
  }

  @override
  Widget buildFooter() {
    return Container(
      color: ColorName.primaryColor,
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: model.controller,
              decoration: InputDecoration(border: InputBorder.none),
              cursorColor: ColorName.secondaryColor,
            ),
          )),
          IconButton(
            onPressed: () {
              if (ObjectUtil.isEmptyString(model.controller.text)) {
                return;
              }
              model.sendMsg(model.controller.text);
            },
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
