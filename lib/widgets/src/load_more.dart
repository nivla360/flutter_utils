import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';

import '../../util/util.dart';
import 'error_view.dart';


///加载更多回调
// typedef LoadMoreCallback = Future<void> Function();

///构建自定义状态返回
typedef LoadMoreBuilder = Widget? Function(
    BuildContext context, LoadStatus status);

//for initial loading before load more
typedef InitialLoaderBuilder = Widget Function(
    BuildContext context, LoadStatus initialStatus);

// typedef OnRefreshCallback = Future<void> Function();

///加载状态
enum LoadStatus {
  idle, //正常状态
  error, //加载错误
  loading, //加载中
  noInternet,
  completed, //加载完成
  initialLoadSuccess, //use for only initial load
  initialLoadEmpty, //use for only initial load
}

///加载更多 Widget
class LoadMore extends StatefulWidget {
  ///加载状态
  final LoadStatus status,initialStatus;

  ///加载更多回调
  final VoidCallback onLoadMore;

  final RefreshCallback? onRefresh;

  ///自定义加载更多 Widget
  final LoadMoreBuilder? loadMoreBuilder;

  final InitialLoaderBuilder? initialLoaderBuilder;

  ///CustomScrollView
  final CustomScrollView child;

  final VoidCallback? initialApiCall;

  ///到底部才触发加载更多
  final bool endLoadMore;

  ///加载更多底部触发距离
  final double bottomTriggerDistance;

  ///底部 loadmore 高度
  final double footerHeight;

  ///Footer key
  final Key _keyLastItem = const Key("__LAST_ITEM");

  ///Text displayed during load
  final String loadingMsg;

  //To show different animation when there is no messages
  final bool isChat;

  //show loading text
  final bool showLoadingText;

  //listen for horizontal scroll to trigger load more
  final bool triggerHorizontalScroll;

  ///Text displayed in case of error
  final String errorMsg;

  ///Text displayed when loading is finished
  final String finishMsg;

  const LoadMore({
    required this.status,
    required this.initialStatus,
    this.initialLoaderBuilder,
    required this.onLoadMore,
    this.initialApiCall,
    this.onRefresh,
    this.endLoadMore = true,
    this.triggerHorizontalScroll = false,
    this.bottomTriggerDistance = 200,
    this.footerHeight = 50,
    this.showLoadingText = false,
    this.isChat = false,
    this.loadMoreBuilder,
    this.loadingMsg = 'Loading...',
    this.errorMsg = 'An error occurred，try again',
    this.finishMsg = ' No more items ',
    required this.child,
    super.key
  });

