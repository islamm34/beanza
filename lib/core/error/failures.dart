abstract class Failure {
  final String message;
  final String? code;

  Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  NetworkFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'network_error',
        );
}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({
    required String message,
    this.statusCode,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'server_error',
        );
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'auth_error',
        );
}

class ValidationFailure extends Failure {
  final String? field;

  ValidationFailure({
    required String message,
    this.field,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'validation_error',
        );
}

class NotFoundFailure extends Failure {
  NotFoundFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'not_found',
        );
}

class CacheFailure extends Failure {
  CacheFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'cache_error',
        );
}

class LocationFailure extends Failure {
  LocationFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'location_error',
        );
}

class CameraFailure extends Failure {
  CameraFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'camera_error',
        );
}

class ScanFailure extends Failure {
  ScanFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'scan_error',
        );
}

class UnknownFailure extends Failure {
  UnknownFailure({
    required String message,
    String? code,
  }) : super(
          message: message,
          code: code ?? 'unknown_error',
        );
}
