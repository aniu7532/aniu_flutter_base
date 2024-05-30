import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/pages/functions/fun_random_picture/bean/picture_info_bean.dart';
import 'package:musico/widgets/my_expansion.dart';

///  model
class FunctionRandomPictureModel extends ViewStateModel {
  FunctionRandomPictureModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  String imageUrl = '';

  String viewBaseUrl =
      'https://raw.onmicrosoft.cn/Bing-Wallpaper-Action/main/data/zh-CN_all.json';

  String app_id = 'fhqpcernqfmmdvfn';
  String app_secret = 'NE99vPD5a3Eu7T9fA0|1N0dn1H5PmnEs';
  String catBaseUrl = 'https://api.thecatapi.com/v1/images/search';
  String dogBaseUrl = 'https://dog.ceo/api/breeds/image/random';
  String astronomyBaseUrl =
      'https://api.nasa.gov/planetary/apod?api_key=TJTjotiNFKFh541VXfSwmsKdwMBVuRUikDmyPCgN';
  String beautyBaseUrl = 'https://api.uomg.com/api/rand.img2';

  int classify = 0;

  GlobalKey expandKey = GlobalKey();

  String _description = '';

  String get description => _description;

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
        await getCatUrl();
        break;
      case 2:
        await getDog();
        break;
      case 3:
        await getAstronomy();
        break;
      case 4:
        await getCars();
        break;
      case 5:
        await getLegs();
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
          final bean = functionPictureViewBean!
              .data?[Random().nextInt(functionPictureViewBean!.total ?? 0)];
          imageUrl = 'https://www.bing.com${bean?.url}';
          _description = bean?.title ?? '';
          notifyListeners();
        }
      }
    }
  }

  ///获取猫猫
  Future<void> getCatUrl() async {
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
        _description = _list.first.url ?? '';
        notifyListeners();
      }
    }
  }

  ///获取狗狗
  Future<void> getDog() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(
      dogBaseUrl,
    );

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final functionPictureDogBean =
          FunctionPictureDogBean.fromJson(apiResponse.data);

      if (ObjectUtil.isNotEmpty(functionPictureDogBean)) {
        imageUrl = functionPictureDogBean.message ?? '';
        _description = functionPictureDogBean.message ?? '';
        notifyListeners();
      }
    }
  }

  ///获取天文
  Future<void> getAstronomy() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(
      astronomyBaseUrl,
      params: {
        'date': DateFormat('yyyy-MM-dd').format(
            DateTime.now().subtract(Duration(days: Random().nextInt(100)))),
      },
    );

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final functionPictureAstronomyBean =
          FunctionPictureAstronomyBean.fromJson(apiResponse.data);

      if (ObjectUtil.isNotEmpty(functionPictureAstronomyBean)) {
        imageUrl = functionPictureAstronomyBean.url ?? '';
        _description = functionPictureAstronomyBean.explanation ?? '';
        notifyListeners();
      }
    }
  }

  ///获取汽车
  Future<void> getCars() async {
    ///请求数据
    final apiResponse = await apiModel.pureGet(
      'https://api.uomg.com/api/rand.img1?sort=汽车&format=json',
      responseType: ResponseType.bytes,
    );

    if (apiResponse.statusCode == 200 && apiResponse.data != null) {
      final functionPictureDogBean = apiResponse.data;

      if (ObjectUtil.isNotEmpty(functionPictureDogBean)) {
        final imgUrl = functionPictureDogBean['imgurl'];
        debugPrint('imgurl:$imageUrl');
        imageUrl = imgUrl;
        _description = imgUrl;
        notifyListeners();
      }
    }
  }

  ///获取美腿
  Future<void> getLegs() async {
    imageUrl = '';
    _description = '';
    notifyListeners();
    imageUrl = 'https://jkyapi.top/API/sjmtzs.php';
    _description = 'https://jkyapi.top/API/sjmtzs.php';
    notifyListeners();
  }
}