  @override
  State<StatefulWidget> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {

  @override
  void initState() {
    // if (widget.callInitAfterPostFrameCallBack) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if(widget.initialApiCall != null) {
          widget.initialApiCall!();
        }
      });
    // } else {
    //   if(widget.initialApiCall != null) {
    //     widget.initialApiCall!();
    //   }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///添加 Footer Sliver
    dynamic check =
    widget.child.slivers.elementAt(widget.child.slivers.length - 1);

    ///判断是否已存在 Footer
    if (check is SliverSafeArea && check.key == widget._keyLastItem) {
      widget.child.slivers.removeLast();
    }

    widget.child.slivers.add(
      SliverSafeArea(
        key: widget._keyLastItem,
        top: false,
        left: false,
        right: false,
        sliver: SliverToBoxAdapter(
          child: _buildLoadMore(widget.status),
        ),
      ),
    );

    return AnimatedSwitcher(duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.07,0.0),
            end: const Offset(0.00,0.0))
            .animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: widget.onRefresh == null ? widget.initialStatus == LoadStatus.initialLoadSuccess ? NotificationListener<ScrollNotification>(
        onNotification: _handleNotification,
        child: widget.child,
      ) : _buildInitialLoader(context,widget.initialStatus)
          : RefreshIndicator(
          onRefresh: widget.onRefresh!,
          color: context.theme.primaryColor,
          child: widget.initialStatus == LoadStatus.initialLoadSuccess ? NotificationListener<ScrollNotification>(
          onNotification: _handleNotification,
          child: widget.child,
    ) : _buildInitialLoader(context,widget.initialStatus),
      ),);
  }

  Widget _buildInitialLoader(BuildContext context,LoadStatus status){

    // if(widget.initialLoaderBuilder != null && status == LoadStatus.loading){
    //   return widget.initialLoaderBuilder!(context,status);
    // }
    if(widget.initialLoaderBuilder != null){
      return widget.initialLoaderBuilder!(context,status);
    }
    switch (status) {
      case LoadStatus.loading:
        return Center(child: loadingWidget30,);
      case LoadStatus.noInternet:
        return ErrorView.noInternet(
          onRetry: widget.initialApiCall ?? widget.onRefresh,
        );
      case LoadStatus.initialLoadEmpty:
        return ErrorView.noResult(isChat: widget.isChat,onRetry: widget.initialApiCall ?? widget.onRefresh,);
      case LoadStatus.error:
        return ErrorView(onRetry: widget.initialApiCall ?? widget.onRefresh);
      default:
        return const SizedBox.shrink();
    }
  }

  ///构建加载更多 Widget
  Widget _buildLoadMore(LoadStatus status) {
    ///检查返回自定义状态
    if (widget.loadMoreBuilder != null) {
      final Widget? loadMore = widget.loadMoreBuilder!(context, status);
      if (loadMore != null) {
        return loadMore;
      }
    }

    ///返回内置状态
    if (status == LoadStatus.loading) {
      return _buildLoading();
    } else if (status == LoadStatus.error) {
      return _buildLoadError();
    } else if (status == LoadStatus.noInternet) {
      return _buildNoInternetError();
    } else if (status == LoadStatus.completed) {
      return _buildLoadFinish();
    } else {
      return Container(height: widget.footerHeight);
    }
  }

  _buildNoInternetError(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //点击重试加载更多
        widget.onLoadMore();
      },
      child: SizedBox(
        height: widget.footerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget> [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Internet Connection Lost, Retry',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///加载中状态
  Widget _buildLoading() {
    return SizedBox(
      height: widget.footerHeight,
      child: widget.showLoadingText ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           SizedBox(
            width: 30,
            height: 30,
            child: loadingWidget30,
          ),
          const SizedBox(width: 10),
          Text(
            widget.loadingMsg,
          ),
        ],
      ) : SizedBox(
        width: 30,
        height: 30,
        child: loadingWidget30,
      ),
    );
  }

  ///加载错误状态
  Widget _buildLoadError() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //点击重试加载更多
        widget.onLoadMore();
      },
      child: SizedBox(
        height: widget.footerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           const Icon(
              Icons.error,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.errorMsg,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///加载错误状态
  Widget _buildLoadFinish() {
    return SizedBox(
      height: widget.footerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 10,
            child: Divider(
              color: Colors.grey,
            ),
          ),
         const SizedBox(width: 6),
          Text(
            widget.finishMsg,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
         const SizedBox(width: 6),
          const SizedBox(
            width: 10,
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  ///计算加载更多
  bool _handleNotification(ScrollNotification notification) {

    if(notification.metrics.axis == Axis.horizontal && !widget.triggerHorizontalScroll) {
      return false;
    }
    //当前滚动距离
    double currentExtent = notification.metrics.pixels;
    //最大滚动距离
    double maxExtent = notification.metrics.maxScrollExtent;
    //滚动更新过程中，并且设置非滚动到底部可以触发加载更多
    if ((notification is ScrollUpdateNotification) && !widget.endLoadMore) {
      return _checkLoadMore(
          (maxExtent - currentExtent <= widget.bottomTriggerDistance));
    }

    //滚动到底部，并且设置滚动到底部才触发加载更多
    if ((notification is ScrollEndNotification) && widget.endLoadMore) {
      //滚动到底部并且加载状态为正常时，调用加载更多
      return _checkLoadMore((currentExtent >= maxExtent));
    }

    return false;
  }

  ///处理加载更多
  bool _checkLoadMore(bool canLoad) {
    if (canLoad && widget.status == LoadStatus.idle) {
      widget.onLoadMore();
      return true;
    }
    return false;
  }
}
