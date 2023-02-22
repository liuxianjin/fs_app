import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../common/bs_network.dart';

class BSRefresh extends StatefulWidget {
  /// 刷新视图
  final Widget child;

  /// 接口
  final String url;

  /// 默认参数
  final Map<String, dynamic> params;

  /// 是否允许下拉刷新
  final bool headerRefreshEnabled;

  /// 将要下拉刷新
  final BSVoidHandler willRefreshingHeader;

  /// 下拉刷新成功，对应接口20x
  final BSResponseHandler didRefreshingHeaderSuccess;

  /// 下拉刷新无数据，对应接口30x
  final BSResponseHandler didRefreshingHeaderEmpty;

  /// 下拉刷新失败，对应除20x、30x外的其他状态码
  final BSErrorHandler didRefreshingHeaderFailure;

  /// 下拉刷新结束，无论成功或失败
  final BSVoidHandler endRefreshingHeader;

  /// 是否允许上提加载
  final bool footerRefreshEnabled;

  /// 将要上提加载
  final BSVoidHandler willRefreshingFooter;

  /// 上提加载成功，对应接口20x
  final BSResponseHandler didRefreshingFooterSuccess;

  /// 上提加载无数据，对应接口30x
  final BSResponseHandler didRefreshingFooterEmpty;

  /// 上提加载失败，对应除20x、30x外的其他状态码
  final BSErrorHandler didRefreshingFooterFailure;

  /// 上提加载结束，无论成功或失败
  final BSVoidHandler endRefreshingFooter;

  const BSRefresh({
    Key key,
    this.child,
    this.url,
    this.params = const {},
    this.headerRefreshEnabled = false,
    this.willRefreshingHeader,
    this.didRefreshingHeaderSuccess,
    this.didRefreshingHeaderEmpty,
    this.didRefreshingHeaderFailure,
    this.endRefreshingHeader,
    this.footerRefreshEnabled = false,
    this.willRefreshingFooter,
    this.didRefreshingFooterSuccess,
    this.didRefreshingFooterEmpty,
    this.didRefreshingFooterFailure,
    this.endRefreshingFooter,
  }) : super(key: key);

  @override
  _BSRefreshState createState() => _BSRefreshState();
}

class _BSRefreshState extends State<BSRefresh> {
  int _page = 1;
  bool _isLoading = false;
  bool _footerRefreshEnabled = false;
  RefreshController _refreshController = RefreshController();

  void resetParameters() {
    _page = 1;
  }

  void checkNoMoreData(BSResponse response) {
    if (!widget.footerRefreshEnabled) return;

    int pages = int.parse(response.data['count']);
    int currentPage = int.parse(response.data['page']);
    if (pages > 0 && currentPage == pages) {
      _refreshController.loadNoData();
    }
  }

  void beginRefreshingHeader() async {
    // 下拉刷新
    resetParameters();
    final params = {'page': _page.toString()};
    widget.params.forEach((key, value) {
      params[key] = value;
    });
    if (widget.willRefreshingHeader != null) widget.willRefreshingHeader();
    await BSNetwork.post(
      widget.url,
      params: params,
      success: (BSResponse response) {
        _page++;
        _footerRefreshEnabled = true;
        _refreshController.refreshCompleted(resetFooterState: true);
        if (widget.didRefreshingHeaderSuccess != null) widget.didRefreshingHeaderSuccess(response);
        if (widget.endRefreshingHeader != null) widget.endRefreshingHeader();
        checkNoMoreData(response);
      },
      empty: (BSResponse response) {
        _footerRefreshEnabled = false;
        _refreshController.refreshCompleted(resetFooterState: true);
        if (widget.didRefreshingHeaderEmpty != null) widget.didRefreshingHeaderEmpty(response);
        if (widget.endRefreshingHeader != null) widget.endRefreshingHeader();
      },
      failure: (Error error) {
        _footerRefreshEnabled = false;
        _refreshController.refreshCompleted(resetFooterState: true);
        if (widget.didRefreshingHeaderFailure != null) widget.didRefreshingHeaderFailure(error);
        if (widget.endRefreshingHeader != null) widget.endRefreshingHeader();
      },
    );
  }

  void beginRefreshingFooter() async {
    // 上提加载
    final params = {'page': _page.toString()};
    widget.params.forEach((key, value) {
      params[key] = value;
    });
    if (widget.willRefreshingFooter != null) widget.willRefreshingFooter();
    await BSNetwork.post(
      widget.url,
      params: widget.params,
      success: (BSResponse response) {
        _page++;
        _refreshController.loadComplete();
        if (widget.didRefreshingFooterSuccess != null) widget.didRefreshingFooterSuccess(response);
        if (widget.endRefreshingFooter != null) widget.endRefreshingFooter();
        checkNoMoreData(response);
      },
      empty: (BSResponse response) {
        _refreshController.loadNoData();
        if (widget.didRefreshingFooterEmpty != null) widget.didRefreshingFooterEmpty(response);
        if (widget.endRefreshingFooter != null) widget.endRefreshingFooter();
      },
      failure: (Error error) {
        _refreshController.loadComplete();
        if (widget.didRefreshingFooterFailure != null) widget.didRefreshingFooterFailure(error);
        if (widget.endRefreshingFooter != null) widget.endRefreshingFooter();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SmartRefresher(
          enablePullDown: widget.headerRefreshEnabled,
          enablePullUp: widget.footerRefreshEnabled && _footerRefreshEnabled,
          controller: _refreshController,
          onRefresh: beginRefreshingHeader,
          onLoading: beginRefreshingFooter,
          child: widget.child,
        )
      ],
    );
  }
}
