import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'app/bootstrap/application_bootstrapper.dart';
import 'app/config/app_globals.dart';
import 'app/config/application_config.dart';
import 'app/navigation/app_navigator.dart';
import 'app/navigation/app_router.dart';
import 'app/theme/app_theme.dart';
import 'shared/widgets/feedback/network_status_banner.dart';

Future<void> main() async {
  await ApplicationBootstrapper.instance.bootstrap();
}

class Application extends StatelessWidget {
  const Application({super.key, required this.startPage});

  final Widget startPage;

  /// MaterialApp 还没挂上时没有 MediaQuery，用 View 计算逻辑尺寸。
  Size _designSize(BuildContext context) {
    final view = View.of(context);
    final ratio = view.devicePixelRatio == 0 ? 1.0 : view.devicePixelRatio;
    final shortestSide = view.physicalSize.shortestSide / ratio;
    return shortestSide > 600 ? const Size(1112, 710) : const Size(375, 812);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: _designSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.size,
      builder: (context, child) {
        return MaterialApp(
          /// 命名路由只负责后续跳转。首页由 bootstrap 传入的 startPage 决定。
          onGenerateRoute: AppRouter.onGenerateRoute,
          title: ApplicationConfig.appName,
          navigatorKey: globalKeyNavigatorKey,
          navigatorObservers: [RouteObserverService.instance],
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1)),
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: NetworkStatusBanner(),
                    ),
                  ],
                ),
              );
            },
          ),

          ///这里是首页配置，如果不需要首页，则不需要配置，比如登录页，引导页等，路由跳转方式需要注释掉
          home: RefreshConfiguration(
            enableLoadingWhenNoData: false,
            child: startPage,
          ),
        );
      },
    );
  }
}
