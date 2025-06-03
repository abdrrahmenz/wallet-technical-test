import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? name;
  final String email;
  final String? username;
  final String? phone;
  final String? image;

  const User({
    this.name,
    required this.email,
    this.username,
    this.phone,
    this.image,
  });

  @override
  List<Object?> get props => [name, email, username, phone, image];
}
