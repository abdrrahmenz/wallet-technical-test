part of 'transaction_bloc.dart';

enum TransactionStateStatus {
  initial,
  loading,
  success,
  failure,
  loadingMore,
  creating,
}

class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionStateStatus.initial,
    this.transactions = const [],
    this.selectedTransaction,
    this.failure,
    this.currentPage = 1,
    this.hasMoreData = true,
    this.currentWalletId,
  });

  final TransactionStateStatus status;
  final List<Transaction> transactions;
  final Transaction? selectedTransaction;
  final Failure? failure;
  final int currentPage;
  final bool hasMoreData;
  final String? currentWalletId;

  TransactionState copyWith({
    TransactionStateStatus? status,
    List<Transaction>? transactions,
    Transaction? selectedTransaction,
    Failure? failure,
    int? currentPage,
    bool? hasMoreData,
    String? currentWalletId,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      selectedTransaction: selectedTransaction ?? this.selectedTransaction,
      failure: failure ?? this.failure,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentWalletId: currentWalletId ?? this.currentWalletId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        selectedTransaction,
        failure,
        currentPage,
        hasMoreData,
        currentWalletId,
      ];
}
