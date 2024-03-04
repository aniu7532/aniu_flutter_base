import 'dart:convert';
import 'dart:math';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_position.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/pages/functions/fun_random_picture/bean/picture_info_bean.dart';
import 'package:musico/pages/functions/fun_random_video/bean/video_info_bean.dart';
import 'package:musico/widgets/my_expansion.dart';
import 'package:video_player/video_player.dart';

///  model
class FunctionRandomPictureModel extends ViewStateModel {
  FunctionRandomPictureModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  String imageUrl = '';

  String viewBaseUrl =
      'https://raw.onmicrosoft.cn/Bing-Wallpaper-Action/main/data/zh-CN_all.json';
  String girlBaseUrl = 'https://www.mxnzp.com/api/image/girl/list/random';
  String app_id = 'fhqpcernqfmmdvfn';
  String app_secret = 'NE99vPD5a3Eu7T9fA0|1N0dn1H5PmnEs';
  String catBaseUrl = 'https://api.thecatapi.com/v1/images/search';
  String dogBaseUrl = 'https://dog.ceo/api/breeds/image/random';

  int classify = 0;

  GlobalKey expandKey = GlobalKey();

  void setClassify(int c) {
    (expandKey.currentState as MyExpansionTileState).handleTap();
    classify = c;
    initData();
  }

  @override
  Future<void> initData() async {
    return super.initData();
  }

  @override
  Future? loadData() async {
    ///请求数据

    switch (classify) {
      case 0:
        getViewUrl();
        break;
      case 1:
        getCatUrl();
        break;
      case 2:
        getDog();
        break;
      case 3:
        getGirls();
        break;
    }
  }

  ///获取景色数据

  FunctionPictureViewBean? functionPictureViewBean;

  getViewUrl() async {
    if (ObjectUtil.isNotEmpty(functionPictureViewBean)) {
      imageUrl =
          'https://www.bing.com${functionPictureViewBean!.data?[Random().nextInt(functionPictureViewBean!.total ?? 0)].url}';
      notifyListeners();
    } else {
      ///请求数据
      final apiResponse = await apiModel.pureGet(
        viewBaseUrl,
      );

      if (apiResponse.statusCode == 200 && apiResponse.data != null) {
        functionPictureViewBean =
            FunctionPictureViewBean.fromJson(json.decode(apiResponse.data));

        if (ObjectUtil.isNotEmpty(functionPictureViewBean)) {
          imageUrl =
              'https://www.bing.com${functionPictureViewBean!.data?[Random().nextInt(functionPictureViewBean!.total ?? 0)].url}';
          notifyListeners();
        }
      }
    }
  }

  ///获取猫猫
  getCatUrl() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(
      catBaseUrl,
    );

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final _list = <FunctionPictureCatBean>[];

      for (final element in apiResponse.data as List) {
        _list.add(FunctionPictureCatBean.fromJson(element));
      }

      if (!ObjectUtil.isEmptyList(_list)) {
        imageUrl = _list.first.url ?? '';
        notifyListeners();
      }
    }
  }

  ///获取狗狗
  getDog() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(
      dogBaseUrl,
    );

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final functionPictureDogBean =
          FunctionPictureDogBean.fromJson(apiResponse.data);

      if (ObjectUtil.isNotEmpty(functionPictureDogBean)) {
        imageUrl = functionPictureDogBean.message ?? '';
        notifyListeners();
      }
    }
  }

  ///获取狗狗
  getGirls() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(girlBaseUrl, params: {
      'app_id': app_id,
      'app_secret': app_secret,
    });

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final functionPictureDogBean =
          FunctionPictureDogBean.fromJson(apiResponse.data);

      if (ObjectUtil.isNotEmpty(functionPictureDogBean)) {
        imageUrl = functionPictureDogBean.message ?? '';
        notifyListeners();
      }
    }
  }
}
