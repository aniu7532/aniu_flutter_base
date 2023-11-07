import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:musico/http/interceptor/dio_connectivity_request_retrier.dart';
import 'package:musico/http/interceptor/retry_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

late Dio dio;

class DioUtil {
  factory DioUtil() => _getInstance();

  DioUtil._internal() {
    initDio();
  }
  // 单例模式
  static DioUtil? _instance;

  static DioUtil get instance => _getInstance();

  static DioUtil _getInstance() {
    _instance ??= DioUtil._internal();
    return _instance!;
  }

  void setBaseUrl({String baseUrl = 'https://www.baidu.com/'}) {
    dio.options.baseUrl = baseUrl;
  }

  void initDio() {
    dio = Dio();
    dio.options.sendTimeout = 15000;
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 60000;
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          connectivity: Connectivity(),
        ),
      ),
    );
    //解决其他isolate中没有鉴权信息
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions e, RequestInterceptorHandler handler) {
          e.headers = {'hwId': tokenStr};
          handler.next(e);
        },
      ),
    );
    dio.httpClientAdapter = DefaultHttpClientAdapter();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      // final production = dotenv.get('IS_PRODUCTION');
      // final proxy = dotenv.get('proxy');
      // if ((production == '0' || production == '1') &&
      //     ObjectUtil.isNotEmpty(proxy)) {
      //   client.findProxy = (uri) => 'PROXY $proxy';
      // }
    };

    dio.interceptors.add(
      PrettyDioLogger(
        request: false,
        // requestHeader: true,
        // responseHeader: true,
        responseBody: false,
      ),
    );
  }

  /// 永久/鉴权/不加密token
  static const String tokenStr =
      'l0g8X0zh43hOgyY0Ey2RuxRbFbZhdVosmVTGC4TZDM4q0L8ALsmcM+2ytFytePblBcOVhWA4BD2ewdWtKMu9O6GXQ2JqdL6UD35rRAIyxn87TZM2vOQt9sQbHzayxImtzmP5v0b/CO2IeerMPRPndGrocNXKjw3SFYB/LQXir7AjmUyXlI2+OwbcENUAhcatt/nqnlVhhUHyFrh2evZ4Q7Pe74AtyBSHAcAAxDcSw9ZVBC6vPHqSDGE/2kii5glBK3XuQdso44toKiACpJZmvdw4UEHyUAfbzbHGtc3/HnVJJ+1/I/ye/7GTPn5ajnsxuWiWOSwOL65bisIqnCQUDXS3LJ7xOPaA4dXvVMny4mo=';
}
