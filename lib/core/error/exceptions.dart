class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'network_error',
          originalError: originalError,
        );
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'server_error',
          originalError: originalError,
        );
}

class AuthenticationException extends AppException {
  AuthenticationException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'auth_error',
          originalError: originalError,
        );
}

class ValidationException extends AppException {
  final String? field;

  ValidationException({
    required String message,
    this.field,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'validation_error',
          originalError: originalError,
        );
}

class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'not_found',
          originalError: originalError,
        );
}

class CacheException extends AppException {
  CacheException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'cache_error',
          originalError: originalError,
        );
}

class LocationException extends AppException {
  LocationException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'location_error',
          originalError: originalError,
        );
}

class CameraException extends AppException {
  CameraException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'camera_error',
          originalError: originalError,
        );
}

class ScanException extends AppException {
  ScanException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? 'scan_error',
          originalError: originalError,
        );
}
