import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzerp/app/myapp.dart';
import 'package:zzerp/app/zz_icon.dart';
import 'package:zzerp/base/scan/scan_base_widget.dart';
import 'package:zzerp/const/app_data.dart';
import 'package:zzerp/gen/colors.gen.dart';
import 'package:zzerp/pages/baseinfo/goods/bean/goods_add_bean.dart';
import 'package:zzerp/utils/font_style_utils.dart';
import 'package:zzerp/utils/strings.dart';
import 'package:zzerp/utils/text_number_limit_formatter.dart';
import 'package:zzerp/utils/toast_util.dart';
import 'package:zzerp/widgets/zz_show_model_bottom_sheet.dart';

///
///Create by 张凡 on 2022-11-9 16:30
///
///Description: 单位多条码录入
///
Future showBarcodeInput(
  List<UnitBarCodes>? unitBarCodes,
  Function(List<UnitBarCodes>) callBack,
) {
  FocusScope.of(AppData.rootContext).unfocus();
  return zzShowModalBottomSheet(
    isScrollControlled: true,
    context: AppData.rootContext,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: UnitPickWidget(
          unitBarCodes: unitBarCodes,
          callBack: callBack,
        ),
      );
    },
  );
}

class UnitPickWidget extends StatefulWidget {
  const UnitPickWidget({
    Key? key,
    this.unitBarCodes,
    required this.callBack,
  }) : super(key: key);

  final List<UnitBarCodes>? unitBarCodes;
  final Function(List<UnitBarCodes>) callBack;

  @override
  State<UnitPickWidget> createState() => _UnitPickWidgetState();
}

class _UnitPickWidgetState extends State<UnitPickWidget> {
  List<UnitBarCodes> list = [];
  List<FocusNode> fnList = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    if (ObjectUtil.isNotEmpty(widget.unitBarCodes)) {
      list = widget.unitBarCodes!.map((e) => UnitBarCodes.copy(e)).toList();
      fnList = list.map((e) => FocusNode()).toList();
    }
  }

  ///适配的pda扫码后处理
  void onScanCode(code) {
    if (ObjectUtil.isNotEmpty(code)) {
      for (var i = 0; i < fnList.length; i++) {
        if (fnList[i].hasFocus) {
          list[i].barCode = code;
          setState(() {});
        }
      }
      final emptyBarCodeList =
          list.where((element) => ObjectUtil.isEmpty(element.barCode)).toList();
      if (emptyBarCodeList.isEmpty) {
        onAddItem();
      } else {
        final index = list.indexOf(emptyBarCodeList.first);
        fnList[index].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScanBaseWidget(
          onScanResultCallback: onScanCode,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: appRouter.pop,
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: ColorName.tradeColorF9FAFB,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: appRouter.pop,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Text(
                        '取消',
                        style: FSUtils.font_medium_18_colorFF666F83,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '多条码录入',
                    style: FSUtils.font_medium_18_colorFF666F83,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (list.length > 1) {
                        //检查条码是否重复
                        var repeatCode = '';
                        for (var i = 0; i < list.length; i++) {
                          if (ObjectUtil.isNotEmpty(list[i].barCode)) {
                            final fList = List.of(list)..removeAt(i);
                            for (final code in fList) {
                              if (list[i] == code) {
                                repeatCode = code.barCode ?? '';
                              }
                            }
                          }
                        }
                        if (ObjectUtil.isNotEmpty(repeatCode)) {
                          MyToast.showToast('条码$repeatCode重复');
                          return;
                        }
                      }
                      list.removeWhere((e) => ObjectUtil.isEmpty(e.barCode));
                      if (ObjectUtil.isEmpty(list)) {
                        list.add(UnitBarCodes.empty());
                      }
                      widget.callBack(list);
                      appRouter.pop();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Text(
                        '确定',
                        style: FSUtils.font_medium_18_colorTheme,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: const Color(0xFF599EF8).withOpacity(0.08),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        ZzIcons.icon_guanyu,
                        size: 14,
                        color: ColorName.themeColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Text(
                      '各列表页面默认展示第一个条码，其他扩展条码不展示，但都支持搜索，多条码最多支持20个。'.noWideSpace,
                      style: FSUtils.font_normal_14_themeColor,
                    )),
                  ],
                ),
              ),

              //条码录入
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 3 / 10,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
              // 添加条码
              Visibility(
                visible: list.length < 20,
                child: InkWell(
                  onTap: onAddItem,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            ZzIcons.icon_tianjia1,
                            size: 14,
                            color: ColorName.themeColor,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '添加条码',
                          style: FSUtils.font_normal_16_colorFF2B83FA,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  ///新增一个条码输入框
  void onAddItem() {
    if (list.length == 20) {
      return;
    }
    setState(() {
      list.add(UnitBarCodes.empty());
      fnList.add(FocusNode());
    });
    //滚动到底部
    Timer(
      const Duration(milliseconds: 500),
      () {
        controller.jumpTo(controller.position.maxScrollExtent);
        fnList[fnList.length - 1].requestFocus();
      },
    );
  }

  Widget _buildItem(int index) {
    final bean = list[index];
    final _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: bean.barCode ?? '',
        selection: TextSelection(
          baseOffset: (bean.barCode ?? '').length,
          extentOffset: (bean.barCode ?? '').length,
        ),
      ),
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                list.removeAt(index);
                fnList.removeAt(index);
              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: /*list.length == 1 ? 3 :*/ 20, vertical: 20),
              child: Icon(
                ZzIcons.icon_shanchu1,
                size: 16,
                color: /*list.length == 1
                    ? Colors.white
                    : */
                    ColorName.deleteIconColor,
              ),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              focusNode: fnList[index],
              inputFormatters: [
                SpecialLimitFormatter([';', '|', '；']), //不允许录入特殊字符
                LengthLimitingTextInputFormatter(30), //最大30个字符
              ],
              style: const TextStyle(color: ColorName.textColor111a34),
              cursorColor: ColorName.themeColor,
              cursorRadius: const Radius.circular(3),
              cursorHeight: 22,
              showCursor: true,
              placeholder: '请输入条码',
              placeholderStyle: FSUtils.font_normal_14_colorFFC5CAD5,
              suffix: Row(
                children: [
                  Visibility(
                    visible: ObjectUtil.isNotEmpty(bean.barCode),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          bean.barCode = '';
                        });
                        fnList[index].requestFocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 12, 0, 12),
                        child: Icon(
                          Icons.cancel_rounded,
                          size: 16,
                          color: ColorName.textColor858b9c,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        bean.barCode = '';
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Icon(
                        ZzIcons.icon_saotiaoma,
                        size: 12,
                        color: ColorName.textColor858b9c, // Color(0xFF2B83FA),
                      ),
                    ),
                  ),
                ],
              ),
              onEditingComplete: () {},
              onChanged: (code) {
                bean.barCode = code;
                if (code == '' || code.length == 1) {
                  setState(() {});
                }
              },
              onSubmitted: (v) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
