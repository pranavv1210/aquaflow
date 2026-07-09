import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class AppFormatters {
  AppFormatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: AppConstants.indianLocale,
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  static final DateFormat _date = DateFormat(
    AppConstants.dateFormat,
    AppConstants.indianLocale,
  );

  static final DateFormat _time = DateFormat(
    AppConstants.timeFormat,
    AppConstants.indianLocale,
  );

  static String currency(num value) => _currency.format(value);

  static String date(DateTime value) => _date.format(value);

  static String time(DateTime value) => _time.format(value);
}
