import '../config/app_config.dart';
import '../constants/app_constants.dart';

class ConfigurationService {
  const ConfigurationService(this.config);

  final AppConfig config;

  String get appName => config.appName;

  String get appHeader => config.appHeader;

  String get currencySymbol => AppConstants.currencySymbol;

  String get dateFormat => AppConstants.dateFormat;

  String get timeFormat => AppConstants.timeFormat;

  String get indianLocale => AppConstants.indianLocale;
}
