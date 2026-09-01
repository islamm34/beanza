import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/core/utils/validators.dart';

void main() {
  group('AppValidators', () {
    group('validateEmail', () {
      test('should return error message when email is null or empty', () {
        expect(AppValidators.validateEmail(null), 'Email is required');
        expect(AppValidators.validateEmail(''), 'Email is required');
      });

      test('should return error message when email is invalid', () {
        expect(AppValidators.validateEmail('invalid-email'),
            'Please enter a valid email');
        expect(
            AppValidators.validateEmail('test@'), 'Please enter a valid email');
        expect(AppValidators.validateEmail('@domain.com'),
            'Please enter a valid email');
      });

      test('should return null when email is valid', () {
        expect(AppValidators.validateEmail('user@example.com'), isNull);
        expect(AppValidators.validateEmail('john.doe@caffeine.co'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return error message when password is empty', () {
        expect(AppValidators.validatePassword(null), 'Password is required');
        expect(AppValidators.validatePassword(''), 'Password is required');
      });

      test('should return error when password is less than 8 characters', () {
        expect(
          AppValidators.validatePassword('Short1!'),
          'Password must be at least 8 characters',
        );
      });

      test('should return error when missing uppercase letter', () {
        expect(
          AppValidators.validatePassword('lowercase1!'),
          'Password must contain at least one uppercase letter',
        );
      });

      test('should return error when missing lowercase letter', () {
        expect(
          AppValidators.validatePassword('UPPERCASE1!'),
          'Password must contain at least one lowercase letter',
        );
      });

      test('should return error when missing number', () {
        expect(
          AppValidators.validatePassword('NoNumbersHere!'),
          'Password must contain at least one number',
        );
      });

      test('should return null when password meets all criteria', () {
        expect(AppValidators.validatePassword('ValidPass123!'), isNull);
      });
    });

    group('validateConfirmPassword', () {
      test('should return error when confirm password is empty', () {
        expect(
          AppValidators.validateConfirmPassword('', 'Secret123'),
          'Confirm password is required',
        );
      });

      test('should return error when passwords do not match', () {
        expect(
          AppValidators.validateConfirmPassword('Different123', 'Secret123'),
          'Passwords do not match',
        );
      });

      test('should return null when passwords match', () {
        expect(
          AppValidators.validateConfirmPassword('Secret123', 'Secret123'),
          isNull,
        );
      });
    });

    group('validatePhone', () {
      test('should return error when phone is empty', () {
        expect(AppValidators.validatePhone(''), 'Phone number is required');
      });

      test('should return error when phone has less than 10 digits', () {
        expect(AppValidators.validatePhone('12345'),
            'Please enter a valid phone number');
      });

      test('should return null when phone number is valid', () {
        expect(AppValidators.validatePhone('+12345678901'), isNull);
        expect(AppValidators.validatePhone('1234567890'), isNull);
      });
    });

    group('validateName', () {
      test('should return error when name is empty or too short', () {
        expect(AppValidators.validateName(''), 'Name is required');
        expect(AppValidators.validateName('A'),
            'Name must be at least 2 characters');
      });

      test('should return null when name is valid', () {
        expect(AppValidators.validateName('John Doe'), isNull);
      });
    });

    group('validateCVV', () {
      test('should return error when CVV is invalid', () {
        expect(AppValidators.validateCVV(''), 'CVV is required');
        expect(AppValidators.validateCVV('12'), 'Please enter a valid CVV');
        expect(AppValidators.validateCVV('12345'), 'Please enter a valid CVV');
      });

      test('should return null when CVV is 3 or 4 digits', () {
        expect(AppValidators.validateCVV('123'), isNull);
        expect(AppValidators.validateCVV('1234'), isNull);
      });
    });
  });
}
