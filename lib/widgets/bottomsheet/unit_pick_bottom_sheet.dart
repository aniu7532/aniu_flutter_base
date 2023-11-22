import 'package:flutter/material.dart';
import 'package:zzerp/app/myapp.dart';
import 'package:zzerp/const/app_data.dart';
import 'package:zzerp/gen/colors.gen.dart';
import 'package:zzerp/utils/divider_urils.dart';
import 'package:zzerp/utils/font_style_utils.dart';
import 'package:zzerp/widgets/zz_show_model_bottom_sheet.dart';

///
///Create by 张凡 on 2022/8/10 13:39
///
///Description: 选择默认销售单位
///
void showUnitPick(
  List<String> unitList,
  Function(int) onCallback,
) {
  FocusScope.of(AppData.rootContext).unfocus();
  zzShowModalBottomSheet(
    context: AppData.rootContext,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return UnitPickWidget(
        unitList: unitList,
        onCallback: onCallback,
      );
    },
  );
}

class UnitPickWidget extends StatefulWidget {
  const UnitPickWidget({
    Key? key,
    required this.unitList,
    required this.onCallback,
  }) : super(key: key);

  final List<String> unitList;
  final Function(int) onCallback;

  @override
  State<UnitPickWidget> createState() => _UnitPickWidgetState();
}

class _UnitPickWidgetState extends State<UnitPickWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  '选择默认销售单位',
                  style: FSUtils.font_medium_18_colorFF666F83,
                ),
              ),
              ...List.generate(
                widget.unitList.length,
                (index) => _buildItem(widget.unitList[index], index, () {
                  widget.onCallback(index);
                }),
              ),
              Container(
                width: double.infinity,
                height: 10,
                color: Colors.grey[200],
              ),
              // 取消按钮
              InkWell(
                onTap: appRouter.pop,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorName.normalTxtColor,
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

  Widget _buildItem(String name, int index, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        appRouter.pop();
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          onTap();
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              alignment: Alignment.center,
              child: Text(
                name,
                style: FSUtils.font_normal_16_colorFF41485D,
              ),
            ),
            if (widget.unitList.length - 1 != index) dividerList1,
          ],
        ),
      ),
    );
  }
}
