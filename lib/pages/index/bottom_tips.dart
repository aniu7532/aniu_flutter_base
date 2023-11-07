import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/font_style_utils.dart';

class BottomTips extends StatelessWidget {
  BottomTips({
    super.key,
    required this.checkedItem,
    this.height,
  });

  int checkedItem = 1;
  double? height = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height ?? 0),
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
      color: const Color.fromRGBO(249, 249, 249, 1),
      height: 300.h,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '使用方法：',
            textAlign: TextAlign.center,
            style: FSUtils.font_bold_28_colorFF7C8397,
          ),
          SizedBox(
            height: 13.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Assets.images.bottomTips1.image(
                    fit: BoxFit.fill,
                    height: 98.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '''扫描医护人员
  患者识别码''',
                    style: checkedItem == 1
                        ? FSUtils.font_normal_24_colorFF088AE3
                        : FSUtils.font_normal_14_colorFF7C8397,
                  ),
                ],
              ),
              Assets.images.arrowRightIcon.image(
                fit: BoxFit.fill,
                height: 54.h,
              ),
              Column(
                children: [
                  Assets.images.bottomTips2.image(
                    fit: BoxFit.fill,
                    height: 98.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '''选择本次需要确认
     的医嘱信息''',
                    style: checkedItem == 2
                        ? FSUtils.font_normal_24_colorFF088AE3
                        : FSUtils.font_normal_14_colorFF7C8397,
                  ),
                ],
              ),
              Assets.images.arrowRightIcon.image(
                fit: BoxFit.fill,
                height: 54.h,
              ),
              Column(
                children: [
                  Assets.images.bottomTips3.image(
                    fit: BoxFit.fill,
                    height: 98.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '''   患者确认
   医嘱信息！''',
                    style: checkedItem == 3
                        ? FSUtils.font_normal_24_colorFF088AE3
                        : FSUtils.font_normal_14_colorFF7C8397,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
