import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'configuration_service.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw StateError('AppConfig was not provided.');
});

final configurationServiceProvider = Provider<ConfigurationService>((ref) {
  return ConfigurationService(ref.watch(appConfigProvider));
});
