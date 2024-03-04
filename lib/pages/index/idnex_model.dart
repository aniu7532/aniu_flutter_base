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
      description: '随机壁纸、美女图片、宠物图片',
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
  ];

  @override
  initData() async {
    return super.initData();
  }

  ///页面跳转
  void gotoPage(FunctionInfoBean functionInfoBean) {
    PageRouteInfo page = FunctionAiRoute();

    switch (functionInfoBean.gUID) {
      case '0': //ai
        page = FunctionAiRoute(requestParams: const {'title': 'Ai'});
        break;
      case '1': //picture
        page = FunctionRandomPictureRoute(
            requestParams: const {'title': 'Picture'});
        break;
      case '2': //audio
        page =
            FunctionRandomMusicRoute(requestParams: const {'title': 'Music'});
        break;
      case '3': //video
        page =
            FunctionRandomVideoRoute(requestParams: const {'title': 'Video'});
        break;
    }
    appRouter.push(page);
  }
}
