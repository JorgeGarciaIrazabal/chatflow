import 'package:flutter_test/flutter_test.dart';
import 'package:chatflow/src/core/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('fromJson should convert snake_case to camelCase correctly', () {
      final json = {
        'id': 1,
        'email': 'test@example.com',
        'full_name': 'Test User',
        'is_active': true,
        'is_verified': false,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z'
      };

      final user = User.fromJson(json);
      
      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.fullName, 'Test User');
      expect(user.isActive, true);
      expect(user.isVerified, false);
      expect(user.createdAt.toString(), '2023-01-01 00:00:00.000Z');
      expect(user.updatedAt.toString(), '2023-01-02 00:00:00.000Z');
    });

    test('toJson should convert camelCase to snake_case correctly', () {
      final user = User(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
        isActive: true,
        isVerified: false,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = user.toJson();
      
      expect(json['id'], 1);
      expect(json['email'], 'test@example.com');
      expect(json['full_name'], 'Test User');
      expect(json['is_active'], true);
      expect(json['is_verified'], false);
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });
  });
}
