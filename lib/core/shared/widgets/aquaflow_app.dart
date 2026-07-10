import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';
import '../../router/app_router.dart';
import '../../services/lifecycle_service.dart';
import '../../services/snackbar_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import 'loading_overlay.dart';
import 'network_banner.dart';

class AquaFlowApp extends ConsumerWidget {
  const AquaFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    ref.watch(lifecycleServiceProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: AppConstants.appName,
          theme: AppTheme.light(),
          themeMode: themeMode,
          routerConfig: appRouter,
          builder: (BuildContext context, Widget? child) {
            return LoadingOverlay(
              child: Stack(
                children: <Widget>[
                  child ?? const SizedBox.shrink(),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: NetworkBanner(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
