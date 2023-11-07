import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musico/pages/home/setting/scan/scan_page.dart';
import 'package:musico/pages/home/setting/tab_setting_page.dart';
import 'package:musico/pages/index/index_page.dart';
import 'package:musico/pages/splash_page.dart';
import 'package:musico/utils/app_crash_util.dart';

class AppRouteObserver extends AutoRouterObserver {
  Future<void> _sendScreenView(Route? route, Route? previousRoute) async {
    var previousRouteName = '';
    var name = '';
    if (previousRoute != null && previousRoute is PageRoute) {
      previousRouteName = previousRoute.settings.name ?? '';
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendScreenView(route, previousRoute);
    if (kDebugMode) debugLog('路由跳转: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _sendScreenView(previousRoute, route);
    if (kDebugMode) debugLog('路由返回: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendScreenView(newRoute, oldRoute);
    if (kDebugMode) debugLog('路由替换: ${newRoute?.settings.name}');
  }
}

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  durationInMilliseconds: 200,
  transitionsBuilder: TransitionsBuilders.slideLeft,
  routes: <AutoRoute>[
    //启动页
    AutoRoute(initial: true, page: SplashPage),

    //设置页面
    AutoRoute(path: 'tab_setting_page', page: TabSettingPage),

    //首页
    AutoRoute(path: 'index_page', page: IndexPage),

    //扫码页面
    AutoRoute(path: 'scan_page', page: ScanPage),
  ],
)
class $AppRouter {}
