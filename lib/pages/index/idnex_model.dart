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
      description: '',
      url: '',
      iconUrl: 'https://cdn.free-api.com/ak0t8-xbicc.webp',
    ),
    FunctionInfoBean(
      gUID: '1',
      title: '随机音乐',
      description: '随机音乐',
      url: 'https://api.uomg.com/api/rand.music',
      iconUrl: 'https://cdn.free-api.com/wyysjyy.webp',
    ),
    FunctionInfoBean(
      gUID: '2',
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
        page = FunctionAiRoute();
        break;
      case '1': //audio
        page = FunctionRandomMusicRoute();
        break;
      case '2': //video
        page = FunctionRandomVideoRoute();
        break;
    }
    appRouter.push(page);
  }
}
