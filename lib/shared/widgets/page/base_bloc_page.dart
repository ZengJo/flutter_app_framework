import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/layout/app_scaffold.dart';

/// Bloc 页面基类
///
/// 泛型 S: 页面状态类型
/// 泛型 B: Bloc / Cubit 类型，必须继承 BlocBase<S>
abstract class BaseBlocPage<S, B extends BlocBase<S>> extends StatefulWidget {
  const BaseBlocPage({super.key});

  /// 每个页面必须创建自己的 Bloc / Cubit
  B createBloc(BuildContext context);
}

abstract class BaseBlocState<
  T extends BaseBlocPage<S, B>,
  S,
  B extends BlocBase<S>
>
    extends State<T>
    with AutomaticKeepAliveClientMixin {
  bool _initialized = false;

  /// 当前页面的 Bloc / Cubit
  late final B bloc;

  /// 子类可重写，页面首帧渲染完成后执行
  void onLoadingComplete() {}

  /// 子类可控制是否在 Tab 中缓存
  bool get keepAlive => true;

  @override
  void initState() {
    super.initState();

    bloc = widget.createBloc(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized && mounted) {
        _initialized = true;
        onLoadingComplete();
      }
    });
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  /// 页面主体
  Widget? buildBody(BuildContext context, S state) => null;

  /// 状态变化监听，例如弹 Toast、跳转页面
  void onStateChanged(BuildContext context, S state) {}

  /// 是否需要监听状态变化
  bool get enableStateListener => false;

  /// 是否需要根据状态刷新 UI
  bool get enableStateBuilder => true;

  /// 控制 BlocBuilder 是否刷新
  bool buildWhen(S previous, S current) => true;

  /// 控制 BlocListener 是否监听
  bool listenWhen(S previous, S current) => true;

  /// 导航栏标题
  String? get navigatorTitle => "";

  /// 是否显示导航栏
  bool? get isAppBar => true;

  /// 标题是否居中显示
  bool? get isTitleCenter => true;

  /// 是否覆盖顶部状态栏
  bool? get isExtendBodyBehindAppBar => false;

  /// 内容延伸防遮挡
  bool? get extendBody => false;

  /// 是否自动调整，避免键盘遮挡
  bool? get isResizeToAvoidBottomInset => true;

  /// 页面背景颜色
  Color? get backgroundColor => Colors.white;

  /// 返回按钮颜色
  Color? get backIconColor => null;

  /// 导航栏背景颜色
  Color? get navigatorColor => Colors.white;

  /// 底部导航栏
  Widget? get scaffoldBottomNavigationBar => const SizedBox.shrink();

  /// 标题栏 Widget
  Widget? get navigatorTitleWidget => null;

  /// 标题栏文字颜色
  Color? get navigatorTitleColor => const Color(0xFF333333);

  /// 返回按钮 Widget
  Widget? get navigatorBackWidget => null;

  /// 返回按钮图标路径
  String? get navigatorBackIconPath => null;

  /// 顶部导航栏右侧菜单
  List<Widget>? get navigatorActionWidget => const [];

  /// 返回按钮事件
  VoidCallback? get navigatorBackPressed => null;

  /// 是否显示底部边框
  bool? get isShowBottomBorder => false;

  /// 页面容器包装
  Widget buildContainer(BuildContext context, Widget child) {
    return AppScaffold(
      body: Container(
        alignment: Alignment.topLeft,
        height: double.infinity,
        width: double.infinity,
        child: child,
      ),
      navigatorColor: navigatorColor,
      backIconColor: backIconColor,
      navigatorTiTleStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: navigatorTitleColor,
      ),
      navigatorBackIconPath: navigatorBackIconPath,
      scaffoldBottomNavigationBar: scaffoldBottomNavigationBar,
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      navigatorTitle: navigatorTitle,
      isExtendBodyBehindAppBar: isExtendBodyBehindAppBar,
      navigatorActionWidget: navigatorActionWidget,
      navigatorTitleWidget: navigatorTitleWidget,
      navigatorBackWidget: navigatorBackWidget,
      isResizeToAvoidBottomInset: isResizeToAvoidBottomInset,
      navigatorBackPressed: navigatorBackPressed,
      isAppBar: isAppBar,
      isTitleCenter: isTitleCenter,
      isShowBottomBorder: isShowBottomBorder,
    );
  }

  Widget _buildWithBuilder(BuildContext context) {
    if (!enableStateBuilder) {
      return buildContainer(
        context,
        buildBody(context, bloc.state) ?? const SizedBox.shrink(),
      );
    }

    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (context, state) {
        return buildContainer(
          context,
          buildBody(context, state) ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildWithListener(BuildContext context) {
    if (!enableStateListener) {
      return _buildWithBuilder(context);
    }

    return BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: onStateChanged,
      child: _buildWithBuilder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider<B>.value(
      value: bloc,
      child: _buildWithListener(context),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
