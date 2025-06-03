part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class CreateDepositEvent extends TransactionEvent {
  const CreateDepositEvent({
    required this.walletId,
    required this.amount,
    this.description,
    this.referenceId,
  });

  final String walletId;
  final double amount;
  final String? description;
  final String? referenceId;

  @override
  List<Object?> get props => [walletId, amount, description, referenceId];
}

class CreateWithdrawalEvent extends TransactionEvent {
  const CreateWithdrawalEvent({
    required this.walletId,
    required this.amount,
    this.description,
    this.referenceId,
  });

  final String walletId;
  final double amount;
  final String? description;
  final String? referenceId;

  @override
  List<Object?> get props => [walletId, amount, description, referenceId];
}

class GetTransactionsEvent extends TransactionEvent {
  const GetTransactionsEvent({
    required this.walletId,
    this.page,
    this.limit,
  });

  final String walletId;
  final int? page;
  final int? limit;

  @override
  List<Object?> get props => [walletId, page, limit];
}

class GetTransactionByIdEvent extends TransactionEvent {
  const GetTransactionByIdEvent({
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;

  @override
  List<Object?> get props => [walletId, transactionId];
}

class LoadMoreTransactionsEvent extends TransactionEvent {
  const LoadMoreTransactionsEvent({
    required this.walletId,
  });

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}

class RefreshTransactionsEvent extends TransactionEvent {
  const RefreshTransactionsEvent({
    required this.walletId,
  });

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}
