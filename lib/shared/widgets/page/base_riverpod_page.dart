import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/di/page_registry.dart';
import '../layout/app_scaffold.dart';

/// 所有页面都需要继承这个
/// 泛型 S: 状态类型,页面数据层
/// 泛型 VM: ViewModel 类型 (必须继承 StateNotifier<S>),页面逻辑层
abstract class BaseRiverpodPage<S, VM extends StateNotifier<S>>
    extends ConsumerStatefulWidget {
  const BaseRiverpodPage({super.key});

  /// 每个页面必须提供自己的 provider
  StateNotifierProvider<VM, S> get provider;
}

abstract class BaseRiverpodState<
  T extends BaseRiverpodPage<S, VM>,
  S,
  VM extends StateNotifier<S>
>
    extends ConsumerState<T>
    with AutomaticKeepAliveClientMixin {
  bool _initialized = false;

  /// 当前页面的 ViewModel
  late VM viewModel;

  /// 子类可重写
  void onLoadingComplete() {}

  /// 子类可控制是否在 tab 中缓存
  bool get keepAlive => true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ref.read(widget.provider.notifier);

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) onLoadingComplete();
      });
    }
  }

  /// 页面主体
  Widget? buildBody(BuildContext context) => null;

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

  /// 是否自动调整
  bool? get isResizeToAvoidBottomInset => true;

  /// 页面背景颜色
  Color? get backgroundColor => Colors.white;

  /// 返回按钮颜色
  Color? get backIconColor => null;

  /// 导航栏背景颜色
  Color? get navigatorColor => Colors.white;

  /// 底部导航栏
  Widget? get scaffoldBottomNavigationBar => const SizedBox.shrink();

  /// 标题栏
  Widget? get navigatorTitleWidget => null;

  /// 标题栏颜色
  Color? get navigatorTitleColor => const Color(0xFF333333);

  /// 返回按钮
  Widget? get navigatorBackWidget => null;

  /// 返回按钮图标
  String? get navigatorBackIconPath => null;

  /// 顶部导航栏右侧菜单
  List<Widget>? get navigatorActionWidget => const [];

  ///返回按钮事件
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PageScope<S>(
      provider: widget.provider,
      child: buildContainer(
        context,
        buildBody(context) ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
