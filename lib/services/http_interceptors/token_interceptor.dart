import 'package:dio/dio.dart';
import 'package:djibly/services/device_info_service.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/http_services/djezzy_auth.dart';
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{

    options.headers['User-Agent'] = await DeviceInfo.userAgent();
    options.headers['CSRF-TOKEN'] = await DeviceInfo.getFingerprint();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async{
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {

    if(err.response != null && err.response.statusCode == 401){

      print("------------- start refreshing ---------------");
      bool response = await DjezzyAuth().refreshToken();

      print("---------------- End refreshing --------------");
      if(response){
        await Network.headersWithToken();
        try{
          final RequestOptions options = err.requestOptions;
          Options newOptions = await Network.dioOptionsWithToken();

          newOptions.headers['User-Agent'] = await DeviceInfo.userAgent();
          newOptions.headers['CSRF-TOKEN'] = await DeviceInfo.getFingerprint();
          newOptions.method = err.requestOptions.method;
          final response = await Dio().request(
            options.path,
            data: options.data,
            options: newOptions,
            queryParameters: options.queryParameters,
          );

          handler.resolve(Response(
            data: response.data, // Pass the response data
            requestOptions: options,
            headers: response.headers,
            statusCode: response.statusCode
          ));

        } catch (reissueError) {
          handler.resolve(reissueError.response);
        }
      }else {
        handler.resolve(err.response);
      }
    }else {
      if(err.response != null) {
        handler.resolve(err.response);
      }else{
        handler.resolve(Response(statusCode: 408, requestOptions: err.requestOptions));
      }
    }
  }
}