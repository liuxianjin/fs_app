import 'package:sharesdk_plugin/sharesdk_plugin.dart';

class BSMobShare {
  static BSMobShare _instance;
  static ShareSDKRegister _register;

  static BSMobShare getInstance() {
    if (_instance == null) {
      _instance = BSMobShare();
      _instance._initSdkRegister();
    }
    return _instance;
  }

  void _initSdkRegister() {
    _register = ShareSDKRegister();
    // 添加闭环分享回调监听
    // SharesdkPlugin.addRestoreReceiver(_onEvent, _onError);
  }

  // 初始化微信
  void initWechat(String appId, String appSecret, String appUniversalLink) {
    _register.setupWechat(appId, appSecret, appUniversalLink);
    SharesdkPlugin.regist(_register);
  }

  // 初始化QQ
  void initQQ(String appId, String appKey) {
    _register.setupQQ(appId, appKey);
    SharesdkPlugin.regist(_register);
  }

  // 分享
  void share(
    int platform, // 1、微信 2、微信朋友圈 3、QQ 4、QQ空间
    String title, // 标题
    String text, // 描述
    {
    String image =
        'http://www.beisheng.org/uploads/admin/image/2019-08-21/5d5cfe95a4508.jpg', // 图片
    String url = 'http://www.beisheng.org', // 跳转链接
    Function result, // 回调Function{}
    int contentType = 3, // 分享类型
  }) {
    _isInstall(platform).then((value) {
      if (value) {
        SSDKMap params = SSDKMap()
          ..setGeneral(title, text, [image], image, null, url, url, null, null,
              null, _getShareType(contentType));

        SharesdkPlugin.share(_getSharePlatform(platform), params,
            (SSDKResponseState state, Map userdata, Map contentEntity,
                SSDKError error) {
          result(_getShareRetrun(state, error.rawData));
        });
      }
    });
  }

  // 获取授权信息
  void auth(int platform, Function result) async {
    print('-------------------------------');
    _isInstall(platform).then((value) {
      if (value) {
//        SharesdkPlugin.auth(
//            ShareSDKPlatforms.wechatSession, null, (SSDKResponseState state,
//            Map user, SSDKError error) {
//          print(user);
//          print(error.rawData);
//        });
        SharesdkPlugin.getUserInfo(_getSharePlatform(platform),
            (SSDKResponseState state, Map user, SSDKError error) {
              var userJson = _getAuthInfoReturn(platform, user);
          result(
              _getShareRetrun(state, user != null ? userJson : error.rawData));
        });
      }
    });
  }

  // JS 闭环分享回调
  void _onEvent(Object event) {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(event);
    //String path = resMap['path'];
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>> Shared onSuccess:' + resMap.toString());
  }

  // JS 闭环分享回调
  void _onError(Object event) {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>> Shared onError:' + event.toString());
  }

  // 平台应用是否安装
  Future _isInstall(int platform) async {
    return await SharesdkPlugin.isClientInstalled(_getSharePlatform(platform))
        .then((value) {
      return value['state'] == 'installed';
    });
  }

  // 获取授权后的信息
  static _getAuthInfoReturn(int platform, Map authInfo) {
    if (authInfo == null) return null;
    print(authInfo);
    // Map<String, dynamic> info = {};
    String info = '';
    switch (platform) {
      case 1:
        info = authInfo['dbInfo'];
        break;
      case 3:
        info = authInfo['dbInfo'];
        break;
    }
    return info;
  }

  /*
   * 获取分享到的平台
   */
  static _getSharePlatform(int platform) {
    ShareSDKPlatform sdkPlatform;
    switch (platform) {
      case 1: // 微信
        sdkPlatform = ShareSDKPlatforms.wechatSession;
        break;
      case 2: // 微信朋友圈
        sdkPlatform = ShareSDKPlatforms.wechatTimeline;
        break;
      case 3: // QQ
        sdkPlatform = ShareSDKPlatforms.qq;
        break;
      case 4: // QQ空间
        sdkPlatform = ShareSDKPlatforms.qZone;
        break;
      default: // 微信
        sdkPlatform = ShareSDKPlatforms.wechatSession;
        break;
    }
    return sdkPlatform;
  }

  /*
   * 获取分享内容的类型
   */
  static _getShareType(int contentType) {
    SSDKContentType sdkContentType;
    switch (contentType) {
      case 1: // 文字
        sdkContentType = SSDKContentTypes.text;
        break;
      case 2: // 图片
        sdkContentType = SSDKContentTypes.image;
        break;
      case 3: // 网页 图文
        sdkContentType = SSDKContentTypes.webpage;
        break;
      case 4: // APP
        sdkContentType = SSDKContentTypes.app;
        break;
      case 5: // 音频
        sdkContentType = SSDKContentTypes.audio;
        break;
      case 6: // 视频
        sdkContentType = SSDKContentTypes.video;
        break;
      case 7: // 文件
        sdkContentType = SSDKContentTypes.file;
        break;
      case 8: // 小程序
        sdkContentType = SSDKContentTypes.miniProgram;
        break;
      default: // 网页 图文
        sdkContentType = SSDKContentTypes.webpage;
        break;
    }
    return sdkContentType;
  }

  /*
   * 获取分享结果 
   */
  static _getShareRetrun(state, desc) {
    Map<String, dynamic> ret;
    switch (state) {
      case SSDKResponseState.Success:
        ret = BsReturn.success(desc ?? 'shared success');
        break;
      case SSDKResponseState.Fail:
      case SSDKResponseState.Cancel:
        ret = BsReturn.error(desc);
        break;
      default:
        ret = BsReturn.error(desc);
        break;
    }
    return ret;
  }
}

/*
 * 自定义返回数据格式 
 */
class BsReturn {
  static const String sucCode = "200";
  static const String errCode = "400";

  static Map<String, dynamic> success(String desc) {
    return {'code': sucCode, 'desc': desc};
  }

  static Map<String, dynamic> error(String desc) {
    return {'code': errCode, 'desc': desc};
  }
}
