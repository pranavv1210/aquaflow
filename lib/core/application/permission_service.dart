import '../result/result.dart';

enum AppPermission { phone, storage, notifications }

enum AppPermissionStatus { granted, denied, restricted, unknown }

class PermissionService {
  const PermissionService();

  Future<Result<AppPermissionStatus>> status(AppPermission permission) async {
    return const Success<AppPermissionStatus>(AppPermissionStatus.unknown);
  }

  Future<Result<AppPermissionStatus>> request(AppPermission permission) async {
    return const Success<AppPermissionStatus>(AppPermissionStatus.unknown);
  }
}
