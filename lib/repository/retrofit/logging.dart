import 'package:dio/dio.dart';

class Logging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('REQUEST:Body[${options.method}] => PATH: ${options.data}');
     print('REQUEST[${options.method}] => PATH: ${options.headers}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print( 'RESPONSE:Body[${response.statusCode}] => PATH: ${response.requestOptions.data}');
    print( 'RESPONSE[${response.statusCode}] => Response: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err..message}',
    );
    return super.onError(err, handler);
  }


  
}
