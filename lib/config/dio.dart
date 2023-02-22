import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fsapp/config/config.dart';
import 'package:sp_util/sp_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Http {
  static var obj ;
  static  BaseOptions baseOptions;
  static  Dio dio ;

  static void initHttp(){
    baseOptions = BaseOptions(
        connectTimeout: Config.timeout,
    );
    dio = new Dio(baseOptions);
  }

  //全局拦截器
  //创建默认的全局拦截器
  static Interceptor dInter = InterceptorsWrapper(
      onRequest: (options){
        options.headers = {
          'uid':SpUtil.getString('userId'),
          'token':SpUtil.getString('token'),
        };
        print(options);
        print("请求   ${options.uri}");
        return options;
      },
      onResponse: (response){
        print("响应   ${response.statusCode}   ${response.statusMessage}");
        return response;
      },
      onError: (err){
        print("错误   ${err.message}");
        return err;
      }
  );

  static Future<T> get<T>(String url,{
    String method = 'get',
    FormData data,
    Map<String, dynamic> params,
    Interceptor inter,
  }) async {
    print('请求进来了');
    final options  = Options(method: method, headers: {});

    List<Interceptor> inters = [dInter];

    if(inter!=null){
      inters.add(inter);
    }
    dio.interceptors.addAll(inters);
      url = Config.baseUrl + url;

    //网络请求
    try{
      Response res = await dio.request(url,queryParameters: params, options: options, data: data);
      var tempData;
      if(res.data is Map){
        print('返回数据');
        tempData =  res.data;
      }else{
        tempData =  json.decode(res.data);
      }
      print('code 测试 略略略${tempData['code']}');
      if(tempData['code']==200){
        return tempData;
      }else{
        Fluttertoast.showToast(msg: tempData['desc']);
      }
    }on DioError catch(e){
      print("cuowu ${e.response.statusMessage}");
      return Future.error(e);
    }
  }

  static Future<T> post <T>(
      String url, {
        Map<String, dynamic> params,
        FormData data,
        Interceptor inter,
        options,
      }) async {

      final options  = Options(method: 'post', headers: {});

      List<Interceptor> inters = [dInter];

      if(inter!=null){
        inters.add(inter);
      }

      print(dio);


      dio.interceptors.addAll(inters);
        url = Config.baseUrl + url;
      //网络请求
      try{
        Response res = await dio.request(url,queryParameters: params, options: options, data: data);
        var tempData;
        if(res.data is Map){
          print('返回数据');
          tempData =  res.data;
        }else{
          tempData =  json.decode(res.data);
        }
        return tempData;
      }on DioError catch(e){
        return Future.error(e);
      }

  }

}
