import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/controller.dart';

class Logging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

      Controller().printLogs('BASE URL [${options.baseUrl}]');
      Controller().printLogs('REQUEST[${options.method}] => PATH: ${options.path}');
      Controller().printLogs('REQUEST:Body[${options.method}] => PATH: ${options.data
          .toString()}');
      Controller().printLogs('REQUEST[${options.method}] => PATH: ${options.headers}');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    Controller().printLogs('RESPONSE:Body[${response.statusCode}] => PATH: ${response
          .requestOptions.data}');
    Controller().printLogs(
          'RESPONSE[${response.statusCode}] => Response: ${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {

    Controller().printLogs(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions
            .path}',
      );
    Controller().printLogs(
        'ERROR[${err.response?.statusCode}] => PATH: ${err..message}',
      );

    return super.onError(err, handler);
  }


  
}
