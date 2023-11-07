// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/foundation.dart' as _i7;
import 'package:flutter/material.dart' as _i6;

import '../pages/home/setting/scan/scan_page.dart' as _i4;
import '../pages/home/setting/tab_setting_page.dart' as _i2;
import '../pages/index/index_page.dart' as _i3;
import '../pages/splash_page.dart' as _i1;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
        transitionsBuilder: _i5.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabSettingRoute.name: (routeData) {
      final args = routeData.argsAs<TabSettingRouteArgs>(
          orElse: () => const TabSettingRouteArgs());
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.TabSettingPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i5.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    IndexRoute.name: (routeData) {
      final args = routeData.argsAs<IndexRouteArgs>(
          orElse: () => const IndexRouteArgs());
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.IndexPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i5.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ScanRoute.name: (routeData) {
      final args =
          routeData.argsAs<ScanRouteArgs>(orElse: () => const ScanRouteArgs());
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.ScanPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i5.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i5.RouteConfig(
          TabSettingRoute.name,
          path: 'tab_setting_page',
        ),
        _i5.RouteConfig(
          IndexRoute.name,
          path: 'index_page',
        ),
        _i5.RouteConfig(
          ScanRoute.name,
          path: 'scan_page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.TabSettingPage]
class TabSettingRoute extends _i5.PageRouteInfo<TabSettingRouteArgs> {
  TabSettingRoute({
    _i7.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabSettingRoute.name,
          path: 'tab_setting_page',
          args: TabSettingRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabSettingRoute';
}

class TabSettingRouteArgs {
  const TabSettingRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i7.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSettingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i3.IndexPage]
class IndexRoute extends _i5.PageRouteInfo<IndexRouteArgs> {
  IndexRoute({
    _i7.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          IndexRoute.name,
          path: 'index_page',
          args: IndexRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'IndexRoute';
}

class IndexRouteArgs {
  const IndexRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i7.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'IndexRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i4.ScanPage]
class ScanRoute extends _i5.PageRouteInfo<ScanRouteArgs> {
  ScanRoute({
    _i7.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          ScanRoute.name,
          path: 'scan_page',
          args: ScanRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'ScanRoute';
}

class ScanRouteArgs {
  const ScanRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i7.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ScanRouteArgs{key: $key, requestParams: $requestParams}';
  }
}
