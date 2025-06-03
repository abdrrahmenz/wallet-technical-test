import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/core.dart';
import '../../../domain/domain.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required this.createDepositUseCase,
    required this.createWithdrawalUseCase,
    required this.getTransactionsUseCase,
    required this.getTransactionByIdUseCase,
  }) : super(const TransactionState()) {
    on<CreateDepositEvent>(_onCreateDeposit);
    on<CreateWithdrawalEvent>(_onCreateWithdrawal);
    on<GetTransactionsEvent>(_onGetTransactions);
    on<GetTransactionByIdEvent>(_onGetTransactionById);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
  }

  final CreateDepositUseCase createDepositUseCase;
  final CreateWithdrawalUseCase createWithdrawalUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final GetTransactionByIdUseCase getTransactionByIdUseCase;

  Future<void> _onCreateDeposit(
    CreateDepositEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TransactionStateStatus.creating));

      final result = await createDepositUseCase(
        CreateDepositParams(
          walletId: event.walletId,
          amount: event.amount,
          description: event.description,
          referenceId: event.referenceId,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: TransactionStateStatus.failure,
          failure: failure,
        )),
        (transaction) {
          // Add new transaction to the beginning of the list
          final updatedTransactions = [transaction, ...state.transactions];
          emit(state.copyWith(
            status: TransactionStateStatus.success,
            transactions: updatedTransactions,
            selectedTransaction: transaction,
          ));
        },
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onCreateWithdrawal(
    CreateWithdrawalEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TransactionStateStatus.creating));

      final result = await createWithdrawalUseCase(
        CreateWithdrawalParams(
          walletId: event.walletId,
          amount: event.amount,
          description: event.description,
          referenceId: event.referenceId,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: TransactionStateStatus.failure,
          failure: failure,
        )),
        (transaction) {
          // Add new transaction to the beginning of the list
          final updatedTransactions = [transaction, ...state.transactions];
          emit(state.copyWith(
            status: TransactionStateStatus.success,
            transactions: updatedTransactions,
            selectedTransaction: transaction,
          ));
        },
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      debugPrint('🔄 Getting transactions for wallet: ${event.walletId}');
      emit(state.copyWith(
        status: TransactionStateStatus.loading,
        currentWalletId: event.walletId,
        currentPage: 1,
      ));

      final result = await getTransactionsUseCase(
        GetTransactionsParams(
          walletId: event.walletId,
          page: event.page ?? 1,
          limit: event.limit ?? 10,
        ),
      );

      result.fold(
        (failure) {
          debugPrint('❌ Failed to get transactions: ${failure.message}');
          emit(state.copyWith(
            status: TransactionStateStatus.failure,
            failure: failure,
          ));
        },
        (transactions) {
          debugPrint('✅ Got ${transactions.length} transactions');
          for (var tx in transactions) {
            debugPrint(
                '📝 Transaction: id=${tx.id}, type=${tx.type}, amount=${tx.amount}');
          }
          emit(state.copyWith(
            status: TransactionStateStatus.success,
            transactions: transactions,
            hasMoreData: transactions.length >= (event.limit ?? 10),
          ));
        },
      );
    } catch (exception, stackTrace) {
      debugPrint('🔥 Exception in _onGetTransactions: $exception');
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onGetTransactionById(
    GetTransactionByIdEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TransactionStateStatus.loading));

      final result = await getTransactionByIdUseCase(
        GetTransactionByIdParams(
          walletId: event.walletId,
          transactionId: event.transactionId,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: TransactionStateStatus.failure,
          failure: failure,
        )),
        (transaction) => emit(state.copyWith(
          status: TransactionStateStatus.success,
          selectedTransaction: transaction,
        )),
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    if (!state.hasMoreData ||
        state.status == TransactionStateStatus.loadingMore) {
      return;
    }

    try {
      emit(state.copyWith(status: TransactionStateStatus.loadingMore));

      final nextPage = state.currentPage + 1;
      final result = await getTransactionsUseCase(
        GetTransactionsParams(
          walletId: event.walletId,
          page: nextPage,
          limit: 10,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: TransactionStateStatus.failure,
          failure: failure,
        )),
        (newTransactions) {
          final updatedTransactions = [
            ...state.transactions,
            ...newTransactions
          ];
          emit(state.copyWith(
            status: TransactionStateStatus.success,
            transactions: updatedTransactions,
            currentPage: nextPage,
            hasMoreData: newTransactions.length >= 10,
          ));
        },
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final result = await getTransactionsUseCase(
        GetTransactionsParams(
          walletId: event.walletId,
          page: 1,
          limit: 10,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: TransactionStateStatus.failure,
          failure: failure,
        )),
        (transactions) => emit(state.copyWith(
          status: TransactionStateStatus.success,
          transactions: transactions,
          currentPage: 1,
          hasMoreData: transactions.length >= 10,
        )),
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: TransactionStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }
}
