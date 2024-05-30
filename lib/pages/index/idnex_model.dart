import 'package:auto_route/auto_route.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/pages/index/bean/tab_info_bean.dart';
import 'package:musico/router/router.gr.dart';

class IndexModel extends ViewStateModel {
  IndexModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  ///功能items
  List<FunctionInfoBean> functionData = [
    FunctionInfoBean(
      gUID: '0',
      title: 'Ai',
      description: '免费ai聊天',
      url: '',
      iconUrl: 'https://cdn.free-api.com/ak0t8-xbicc.webp',
    ),
    FunctionInfoBean(
      gUID: '1',
      title: '随机图片',
      description: '随机壁纸、天文图片、宠物图片',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl: 'https://cdn.free-api.com/a2541-851n9.webp',
    ),
    FunctionInfoBean(
      gUID: '2',
      title: '随机音乐',
      description: '随机播放网易云音乐热榜歌曲',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl: 'https://cdn.free-api.com/wyysjyy.webp',
    ),
    FunctionInfoBean(
      gUID: '3',
      title: '随机视频',
      description: '热门视频榜及搞笑、体育、汽车、美食达人视频榜单',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl: 'https://cdn.free-api.com/a1cyv-cggat.webp',
    ),
    FunctionInfoBean(
      gUID: '4',
      title: 'Ble',
      description: 'Ble things',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl:
          'https://bkimg.cdn.bcebos.com/pic/09fa513d269759ee5be897d8b9fb43166d22df6d?x-bce-process=image/resize,m_lfit,w_536,limit_1/quality,Q_70',
    ),
    FunctionInfoBean(
      gUID: '5',
      title: 'Test Hwkj',
      description: 'scan qr code',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl: 'https://cdn.free-api.com/a1cyv-cggat.webp',
    ),
  ];

  List<FunctionInfoBean> get mapList => functionData
      .where(
        (element) =>
            ((element.title?.toLowerCase())
                    ?.contains(searchWord.toLowerCase()) ??
                false) ||
            ((element.description?.toLowerCase())
                    ?.contains(searchWord.toLowerCase()) ??
                false),
      )
      .toList();

  @override
  initData() async {
    return super.initData();
  }

  ///页面跳转
  void gotoPage(FunctionInfoBean functionInfoBean) {
    PageRouteInfo page = FunctionAiRoute();

    switch (functionInfoBean.gUID) {
      case '0': //ai
        page = FunctionAiRoute(
          requestParams: {'title': 'Ai', 'guid': functionInfoBean.gUID ?? ''},
        );
        break;
      case '1': //picture
        page = FunctionRandomPictureRoute(
          requestParams: {
            'title': 'Picture',
            'guid': functionInfoBean.gUID ?? ''
          },
        );
        break;
      case '2': //audio
        page = FunctionRandomMusicRoute(
          requestParams: {
            'title': 'Music',
            'guid': functionInfoBean.gUID ?? ''
          },
        );
        break;
      case '3': //video
        page = FunctionRandomVideoRoute(
          requestParams: {
            'title': 'Video',
            'guid': functionInfoBean.gUID ?? ''
          },
        );
        break;
      case '4': //ble
        page = FunctionBleRoute(
          requestParams: {'title': 'Ble', 'guid': functionInfoBean.gUID ?? ''},
        );
        break;
      case '5': //hwkj
        page = FunctionTestHwkjRoute(
          requestParams: {
            'title': 'Test Hwkj',
            'guid': functionInfoBean.gUID ?? ''
          },
        );
        break;
    }
    appRouter.push(page);
  }

  String searchWord = '';

  ///搜索 功能模块
  void searching(String value) {
    searchWord = value;
    notifyListeners();
  }
}
