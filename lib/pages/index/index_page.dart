import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_utils;
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/generated/l10n.dart';
import 'package:musico/pages/index/bottom_tips.dart';
import 'package:musico/pages/index/idnex_model.dart';
import 'package:musico/pages/index/index_clock.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/text_input_formatter.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:musico/widgets/zz_simple_textfield.dart';

import '../../gen/assets.gen.dart';

///
/// 首页
///

class IndexPage extends BasePage {
  IndexPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<IndexPage> createState() => _TabSettingPageState();
}

class _TabSettingPageState extends BasePageState<IndexPage>
    with BasePageMixin<IndexPage, IndexModel> {
  @override
  IndexModel initModel() {
    return IndexModel(requestParam: widget.requestParams);
  }

  @override
  void initState() {
    super.initState();
    model
      ..doctorController = TextEditingController()
      ..patController = TextEditingController();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildAppBar() {
    return const SizedBox.shrink();
  }

  @override
  Widget buildContentWidget() {
    screen_utils.ScreenUtil.init(
      context,
      designSize: const Size(
        AppConst.pageWidth,
        AppConst.pageHeight,
      ),
      minTextAdapt: true,
    );
    return Stack(
      children: [
        Assets.images.indexBg
            .image(fit: BoxFit.fill, width: 1080.w, height: 486.h),
        Positioned(top: 66.h, right: 50.w, child: const Clock()),
        Positioned(
          left: 40.w,
          top: 40.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppTitle(),
              SizedBox(height: 60.h),
              _buildContentText(),
              SizedBox(height: 10.h),
              _buildSubContentText(),
              SizedBox(
                height: 39.h,
              ),
              _buildTipsText(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 486.h),
          height: MediaQuery.of(context).size.height.h,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      _buildScanTips(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Assets.images.arrowDownIcon
                          .image(fit: BoxFit.fill, height: 36.w),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildDoctorInfo()),
                          SizedBox(
                            width: 60.w,
                          ),
                          Expanded(child: _buildPatientInfo()),
                        ],
                      ),
                      SizedBox(
                        height: 66.h,
                      ),
                      _buildInputTypeButton(),
                    ],
                  ),
                ),
              ),
              _bottomProgress(),
            ],
          ),
        ),
        Positioned(
          right: 50.w,
          child: InkWell(
            onTap: () {
              model.setting(context);
            },
            child: Assets.images.exitIcon.image(fit: BoxFit.fill, width: 142.w),
          ),
        ),
      ],
    );
  }

  Widget _buildAppTitle() {
    return Row(
      children: [
        Visibility(
          visible: ObjectUtil.isEmpty(model.logoBase64),
          child: Assets.images.hosIcon.image(
            fit: BoxFit.fill,
            width: 108.h,
          ),
        ),
        if (ObjectUtil.isNotEmpty(model.logoBase64))
          Image.memory(
            model.logoBase64!,
            alignment: Alignment.bottomCenter,
            width: 80.w,
            height: 80.w,
            fit: BoxFit.fitWidth,
          )
        else
          SizedBox(
            width: 80.w,
            height: 80.w,
          ),
        SizedBox(
          width: 20.w,
        ),
        Text(
          S.of(context).title,
          style: FSUtils.font_bold_30_color08FFFFFF,
        )
      ],
    );
  }

  Widget _buildContentText() {
    return Text(
      'Hi，欢迎使用',
      textAlign: TextAlign.start,
      style: FSUtils.font_bold_30_colorFFFFFFFF,
    );
  }

  Widget _buildSubContentText() {
    return const Text(
      '快速执行终端',
      textAlign: TextAlign.center,
      style: FSUtils.font_bold_40_colorFF7C8397,
    );
  }

  Widget _buildTipsText() {
    return const Text(
      '请患者在医务人员的陪同下使用，请勿自行使用',
      textAlign: TextAlign.center,
      style: FSUtils.weight500_18_ffffff,
    );
  }

  Widget _buildDoctorInfo() {
    return Stack(
      children: [
        Container(
          height: 660.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(235, 247, 255, 1),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Assets.images.doctorBg.image(
                fit: BoxFit.fill,
                height: 380.h,
              ),
              SizedBox(
                height: 55.h,
              ),
              Text(
                model.doctorName,
                style: FSUtils.font_bold_50_color189DFFFF,
              ),
            ],
          ),
        ),
        Visibility(
          visible: model.isHand,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            height: 40,
            child: _buildDoctorInput(),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInfo() {
    return Stack(
      children: [
        Container(
          height: 660.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 252, 244, 228),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Assets.images.patientBg.image(
                fit: BoxFit.fill,
                height: 380.h,
              ),
              SizedBox(
                height: 55.h,
              ),
              Text(
                model.patName,
                style: FSUtils.font_bold_50_colorF49B57,
              ),
            ],
          ),
        ),
        Visibility(
          visible: model.isHand,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            height: 40,
            child: _buildPatInput(),
          ),
        ),
      ],
    );
  }

  Widget _buildInputTypeButton() {
    return model.isHand
        ? PrimaryButton.withTime(
            width: 300.w,
            height: 70.h,
            text: '确认',
            fontSize: 18,
            onPressed: () {
              model.btnSave(context);
            },
            timeOverCallback: () {
              model.setIsHand(b: false);
            },
          )
        : PrimaryButton.secondary(
            width: 300.w,
            height: 70.h,
            text: '手动输入',
            fontColor: const Color(0xFF7C8397),
            fontSize: 18,
            onPressed: () {
              model.setIsHand();
            },
          );
  }

  Widget _buildDoctorInput() {
    return ZzSimpleTextField(
      placeholderText: '请输入医护人员识别码',
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: ColorName.themeColor,
      ),
      placeholderTextStyle: FSUtils.font_normal_18_colorFFA9AFBC,
      textEditingController: model.doctorController,
      inputType: TextInputType.text,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        ZzTextInputFormatter().numberLetterOnly,
      ],
    );
  }

  Widget _buildPatInput() {
    return ZzSimpleTextField(
      placeholderText: '请输入就诊号/档案号...',
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: ColorName.patColor,
      ),
      placeholderTextStyle: FSUtils.font_normal_18_colorFFA9AFBC,
      textEditingController: model.patController,
      inputType: TextInputType.text,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        ZzTextInputFormatter().numberLetterOnly,
      ],
    );
  }

  Widget _buildScanTips() {
    return const Text(
      '请将扫码信息放置在扫码口',
      textAlign: TextAlign.center,
      style: FSUtils.font_bold_32_colorFF111111,
    );
  }

  Widget _bottomProgress() {
    return BottomTips(
      checkedItem: 1,
      height: 100.h,
    );
  }
}
