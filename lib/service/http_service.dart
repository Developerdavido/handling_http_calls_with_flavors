

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../env.dart';

class HttpService {

  String? host;
  BaseOptions? baseOptions;
  static const devBaseUrl = "http://calapi.inadiutorium.cz";

  static const prodBaseUrl = "http://calapi.inadiutorium.cz";

  //instantiate the dio object here
  Dio? dio;

  //this will set the default timeout value to 300 seconds or 5 minutes
  int getDefaultTimeOut = 300;


  HttpService() {
    initHttpService();
  }

  ///The invalidateHttps method will help to check if the certificate is valid or not.
  ///if not valid, it is still allowed to continue and retuen a response
  initValidateHttps() {
    dio?.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: (){
          final HttpClient client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
        validateCertificate: (cert, port, host) {
          if (cert == null) {
            return true;
          }
          return true;
        }
    );
  }


  //get the remote config
  Future<void> initHttpService() async {
    host = AppEnv.config.baseUrl;
    //initialize dio
    baseOptions = BaseOptions(
        baseUrl: host!,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        validateStatus: (status) {
          return status! <= 500;
        }

    );
    dio  = Dio(baseOptions);

    ///this condition checks if the we are in the dev environment and
    ///calls the invalidateHttps method to validate the certificate
    if (AppEnv.config.flavor == Flavor.dev) initValidateHttps();
  }


  Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "TokenValue" //this will take the token if in this case the token is being passed through the header to maintain the session
    } ;

  }

  ///this is a get function that takes the following parameters
  ///[url], [queryParameters], [token]
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, CancelToken? token}) async {
    String uri = "$host$url";
    return dio!.get(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
      queryParameters: queryParameters,
    );
  }
}