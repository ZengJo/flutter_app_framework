import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_app_framework/app/config/app_globals.dart';
import 'package:flutter_app_framework/app/config/application_config.dart';
import 'package:flutter_app_framework/app/theme/app_theme.dart';
import 'package:flutter_app_framework/app/navigation/app_navigator.dart';
import 'package:flutter_app_framework/app/bootstrap/application_bootstrapper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  await ApplicationBootstrapper.instance.bootstrap();
}

class Application extends ConsumerWidget {
  const Application({super.key, required this.startPage});

  final Widget startPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: MediaQuery.sizeOf(context).shortestSide > 600
          ? const Size(1112, 710)
          : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.size,
      builder: (context, child) {
        return MaterialApp(
          title: ApplicationConfig.appName,
          navigatorKey: globalKeyNavigatorKey,
          navigatorObservers: [RouteObserverService()],
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),
          home: RefreshConfiguration(
            enableLoadingWhenNoData: false,
            child: startPage,
          ),
        );
      },
    );
  }
}
