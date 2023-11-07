import 'dart:convert';
import 'dart:typed_data';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/http/api_error_helper.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/pages/index/bean/user_info_bean.dart';
import 'package:musico/utils/dialog_utils.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/plugins/TextPlugin.dart';
import 'package:musico/utils/store_util.dart';
import 'package:musico/utils/toast_util.dart';

import 'package:musico/widgets/common/loading_button.dart';
import 'package:musico/widgets/zz_simple_textfield.dart';

class IndexModel extends ViewStateModel {
  IndexModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  late TextEditingController doctorController;
  late TextEditingController patController;

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  ///是否手动输入模式 true 手动模式/ false 刷卡模式
  bool _hand = false;

  bool get isHand => _hand;

  /// 治疗师信息
  UserInfoBean? _doctorInfoBean;

  String get doctorName => _doctorInfoBean?.name ?? '治疗师';

  /// 患者信息
  UserInfoBean? _patInfoBean;

  String get patName => _patInfoBean?.name ?? '患者';

  Uint8List? _logoBase64;

  Uint8List? get logoBase64 => _logoBase64;

  void setIsHand({bool b = true}) {
    _hand = b;
    notifyListeners();
  }

  @override
  initData() async {
    getHosLogo();
    usbScan();
    return super.initData();
  }

  Future<void> usbScan() async {
    await TextPlugin().getDataFromUsb((MethodCall methodCall) async {
      if (appRouter.currentPath == 'index_page') {
        switch (methodCall.method) {
          case 'getUsbQrcode':
            //获取二维码
            String code = await methodCall.arguments;
            code = code.substring(0, code.length - 2);
            print('code:code:$code');
            final userInfo = await getUserInfo(code: code);
            if (userInfo?.validationType == 1) {
              _doctorInfoBean = userInfo;
            } else {
              _patInfoBean = userInfo;
            }

            ///判断信息是否完整
            if (ObjectUtil.isEmpty(_doctorInfoBean) ||
                ObjectUtil.isEmpty(_patInfoBean)) {
              print(_doctorInfoBean?.toJson());
              print(_patInfoBean?.toJson());
            } else {
              ///最后跳转 治疗项目选择页面

              _doctorInfoBean = null;
              _patInfoBean = null;
              notifyListeners();
            }
            notifyListeners();
            return;
        }
      }
    });
  }

  ///
  /// 获取医院logo
  ///
  Future<void> getHosLogo() async {
    final apiResponse = await get(
      AppConst.getHospitalLogoInfo,
    );
    final result = apiResponse.when(
      success: (data) => data,
      error: (error) {
        ApiErrorHelper.toastApiErrorMessage(error);
        return error;
      },
    );
    if (result is AppException || ObjectUtil.isEmpty(result)) {
    } else {
      if (!ObjectUtil.isEmpty(result.extend)) {
        _logoBase64 = Base64Decoder().convert(result.extend['Logo']);
        notifyListeners();
      }
    }
  }

  ///
  /// 获取信息
  /// validationType 0不确定类型，1治疗师 2患者
  ///
  Future<UserInfoBean?> getUserInfo({
    required String code,
    String validationType = '0',
  }) async {
    final apiResponse = await post(
      AppConst.loginFastTerminal,
      {},
      params: {
        'keyword': code,
        'validationType': validationType, //validationType 0不确定类型，1治疗师 2患者
      },
    );
    final result = apiResponse.when(
      success: (data) => data,
      error: (error) {
        ApiErrorHelper.toastApiErrorMessage(error);
        return error;
      },
    );
    if (result is AppException || ObjectUtil.isEmpty(result)) {
      return null;
    } else {
      if (!ObjectUtil.isEmpty(result.extend)) {
        if (validationType == '1') {
          doctorController.text = '';
        } else if (validationType == '2') {
          patController.text = '';
        }

        return UserInfoBean.fromJson(result.extend);
      }
    }
  }

  ///
  /// 手动输入模式下，点击保存按钮
  ///
  void btnSave(BuildContext context) async {
    if (doctorController.text.isEmpty && patController.text.isEmpty) {
      MyToast.showToast('请在输入框中输入患者或治疗师信息');
      return;
    }

    showZzLoadingDialog(
      context,
    );

    ///获取医生信息
    if (doctorController.text.isNotEmpty) {
      _doctorInfoBean =
          await getUserInfo(code: doctorController.text, validationType: '1');
    }

    ///获取患者信息
    if (patController.text.isNotEmpty) {
      _patInfoBean =
          await getUserInfo(code: patController.text, validationType: '2');
    }

    Navigator.pop(context);
    notifyListeners();

    ///先切换回刷卡
    setIsHand(b: false);

    ///判断信息是否完整
    if (ObjectUtil.isEmpty(_doctorInfoBean) ||
        ObjectUtil.isEmpty(_patInfoBean)) {
      print(_doctorInfoBean?.toJson());
      print(_patInfoBean?.toJson());
    } else {}
  }

  void setting(BuildContext context) {
    final _textController = TextEditingController();

    showCommonDialog(
      context,
      width: 550,
      maxHeight: 600,
      title: '退出登录',
      cancelText: '取消',
      confirmText: '退出',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 42.h,
          ),
          Assets.images.passwordIcon.image(fit: BoxFit.fill, width: 150.w),
          SizedBox(
            height: 12.h,
          ),
          const Text(
            '密码',
            style: FSUtils.font_bold_24_colorFF111111,
          ),
          Container(
            height: 42.h,
            margin: const EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            child: ZzSimpleTextField(
              textEditingController: _textController,
              obscureText: true,
              bgColor: ColorName.bgColorFFF9F9F9,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
        ],
      ),
      showTimerButton: true,
      singleBtn: true,
      twoBtn: true,
      onVerifyBeforeConfirm: () async {
        if (ObjectUtil.isEmpty(_textController.text)) {
          MyToast.showToast('请输入');
          return false;
        } else {
          if (_textController.text == AppConst.devicePassword) {
            ///退出登录 清楚缓存配置数据
            await storeUtil.removeValue(
              AppConst.keyConfig,
            );

            return true;
          } else {
            MyToast.showToast('密码错误');
            return false;
          }
        }
      },
      onConfirm: () {},
    );
  }

  ///
  /// 验证密码
  ///
  Future<void> validateUserPassword({String? password}) async {
    final apiResponse = await post(
      AppConst.validateUserPassword,
      {},
      params: {
        'userId': 'admin',
        'password': password,
      },
    );
    final result = apiResponse.when(
      success: (data) => data,
      error: (error) {
        ApiErrorHelper.toastApiErrorMessage(error);
        return error;
      },
    );
    if (result is AppException || ObjectUtil.isEmpty(result)) {
    } else {
      if (!ObjectUtil.isEmpty(result.extend)) {
        // appRouter.replace(ModifyIpPortRoute());
      }
    }
  }
}
