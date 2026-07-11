import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_constants.dart';
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
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Material(
          color: const Color(0xFFF1F9FF),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 42,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please go back and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF334155), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        appLogger.e('Uncaught platform error', error: error, stackTrace: stack);
        return true;
      };

      final config = await AppConfig.load();
      await initializeDateFormatting(AppConstants.indianLocale);
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
