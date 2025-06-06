import 'package:equatable/equatable.dart';
import '../../auth.dart';

class UserModel extends Equatable {
  final String id;
  final String? name;
  final String email;
  final String? username;
  final String? phone;
  final String? image;
  final String role;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.name,
    required this.email,
    this.username,
    this.phone,
    this.image,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  User toEntity() {
    return User(
      name: name,
      email: email,
      username: username,
      image: image,
      phone: phone,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name'],
        email: json['email'] ?? '',
        username: json['username'],
        phone: json['phone'],
        image: json['image'],
        role: json['role'] ?? 'user',
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.parse(json['email_verified_at'])
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : DateTime.now(),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        username,
        phone,
        image,
        role,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
