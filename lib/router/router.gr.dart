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
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/foundation.dart' as _i16;
import 'package:flutter/material.dart' as _i15;

import '../pages/functions/fun_ai/function_ai.dart' as _i8;
import '../pages/functions/fun_ble/function_ble_page.dart' as _i12;
import '../pages/functions/fun_random_music/function_random_music.dart' as _i9;
import '../pages/functions/fun_random_picture/function_random_picture_page.dart'
    as _i11;
import '../pages/functions/fun_random_video/function_random_video_page.dart'
    as _i10;
import '../pages/functions/fun_test_hwkj/function_test_hwkj_page.dart' as _i13;
import '../pages/home/setting/scan/scan_page.dart' as _i4;
import '../pages/home/setting/tab_setting_page.dart' as _i2;
import '../pages/index/index_page.dart' as _i3;
import '../pages/selector/select_qrcode/qrcode_page.dart' as _i7;
import '../pages/splash_page.dart' as _i1;
import '../widgets/file_select/image_preview_page.dart' as _i6;
import '../widgets/file_select/video_preview_page.dart' as _i5;

class AppRouter extends _i14.RootStackRouter {
  AppRouter([_i15.GlobalKey<_i15.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabSettingRoute.name: (routeData) {
      final args = routeData.argsAs<TabSettingRouteArgs>(
          orElse: () => const TabSettingRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.TabSettingPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    IndexRoute.name: (routeData) {
      final args = routeData.argsAs<IndexRouteArgs>(
          orElse: () => const IndexRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.IndexPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ScanRoute.name: (routeData) {
      final args =
          routeData.argsAs<ScanRouteArgs>(orElse: () => const ScanRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.ScanPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    VideoPreviewRoute.name: (routeData) {
      final args = routeData.argsAs<VideoPreviewRouteArgs>();
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.VideoPreviewPage(
          key: args.key,
          url: args.url,
          autoPlay: args.autoPlay,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ImagePreViewRoute.name: (routeData) {
      final args = routeData.argsAs<ImagePreViewRouteArgs>();
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.ImagePreViewPage(
          key: args.key,
          initialIndex: args.initialIndex,
          galleryItems: args.galleryItems,
          backgroundDecoration: args.backgroundDecoration,
          scrollDirection: args.scrollDirection,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    QrcodeRoute.name: (routeData) {
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i7.QrcodePage(),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionAiRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionAiRouteArgs>(
          orElse: () => const FunctionAiRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i8.FunctionAiPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionRandomMusicRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionRandomMusicRouteArgs>(
          orElse: () => const FunctionRandomMusicRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i9.FunctionRandomMusicPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionRandomVideoRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionRandomVideoRouteArgs>(
          orElse: () => const FunctionRandomVideoRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i10.FunctionRandomVideoPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionRandomPictureRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionRandomPictureRouteArgs>(
          orElse: () => const FunctionRandomPictureRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i11.FunctionRandomPicturePage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionBleRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionBleRouteArgs>(
          orElse: () => const FunctionBleRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i12.FunctionBlePage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    FunctionTestHwkjRoute.name: (routeData) {
      final args = routeData.argsAs<FunctionTestHwkjRouteArgs>(
          orElse: () => const FunctionTestHwkjRouteArgs());
      return _i14.CustomPage<dynamic>(
        routeData: routeData,
        child: _i13.FunctionTestHwkjPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i14.TransitionsBuilders.noTransition,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i14.RouteConfig(
          TabSettingRoute.name,
          path: 'tab_setting_page',
        ),
        _i14.RouteConfig(
          IndexRoute.name,
          path: 'index_page',
        ),
        _i14.RouteConfig(
          ScanRoute.name,
          path: 'scan_page',
        ),
        _i14.RouteConfig(
          VideoPreviewRoute.name,
          path: 'video_preview_page',
        ),
        _i14.RouteConfig(
          ImagePreViewRoute.name,
          path: 'image_preView_page',
        ),
        _i14.RouteConfig(
          QrcodeRoute.name,
          path: 'qrcode_page',
        ),
        _i14.RouteConfig(
          FunctionAiRoute.name,
          path: 'function_ai',
        ),
        _i14.RouteConfig(
          FunctionRandomMusicRoute.name,
          path: 'function_random_music',
        ),
        _i14.RouteConfig(
          FunctionRandomVideoRoute.name,
          path: 'function_random_video_page',
        ),
        _i14.RouteConfig(
          FunctionRandomPictureRoute.name,
          path: 'function_random_picture_page',
        ),
        _i14.RouteConfig(
          FunctionBleRoute.name,
          path: 'function_ble_page',
        ),
        _i14.RouteConfig(
          FunctionTestHwkjRoute.name,
          path: 'function_test_hwkj_page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.TabSettingPage]
class TabSettingRoute extends _i14.PageRouteInfo<TabSettingRouteArgs> {
  TabSettingRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSettingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i3.IndexPage]
class IndexRoute extends _i14.PageRouteInfo<IndexRouteArgs> {
  IndexRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'IndexRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i4.ScanPage]
class ScanRoute extends _i14.PageRouteInfo<ScanRouteArgs> {
  ScanRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ScanRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i5.VideoPreviewPage]
class VideoPreviewRoute extends _i14.PageRouteInfo<VideoPreviewRouteArgs> {
  VideoPreviewRoute({
    _i16.Key? key,
    required String url,
    bool autoPlay = false,
  }) : super(
          VideoPreviewRoute.name,
          path: 'video_preview_page',
          args: VideoPreviewRouteArgs(
            key: key,
            url: url,
            autoPlay: autoPlay,
          ),
        );

  static const String name = 'VideoPreviewRoute';
}

class VideoPreviewRouteArgs {
  const VideoPreviewRouteArgs({
    this.key,
    required this.url,
    this.autoPlay = false,
  });

  final _i16.Key? key;

  final String url;

  final bool autoPlay;

  @override
  String toString() {
    return 'VideoPreviewRouteArgs{key: $key, url: $url, autoPlay: $autoPlay}';
  }
}

/// generated route for
/// [_i6.ImagePreViewPage]
class ImagePreViewRoute extends _i14.PageRouteInfo<ImagePreViewRouteArgs> {
  ImagePreViewRoute({
    _i16.Key? key,
    int initialIndex = 0,
    required List<String> galleryItems,
    _i15.Decoration? backgroundDecoration,
    _i15.Axis scrollDirection = _i15.Axis.horizontal,
  }) : super(
          ImagePreViewRoute.name,
          path: 'image_preView_page',
          args: ImagePreViewRouteArgs(
            key: key,
            initialIndex: initialIndex,
            galleryItems: galleryItems,
            backgroundDecoration: backgroundDecoration,
            scrollDirection: scrollDirection,
          ),
        );

  static const String name = 'ImagePreViewRoute';
}

class ImagePreViewRouteArgs {
  const ImagePreViewRouteArgs({
    this.key,
    this.initialIndex = 0,
    required this.galleryItems,
    this.backgroundDecoration,
    this.scrollDirection = _i15.Axis.horizontal,
  });

  final _i16.Key? key;

  final int initialIndex;

  final List<String> galleryItems;

  final _i15.Decoration? backgroundDecoration;

  final _i15.Axis scrollDirection;

  @override
  String toString() {
    return 'ImagePreViewRouteArgs{key: $key, initialIndex: $initialIndex, galleryItems: $galleryItems, backgroundDecoration: $backgroundDecoration, scrollDirection: $scrollDirection}';
  }
}

/// generated route for
/// [_i7.QrcodePage]
class QrcodeRoute extends _i14.PageRouteInfo<void> {
  const QrcodeRoute()
      : super(
          QrcodeRoute.name,
          path: 'qrcode_page',
        );

  static const String name = 'QrcodeRoute';
}

/// generated route for
/// [_i8.FunctionAiPage]
class FunctionAiRoute extends _i14.PageRouteInfo<FunctionAiRouteArgs> {
  FunctionAiRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionAiRoute.name,
          path: 'function_ai',
          args: FunctionAiRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionAiRoute';
}

class FunctionAiRouteArgs {
  const FunctionAiRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionAiRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i9.FunctionRandomMusicPage]
class FunctionRandomMusicRoute
    extends _i14.PageRouteInfo<FunctionRandomMusicRouteArgs> {
  FunctionRandomMusicRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionRandomMusicRoute.name,
          path: 'function_random_music',
          args: FunctionRandomMusicRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionRandomMusicRoute';
}

class FunctionRandomMusicRouteArgs {
  const FunctionRandomMusicRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionRandomMusicRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i10.FunctionRandomVideoPage]
class FunctionRandomVideoRoute
    extends _i14.PageRouteInfo<FunctionRandomVideoRouteArgs> {
  FunctionRandomVideoRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionRandomVideoRoute.name,
          path: 'function_random_video_page',
          args: FunctionRandomVideoRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionRandomVideoRoute';
}

class FunctionRandomVideoRouteArgs {
  const FunctionRandomVideoRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionRandomVideoRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i11.FunctionRandomPicturePage]
class FunctionRandomPictureRoute
    extends _i14.PageRouteInfo<FunctionRandomPictureRouteArgs> {
  FunctionRandomPictureRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionRandomPictureRoute.name,
          path: 'function_random_picture_page',
          args: FunctionRandomPictureRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionRandomPictureRoute';
}

class FunctionRandomPictureRouteArgs {
  const FunctionRandomPictureRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionRandomPictureRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i12.FunctionBlePage]
class FunctionBleRoute extends _i14.PageRouteInfo<FunctionBleRouteArgs> {
  FunctionBleRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionBleRoute.name,
          path: 'function_ble_page',
          args: FunctionBleRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionBleRoute';
}

class FunctionBleRouteArgs {
  const FunctionBleRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionBleRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i13.FunctionTestHwkjPage]
class FunctionTestHwkjRoute
    extends _i14.PageRouteInfo<FunctionTestHwkjRouteArgs> {
  FunctionTestHwkjRoute({
    _i16.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          FunctionTestHwkjRoute.name,
          path: 'function_test_hwkj_page',
          args: FunctionTestHwkjRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'FunctionTestHwkjRoute';
}

class FunctionTestHwkjRouteArgs {
  const FunctionTestHwkjRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i16.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'FunctionTestHwkjRouteArgs{key: $key, requestParams: $requestParams}';
  }
}
