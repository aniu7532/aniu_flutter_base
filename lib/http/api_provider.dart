// ignore_for_file: parameter_assignments

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/http/api_response.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/http/dio_util.dart';
import 'package:musico/http/interceptor/dio_connectivity_request_retrier.dart';
import 'package:musico/http/interceptor/retry_interceptor.dart';
import 'package:musico/http/model/base_bean.dart';
import 'package:musico/http/repository/token_repository.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum ContentType { urlEncoded, json }

class ApiModel {
  factory ApiModel() => _instance;

  ApiModel._() {
    if (dotenv.env['BASE_URL'] != null) {
      _baseUrl = dotenv.env['BASE_URL']!;
    }
    _baseUrl = '';
  }

  static late final ApiModel _instance = ApiModel._();

  late String _baseUrl;
  final TokenModel _tokenModel = TokenModel();

  Future<APIResponse> post(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
    String preventRepeatKey = '',
    ProgressCallback? onSendProgress,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '网络异常')),
      );
    }
    String url;

    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }
/*//单个接口调试
    if (path.contains('http')) {
      url = path;
    }*/

    var content = 'application/x-www-form-urlencoded';

    if (contentType == ContentType.json) {
      content = 'application/json';
    }

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Algolia-Application-Id': '695QAXGQ42',
        'X-Algolia-Api-Key':
            'ZmRiMWNjYjZmY2I0MzgwZWExMzhiZDgzYWY4ZDdhZjBiMDFhY2YyMDhmNWI4M2YzMDJkNDA2NTIxNmRhZDk5M2ZpbHRlcnM9cHJvdmlkZXJfaWRzJTNBMTA4MjUyODQrT1IrcHJvdmlkZXJfaWRzJTNBLTEmcmVzdHJpY3RJbmRpY2VzPWV4ZXJjaXNlc19wcm9kdWN0aW9uX3Vz',
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      if (ObjectUtil.isNotEmpty(preventRepeatKey)) {
        headers['prevent-repeat-key'] = preventRepeatKey;
      }

      final response = await dio.post(
        url,
        data: body,
        queryParameters: params,
        onSendProgress: onSendProgress,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '网络异常')),
        );
      }
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> url:  $url');
        log('------>>> params: ${JsonUtil.encodeObj(params) ?? ''}');
        if (body is FormData) {
        } else {
          log('------>>> body: ${JsonUtil.encodeObj(body) ?? ''}');
        }

        log('------>>> response: ${JsonUtil.encodeObj(response.data) ?? ''}');
      }
      if (response.statusCode! < 300) {
        if (response.data is String) {
          response.data = json.decode(response.data);
        }

        final bean = BaseBean.fromJson(response.data);
        if (bean.msg == 'success') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        if (response.statusCode! == 401 && loginOutWhenTokenOutOfTime) {
          MyToast.showError('登录已失效，请重新登录!');
          appRouter.popUntilRoot();
          // await appRouter.replace(LoginRoute());
        }
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '服务器异常')),
        );
        // if (response.statusCode! == 400) {
        //   return const APIResponse.error(
        //       AppException.errorWithMessage('服务器内部错误'));
        // } else if (response.statusCode! == 401) {
        //   return const APIResponse.error(AppException.unauthorized());
        // } else if (response.statusCode! == 502) {
        //   return const APIResponse.error(AppException.error());
        // } else {
        //   if (response.data['message'] != null) {
        //     return APIResponse.error(
        //         AppException.errorWithMessage(response.data['message'] ?? ''));
        //   } else {
        //     return const APIResponse.error(AppException.error());
        //   }
        // }
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${JsonUtil.encodeObj(body) ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: formatError(e))),
      );
    } catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${JsonUtil.encodeObj(body) ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '未知错误')),
      );
    }
  }

  Future<String?> getRedirectedUrl(String? url) async {
    debugPrint('getRedirectedUrl:$url');
    try {
      final dio = Dio();
      await dio.get(
        url ?? '',
        options: Options(
          followRedirects: false, // 禁止自动重定向
        ),
      );
    } catch (e) {
      return (e as DioError).response?.headers['location']?.first;
    }

    return null;
  }

  Future<Response> pureGet(
    String path, {
    Map<String, dynamic>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
  }) async {
    final _response = Response(requestOptions: RequestOptions(path: path));

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _response
        ..statusCode = 500
        ..data = '网络异常';
      return _response;
    }

    var content = 'application/x-www-form-urlencoded';

    if (contentType == ContentType.json) {
      content = 'application/json; charset=utf-8';
    }

    final headers = {
      'accept': '*/*',
      'Content-Type': content,
    };

    final _appToken = await _tokenModel.fetchToken();
    if (_appToken != null) {
      headers['Authorization'] = 'Bearer ${_appToken.token}';
    }

    try {
      final response = await dio.get(
        path,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      _response
        ..statusCode = 500
        ..data = formatError(e);
      return _response;
    } catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      _response
        ..statusCode = 500
        ..data = '未知错误';
      return _response;
    }
  }

  Future<APIResponse> get(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '网络异常')),
      );
    }
    String url;

    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    var content = 'application/x-www-form-urlencoded';

    if (contentType == ContentType.json) {
      content = 'application/json; charset=utf-8';
    }

    final headers = {
      'accept': '*/*',
      'Content-Type': content,
    };

    final _appToken = await _tokenModel.fetchToken();
    if (_appToken != null) {
      headers['Authorization'] = 'Bearer ${_appToken.token}';
    }

    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );
      if (response == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '网络异常')),
        );
      }
      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '网络异常')),
        );
      }

      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> response: ${JsonUtil.encodeObj(response.data) ?? ''}');
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        return APIResponse.success(BaseBean.fromJson(response.data));
        if (bean.msg == 'success') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        if (response.statusCode! == 401 && loginOutWhenTokenOutOfTime) {
          MyToast.showError('登录已失效，请重新登录!');
          appRouter.popUntilRoot();
          // await appRouter.replace(LoginRoute());
        }
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '服务器异常')),
        );
        // if (response.statusCode! == 400) {
        //   return const APIResponse.error(
        //       AppException.errorWithMessage('服务器内部错误'));
        // } else if (response.statusCode! == 401) {
        //   return const APIResponse.error(AppException.unauthorized());
        // } else if (response.statusCode! == 502) {
        //   return const APIResponse.error(AppException.error());
        // } else {
        //   if (response.data['message'] != null) {
        //     return APIResponse.error(
        //         AppException.errorWithMessage(response.data['message'] ?? ''));
        //   } else {
        //     return const APIResponse.error(AppException.error());
        //   }
        // }
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: formatError(e))),
      );
    } catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '未知错误')),
      );
    }
  }

  Future<APIResponse> postFiles(
    String path,
    List files, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '网络异常')),
      );
    }
    String url;
    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    final formData = FormData();

    final allFiles = files
        .map((e) => MapEntry('files', MultipartFile.fromFileSync(e)))
        .toList();

    formData.files.addAll(allFiles);

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': 'multipart/form-data',
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '网络异常')),
        );
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.msg == 'success') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '服务器异常')),
        );
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: formatError(e))),
      );
    } catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '未知错误')),
      );
    }
  }

  Future<APIResponse> postFile(
    String path, {
    String? newBaseUrl,
    String? token,
    required Map<String, Object> params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '网络异常')),
      );
    }
    String url;
    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    // formData.files.add(MapEntry('files', MultipartFile.fromFileSync(file)));

    final formData = FormData.fromMap(params);

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': 'multipart/form-data',
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '网络异常')),
        );
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.msg == 'success') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(msg: '服务器异常')),
        );
      }
    } on DioError catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: formatError(e))),
      );
    } catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(msg: '未知错误')),
      );
    }
  }

  /*
   * error统一处理
   */
  String formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      return '连接超时';
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      return '请求超时';
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      return '响应超时';
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      return '出现异常';
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      return '请求取消';
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      return '未知错误';
    }
  }
}
