import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/features/authentication/domain/entities/authentication_entity.dart';

void main() {
  group('AuthenticationEntity', () {
    test('supports value equality', () {
      final auth1 = AuthenticationEntity(
        id: '123',
        email: 'user@example.com',
        fullName: 'John Doe',
        accessToken: 'access_123',
        refreshToken: 'refresh_123',
      );

      final auth2 = AuthenticationEntity(
        id: '123',
        email: 'user@example.com',
        fullName: 'John Doe',
        accessToken: 'access_123',
        refreshToken: 'refresh_123',
      );

      expect(auth1, equals(auth2));
      expect(auth1.hashCode, equals(auth2.hashCode));
    });
  });
}
