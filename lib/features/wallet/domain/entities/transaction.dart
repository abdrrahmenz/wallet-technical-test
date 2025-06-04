import 'package:equatable/equatable.dart';

enum TransactionType {
  deposit,
  withdrawal,
}

class Transaction extends Equatable {
  final String id;
  final String walletId;
  final TransactionType type;
  final double amount;
  final String? description;
  final String? referenceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? relatedTransactionId;

  const Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.description,
    this.referenceId,
    required this.createdAt,
    required this.updatedAt,
    this.relatedTransactionId,
  });

  @override
  List<Object?> get props => [
        id,
        walletId,
        type,
        amount,
        description,
        referenceId,
        createdAt,
        updatedAt,
        relatedTransactionId,
      ];
}
