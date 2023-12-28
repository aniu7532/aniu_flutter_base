import 'package:flutter/cupertino.dart';

///
/// app全局常量
///
class AppConst {
  ///
  /// 设备密码
  ///
  static const String devicePassword = 'hwkj666666';

  ///
  /// 插件通道名称
  ///
  static const String chanelNameTest = 'CHANEL_NAME_USB_SCAN';

  ///编辑器Item 高度，左右缩进距离
  static const double pageHeight = 1920; //高度
  static const double pageWidth = 1080; //高度

  static const double EDITOR_ITEM_HEIGHT = 44; //高度
  static const double editorItemIndent = 20; //左右缩进
  static const double EDITOR_ITEM_TOP_BOTTOM = 16; //上下距离

  /// 时间显示的分隔符
  static const String DATE_MARK = '-';

  static const kInputTextFieldPadding = EdgeInsets.symmetric(horizontal: 4);

  static const maxCountValue = 9999999;

  static const billSelectGoodsMaxCount = 500;

  ///-------   api-path  start------------- ///

  ///获取Logo
  static const getHospitalLogoInfo = 'api/Terminal/GetHospitalLogoInfo';

  ///验证用户信息
  static const validateUserPassword = 'api/User/ValidateUserPassword';

  ///获取园区
  static const getHospitalInfo = 'api/Terminal/GetHospitalInfo';

  ///获取方案
  static const getAppFastTerminalConfigList =
      'api/Terminal/GetAppFastTerminalConfigList';

  ///获取用户信息
  static const loginFastTerminal = 'api/Terminal/LoginFastTerminal';

  ///获取Fts地址
  static const getFtsHost = 'api/Terminal/GetFtsHost';

  ///获取用户可选治疗区
  static const getAreas = 'api/Terminal/GetAreas';

  ///获取用户待治疗项目
  static const getTreatingByMo = 'api/Terminal/GetTreatingsByMo';

  ///获取待治疗模型
  static const String getExecuteModels = 'api/Treat/GetExecuteModels';

  ///治疗执行
  static const String saveExecutes = 'api/Treat/SaveExecutes';

  ///治疗确认
  static const String treatConfirm = 'api/Treat/Confirm';

  ///文件上传request
  static const String largeUploadInfo = 'api/FTS/LargeUploadInfo';

  ///文件上传upload
  static const String uploadBlock = 'api/FTS/UploadBlock';

  ///文件上传finish
  static const String largeUploadFinished = 'api/FTS/LargeUploadFinished';

  ///文件上传成功后 保存文件到业务
  static const String saveFiles = 'api/Treat/SaveFiles';

  ///-------   api-path   end------------- ///

  ///-------   加密本地存储key  start------------- ///
  static const keyUme = 'key_ume';
  static const keyConfig = 'key_plan_config';

  ///-------   加密本地存储key  end------------- ///

  ///-------   模版中的一些配置  start------------- ///

  ///-------   加密本地存储key  end------------- ///
}
