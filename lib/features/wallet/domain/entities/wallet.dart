import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String currency;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.currency,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, currency, balance, createdAt, updatedAt];
}
