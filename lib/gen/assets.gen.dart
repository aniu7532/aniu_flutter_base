/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsEnvGen {
  const $AssetsEnvGen();

  /// File path: assets/env/.env.dev
  String get envDev => 'assets/env/.env.dev';

  /// File path: assets/env/.env.prod
  String get envProd => 'assets/env/.env.prod';

  /// List of all assets
  List<String> get values => [envDev, envProd];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/arrow_down_icon.png
  AssetGenImage get arrowDownIcon =>
      const AssetGenImage('assets/images/arrow_down_icon.png');

  /// File path: assets/images/arrow_right_icon.png
  AssetGenImage get arrowRightIcon =>
      const AssetGenImage('assets/images/arrow_right_icon.png');

  /// File path: assets/images/bind_bg.png
  AssetGenImage get bindBg => const AssetGenImage('assets/images/bind_bg.png');

  /// File path: assets/images/bottom_tips1.png
  AssetGenImage get bottomTips1 =>
      const AssetGenImage('assets/images/bottom_tips1.png');

  /// File path: assets/images/bottom_tips2.png
  AssetGenImage get bottomTips2 =>
      const AssetGenImage('assets/images/bottom_tips2.png');

  /// File path: assets/images/bottom_tips3.png
  AssetGenImage get bottomTips3 =>
      const AssetGenImage('assets/images/bottom_tips3.png');

  /// File path: assets/images/doctor_bg.png
  AssetGenImage get doctorBg =>
      const AssetGenImage('assets/images/doctor_bg.png');

  /// File path: assets/images/exit_icon.png
  AssetGenImage get exitIcon =>
      const AssetGenImage('assets/images/exit_icon.png');

  /// File path: assets/images/hos_icon.png
  AssetGenImage get hosIcon =>
      const AssetGenImage('assets/images/hos_icon.png');

  /// File path: assets/images/img_upgrade.png
  AssetGenImage get imgUpgrade =>
      const AssetGenImage('assets/images/img_upgrade.png');

  /// File path: assets/images/index_bg.png
  AssetGenImage get indexBg =>
      const AssetGenImage('assets/images/index_bg.png');

  /// File path: assets/images/menu_cat.png
  AssetGenImage get menuCat =>
      const AssetGenImage('assets/images/menu_cat.png');

  /// File path: assets/images/menu_dog.png
  AssetGenImage get menuDog =>
      const AssetGenImage('assets/images/menu_dog.png');

  /// File path: assets/images/menu_girl.png
  AssetGenImage get menuGirl =>
      const AssetGenImage('assets/images/menu_girl.png');

  /// File path: assets/images/menu_view.png
  AssetGenImage get menuView =>
      const AssetGenImage('assets/images/menu_view.png');

  $AssetsImagesNoDataGen get noData => const $AssetsImagesNoDataGen();

  /// File path: assets/images/password_icon.png
  AssetGenImage get passwordIcon =>
      const AssetGenImage('assets/images/password_icon.png');

  /// File path: assets/images/patient_bg.png
  AssetGenImage get patientBg =>
      const AssetGenImage('assets/images/patient_bg.png');

  /// File path: assets/images/splash_bg.png
  AssetGenImage get splashBg =>
      const AssetGenImage('assets/images/splash_bg.png');

  /// File path: assets/images/track_play.png
  AssetGenImage get trackPlay =>
      const AssetGenImage('assets/images/track_play.png');

  /// File path: assets/images/treat_bg.png
  AssetGenImage get treatBg =>
      const AssetGenImage('assets/images/treat_bg.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        arrowDownIcon,
        arrowRightIcon,
        bindBg,
        bottomTips1,
        bottomTips2,
        bottomTips3,
        doctorBg,
        exitIcon,
        hosIcon,
        imgUpgrade,
        indexBg,
        menuCat,
        menuDog,
        menuGirl,
        menuView,
        passwordIcon,
        patientBg,
        splashBg,
        trackPlay,
        treatBg
      ];
}

class $AssetsImagesNoDataGen {
  const $AssetsImagesNoDataGen();

  /// File path: assets/images/no_data/default_no_track.png
  AssetGenImage get defaultNoTrack =>
      const AssetGenImage('assets/images/no_data/default_no_track.png');

  /// List of all assets
  List<AssetGenImage> get values => [defaultNoTrack];
}

class Assets {
  Assets._();

  static const $AssetsEnvGen env = $AssetsEnvGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
