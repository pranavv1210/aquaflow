import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_service.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return const NavigationService();
});
