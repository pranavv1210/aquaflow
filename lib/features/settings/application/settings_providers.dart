import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/package_info_provider.dart';
import '../../../core/services/supabase_providers.dart';

class BusinessProfileSettings {
  const BusinessProfileSettings({
    required this.businessName,
    required this.currency,
    required this.dateFormat,
    required this.timeFormat,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerAddress,
  });

  final String businessName;
  final String currency;
  final String dateFormat;
  final String timeFormat;
  final String ownerName;
  final String ownerPhone;
  final String ownerAddress;

  factory BusinessProfileSettings.fromJson(Map<String, dynamic> json) {
    return BusinessProfileSettings(
      businessName: json['business_name']?.toString() ?? 'AquaFlow',
      currency: json['currency']?.toString() ?? 'INR',
      dateFormat: json['date_format']?.toString() ?? 'dd MMM yyyy',
      timeFormat: json['time_format']?.toString() ?? '12 Hour',
      ownerName: json['owner_name']?.toString() ?? '',
      ownerPhone: json['owner_phone']?.toString() ?? '',
      ownerAddress: json['owner_address']?.toString() ?? '',
    );
  }
}

final businessProfileSettingsProvider =
    FutureProvider.autoDispose<BusinessProfileSettings>((ref) async {
      final response =
          await ref
              .watch(supabaseClientProvider)
              .from('business_settings')
              .select('setting_value')
              .eq('setting_key', 'business_profile')
              .maybeSingle();
      final value = response?['setting_value'];
      if (value is Map<String, dynamic>) {
        return BusinessProfileSettings.fromJson(value);
      }
      return BusinessProfileSettings.fromJson(const <String, dynamic>{});
    });

final appVersionLabelProvider = FutureProvider.autoDispose<String>((ref) async {
  final info = await ref.watch(packageInfoProvider.future);
  return '${info.version}+${info.buildNumber}';
});
