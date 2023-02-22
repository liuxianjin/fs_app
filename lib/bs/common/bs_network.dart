import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../config/config.dart';

typedef BSVoidHandler = void Function();
typedef BSResponseHandler = void Function(BSResponse response);
typedef BSErrorHandler = void Function(Error error);

class BSResponse {
  String code;
  String desc;
  String url;
  Map<String, dynamic> params;
  dynamic data;
}

class BSNetwork {

  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: Config.baseUrl,
      connectTimeout: Config.timeout,
      headers: {

      }
  );

  static Dio _dio = Dio(baseOptions);
  // 转换url、对接缓存
  static Map finalParams(Map params) {
    return params;
  }

  static Future<BSResponse> post(
    String url, {
    Map params,
    BSResponseHandler success,
    BSResponseHandler empty,
    BSErrorHandler failure,
  }) async {
    // 发送网络请求
    try {
      String finalUrl = url;
      if (!url.startsWith('http')) finalUrl = 'http://10.254.10.61:8005/$url';
      // 最终的参数,加密和本地存储
      Map finalParams = params;
      // params数组
      List fields = [];
      if (finalParams != null && finalParams.length > 0) {
        finalParams.forEach((key, value) {
          fields.add('$key=$value');
        });
      }
      // url和params连接符
      String connector = fields.length > 0 ? (finalUrl.contains('?') ? '&' : '?') : '';
      // params字符串
      String paramsStr = fields.join('&');
      // 边界线
      print('网络请求:\n$finalUrl$connector$paramsStr\nparams:\n$params');
      Response response = await _dio.post(finalUrl, queryParameters: finalParams);
      print('请求结果:\n$response');
      final data = response.data;
      BSResponse ret = BSResponse();
      ret.url = finalUrl;
      ret.params = finalParams;
      if (data is Map) {
        String code = data['code'].toString();
        ret.code = code;
        ret.data = data['data'];
        ret.desc = data['desc'];
        // 回调
        if (code.startsWith('20')) {
          if (success != null) success(ret);
        } else if (code.startsWith('30')) {
          if (empty != null) empty(ret);
        } else {
          if (failure != null) failure(Error());
        }
      } else {
        ret.code = '400';
        ret.desc = '数据异常';
        if (failure != null) failure(Error());
      }
      return ret;
    } on DioError catch (e) {
      if (failure != null) failure(Error());
      return Future.error(e);
    }
  }


  static Future<T> get<T>(String url,{
    String method = 'get',
    Map<String, dynamic> params,
    Interceptor inter
  }) async {
//    1.创建单独配置
    final options  = Options(method: method, headers: {});

    //全局拦截器
    //创建默认的全局拦截器
    Interceptor dInter = InterceptorsWrapper(
        onRequest: (options){
          return options;
        },
        onResponse: (response){
          return response;
        },
        onError: (err){
          return err;
        }
    );

    List<Interceptor> inters = [dInter];
    if(inter!=null){
      inters.add(inter);
    }

    //统一添加
    _dio.interceptors.addAll(inters);

    //网络请求
    try{
      Response res = await _dio.request(url,queryParameters: params, options: options);
      return res.data;
    }on DioError catch(e){
      return Future.error(e);
    }
  }
}
