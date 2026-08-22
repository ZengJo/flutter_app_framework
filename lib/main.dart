import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'app/bootstrap/application_bootstrapper.dart';
import 'app/config/app_globals.dart';
import 'app/navigation/app_navigator.dart';
import 'app/navigation/app_router.dart';
import 'app/navigation/route_names.dart';
import 'app/theme/app_theme.dart';
import 'core/globalization/generated/app_localizations.dart';
import 'core/globalization/providers/globalization_providers.dart';

Future<void> main() async {
  await ApplicationBootstrapper.instance.bootstrap();
}

/// App 根节点。
///
/// 使用 ConsumerStatefulWidget 的原因：
/// 1. 监听 Riverpod 的 GlobalizationState；
/// 2. 监听系统 Locale 变化；
/// 3. App 回到前台时刷新系统时区。
class Application extends ConsumerStatefulWidget {
  const Application({super.key, required this.startPage});

  final Widget startPage;

  @override
  ConsumerState<Application> createState() => _ApplicationState();
}

class _ApplicationState extends ConsumerState<Application>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    ref.read(globalizationProvider.notifier).updateSystemLocales(locales);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // 用户可能在系统设置中修改了时区，回到 App 时刷新。
      ref.read(globalizationProvider.notifier).refreshSystemSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalization = ref.watch(globalizationProvider);

    return ScreenUtilInit(
      designSize: MediaQuery.sizeOf(context).shortestSide > 600
          ? const Size(1112, 710)
          : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.size,
      builder: (context, child) {
        return MaterialApp(
          /// 当前真正生效的 Locale。
          locale: globalization.locale,

          /// Flutter 官方生成的 Material / Cupertino / Widgets 本地化代理。
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          /// App 名称也从 ARB 获取，不再写死单一语言。
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,

          /// 这里是路由跳转页面配置，如果不需要路由跳转，则不需要配置。
          initialRoute: RouteNames.languageSettings,
          onGenerateRoute: AppRouter.onGenerateRoute,
          navigatorKey: globalKeyNavigatorKey,
          navigatorObservers: [RouteObserverService()],
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1)),
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),

          /// 这里是首页配置，如果不需要首页，则不需要配置。
          home: RefreshConfiguration(
            enableLoadingWhenNoData: false,
            child: widget.startPage,
          ),
        );
      },
    );
  }
}
