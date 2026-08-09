import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> requestCameraPermission();
  Future<bool> requestLocationPermission();
  Future<bool> requestNotificationPermission();
  Future<bool> checkCameraPermission();
  Future<bool> checkLocationPermission();
  Future<bool> checkNotificationPermission();
}

class AppPermissionService implements PermissionService {
  @override
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  @override
  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }

  @override
  Future<bool> checkNotificationPermission() async {
    return await Permission.notification.isGranted;
  }
}
