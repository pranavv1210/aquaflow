import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'permission_service.dart';

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return const PermissionService();
});
