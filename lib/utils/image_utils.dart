import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:musico/const/app_common.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:musico/utils/toast_util.dart';

class ImageUtils {
  ///加载网络图片
  static Widget loadImage(
    String url, {
    double width = 60,
    double height = 60,
    BoxFit fit = BoxFit.cover,
    bool useFullPath = false,
  }) {
    final errorWidget = Assets.images.noData.defaultNoTrack;

    /*  if (ObjectUtil.isEmpty(url) || !isImageByPath(url)) {
      print('asd');
      return errorWidget.image(width: width, height: height, fit: fit);
    }
   var imageUrl = useFullPath ? url : '${appCommon.baseOssUrl}$url';
    imageUrl = corpImage(imageUrl, width, height);*/
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      //错误图
      errorWidget: (BuildContext context, String url, error) {
        return errorWidget.image(width: width, height: height, fit: fit);
      },
      //占位图
      placeholder: (
        BuildContext context,
        String url,
      ) {
        return errorWidget.image(width: width, height: height, fit: fit);
      },
      fit: fit,
    );
  }

  static Widget loadImageWithRadius(
    String url, {
    double width = 60,
    double height = 60,
    double r = 20,
    BoxFit fit = BoxFit.cover,
    bool useFullPath = false,
    int errorType = 1,
    final BorderRadiusGeometry? borderRadius,
  }) {
    final errorWidget = Assets.images.noData.defaultNoTrack;

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, image) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(r),
            image: DecorationImage(image: image, fit: BoxFit.cover),
            // boxShadow: [
            //   BoxShadow(
            //       color: const Color(0xffd2d2d2).withAlpha(120),
            //       offset: const Offset(4, 4),
            //       blurRadius: 5.0,
            //       spreadRadius: 0)
            // ],
            // border: Border.all(width: 10.dp, color: Colors.black)
          ),
        );
      },
      //错误图
      errorWidget: (BuildContext context, String url, error) {
        return errorWidget.image(width: width, height: height, fit: fit);
      },
      //占位图
      placeholder: (
        BuildContext context,
        String url,
      ) {
        return errorWidget.image(width: width, height: height, fit: fit);
      },
      fadeInDuration: const Duration(milliseconds: 10),
    );
  }

  ///微信自动裁剪图片
  static String corpImage(String url, double w, double h) {
    if (ObjectUtil.isEmpty(url)) {
      return '';
    }
    //使用三倍图
    final width = 3 * w;
    final height = 3 * h;

    if (url.contains('?')) {
      return '$url&imageView2/1/w/$width/h/$height';
    }
    return '$url?imageView2/1/w/$width/h/$height';
  }

  ///加载网络图片
  static Widget loadMaxImage(
    String url, {
    double? width,
    double? height,
    double? placeHolderWidth,
    double? placeHolderHieght,
    BoxFit fit = BoxFit.cover,
    bool needBaseUrl = false,
    bool needSave = false,
    BuildContext? context,
  }) {
    // url = getImageUrl(url);
    // url = getThumbnailImageUrl(url, width.ceil(), height.ceil());
    if (needBaseUrl) {
      if (ObjectUtil.isEmpty(url.isEmpty) || !isImageByPath(url)) {
        return Assets.images.noData.defaultNoTrack.image(
          width: width ?? placeHolderWidth,
          height: height ?? placeHolderHieght,
          fit: fit,
        );
      }
    }

    final imageUrl = needBaseUrl ? '${appCommon.baseOssUrl}$url' : url;

    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      cacheManager: DefaultCacheManager(),
      //错误图
      errorWidget: (BuildContext context, String url, error) {
        return Assets.images.noData.defaultNoTrack.image(
          width: width ?? placeHolderWidth,
          height: height ?? placeHolderHieght,
          fit: fit,
        );
      },
      //占位图
      placeholder: (
        BuildContext context,
        String url,
      ) {
        return Assets.images.noData.defaultNoTrack.image(
          width: width ?? placeHolderWidth,
          height: height ?? placeHolderHieght,
          fit: fit,
        );
      },
      fit: fit,
    );

    return InkWell(
      onLongPress: !needSave
          ? null
          : () async {
              await showDialog(
                context: context!,
                builder: (BuildContext context) {
                  var saving = false;
                  const duration = 200;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: AnimatedSwitcher(
                          duration: const Duration(milliseconds: duration),
                          child: saving
                              ? const Text(
                                  '保存中...',
                                  key: Key('saving'),
                                  style:
                                      TextStyle(color: ColorName.primaryColor),
                                )
                              : const Text(
                                  '保存图片',
                                  key: Key('not_saving'),
                                  style:
                                      TextStyle(color: ColorName.primaryColor),
                                ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: duration),
                              child: saving
                                  ? const CircularProgressIndicator(
                                      key: Key('progress'),
                                      color: ColorName.primaryColor,
                                      strokeWidth: 3,
                                    )
                                  : const Text(
                                      '您确定要保存这张图片吗?',
                                      key: Key('content'),
                                      style: TextStyle(
                                          color: ColorName.primaryColor),
                                    ),
                            ),
                          ],
                        ),
                        actions: [
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: duration),
                              child: saving
                                  ? const SizedBox.shrink(
                                      key: Key('cancelSizebox'),
                                    )
                                  : TextButton(
                                      key: const Key('cancel'),
                                      onPressed: () {
                                        // 取消保存操作
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        '取消',
                                        style: TextStyle(
                                            color: ColorName.secondaryColor),
                                      ),
                                    )),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: duration),
                            child: saving
                                ? const SizedBox.shrink(
                                    key: Key('sureSizebox'),
                                  )
                                : TextButton(
                                    key: const Key('sure'),
                                    onPressed: () {
                                      // 取消保存操作
                                      Navigator.of(context).pop();
                                    },
                                    child: TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          saving = true; // 显示进度圈
                                        });

                                        final cacheManager =
                                            imageWidget.cacheManager;
                                        final file =
                                            await cacheManager?.getSingleFile(
                                                imageWidget.imageUrl);
                                        final imageBytes =
                                            await file?.readAsBytes();
                                        if (imageBytes != null) {
                                          final rst =
                                              await ImageGallerySaver.saveImage(
                                                  imageBytes);
                                          if (rst != null &&
                                              rst is Map &&
                                              rst['isSuccess']) {
                                            MyToast.showToast(
                                                '保存成功：${rst['filePath']}');
                                            Navigator.of(context)
                                                .pop(); // 保存成功后关闭对话框
                                          }
                                        }
                                      },
                                      child: const Text(
                                        '确定',
                                        style: TextStyle(
                                          color: ColorName.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
      child: imageWidget,
    );
  }

  //用户头像
  static ImageProvider<Object> loadUserHeaderImage(String url) {
    return getImageProvider(url);
  }

  static ImageProvider getImageProvider(String imageUrl) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(Assets.images.noData.defaultNoTrack.path);
    }
    if (imageUrl.endsWith('mp4')) {
      return AssetImage(Assets.images.noData.defaultNoTrack.path);
    }
    return CachedNetworkImageProvider(imageUrl);
  }

  static bool isImageByPath(String path) {
    var ret = false;
    final formatNames = [
      'JPG',
      'jpg',
      'bmp',
      'BMP',
      'gif',
      'GIF',
      'WBMP',
      'png',
      'PNG',
      'wbmp',
      'jpeg',
      'JPEG',
    ];
    if (ObjectUtil.isNotEmpty(path) && path.contains('.')) {
      var splitList = path.split('.');
      if (ObjectUtil.isNotEmpty(splitList)) {
        var suffix = splitList.last.toLowerCase();
        if (suffix.contains('?')) {
          final s = suffix.split('?');
          if (ObjectUtil.isNotEmpty(s)) {
            suffix = s.first;
          }
        }
        return formatNames.contains(suffix);
      }
    }
    return ret;
  }

  static String getFileNameByPath(path) {
    String ret = '';
    if (ObjectUtil.isNotEmpty(path)) {
      if (path.contains('/')) {
        List<String> split = path.split('/');
        if (split.isEmpty) {
          ret = path;
        } else {
          ret = split.last;
        }
      }
    }
    return ret;
  }

  static bool isPng(path) {
    String filePath = getFileNameByPath(path);
    try {
      if (filePath != '') {
        String split = filePath.split('.')[1];
        if (split == 'png')
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
