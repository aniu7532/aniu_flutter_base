import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

mixin _Protocol {}

class SettingModel extends BaseListMoreModel<ImportItemBean> with _Protocol {
  SettingModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    enablePullUp = false;
    enablePullDown = false;
  }

  @override
  Future<bool> initData() async {
    setBusy(busy: true);
    return super.initData();
  }

  @override
  Future<List<ImportItemBean>> loadRefreshListData({int? pageNum}) async {
    return [
      /* ImportItemBean(
        title: 'Language',
        description: 'Language',
        icon: Assets.images.setting.iconLanguage,
      ),*/
      ImportItemBean(
        haveCamera: false,
        title: 'Contact Us',
        description: 'Contact Us',
      ),
      /*  ImportItemBean(
        title: 'Score',
        description: 'Score',
        icon: Assets.images.setting.iconScore,
      ),*/
      ImportItemBean(
        haveCamera: false,
        title: 'Privacy Policy',
        description: 'Privacy Policy',
      ),
      ImportItemBean(
        haveCamera: true,
        title: 'Term of Servers',
        description: 'Term of Servers',
      ),
    ];
  }

  Future<void> _openUrl() async {
    if (await canLaunch('mailto:support@freemusicplayer.net')) {
      await launch('mailto:support@freemusicplayer.net');
    } else {
      MyToast.showDialog('support@freemusicplayer.net');
    }
  }

  void _openScan() {
    appRouter.push(ScanRoute());
  }

  ///绑定IP和端口
  void _bindWebServices() {}

  ///通过指定ip+端口号 获取治疗区列表
  void getTreatAreaList() {
    apiModel.post('path', {'gid': ''});
  }

  ///点击
  void click(int pos, BuildContext context) {
    switch (pos) {
      case 0:
        _openUrl();
        break;
      case 1:
        _openScan();
        break;
      case 2:
        break;
    }
  }
}

class ImportItemBean {
  ImportItemBean({
    required this.haveCamera,
    required this.title,
    required this.description,
    this.pathIcon,
  });
  final bool haveCamera;
  final String title;
  final String description;
  final AssetGenImage? pathIcon;
}
