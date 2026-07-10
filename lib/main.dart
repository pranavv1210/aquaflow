import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/application/configuration_providers.dart';
import 'core/services/app_logger.dart';
import 'core/services/supabase_service.dart';
import 'core/shared/widgets/aquaflow_app.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        appLogger.e(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        appLogger.e('Uncaught platform error', error: error, stackTrace: stack);
        return true;
      };

      final config = await AppConfig.load();
      await SupabaseService.initialize(config);
      SupabaseService.instance.initializeRealtime();

      runApp(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
          child: const AquaFlowApp(),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      appLogger.e('Uncaught zone error', error: error, stackTrace: stackTrace);
    },
  );
}
