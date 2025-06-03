import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import 'wallet.dart';

class WalletModule implements BaseModule {
  @override
  Future inject(GetIt getIt) async {
    // Data
    getIt
      ..registerLazySingleton<WalletApiSource>(
        () => WalletApiSourceImpl(getIt()),
      )
      ..registerLazySingleton<WalletRepository>(
        () => WalletRepositoryImpl(getIt()),
      )
      ..registerLazySingleton<TransactionApiSource>(
        () => TransactionApiSourceImpl(getIt()),
      )
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(getIt()),
      );

    // Domain
    getIt
      ..registerLazySingleton(() => GetWalletsUseCase(getIt()))
      ..registerLazySingleton(() => GetWalletByIdUseCase(getIt()))
      ..registerLazySingleton(() => CreateWalletUseCase(getIt()))
      ..registerLazySingleton(() => CreateDepositUseCase(getIt()))
      ..registerLazySingleton(() => CreateWithdrawalUseCase(getIt()))
      ..registerLazySingleton(() => GetTransactionsUseCase(getIt()))
      ..registerLazySingleton(() => GetTransactionByIdUseCase(getIt()));

    // Presentation
    getIt
      ..registerFactory(
        () => WalletBloc(
          getWalletsUseCase: getIt(),
          getWalletByIdUseCase: getIt(),
          createWalletUseCase: getIt(),
        ),
      )
      ..registerFactory(
        () => TransactionBloc(
          createDepositUseCase: getIt(),
          createWithdrawalUseCase: getIt(),
          getTransactionsUseCase: getIt(),
          getTransactionByIdUseCase: getIt(),
        ),
      );
  }

  @override
  Map<String, Route> routes(RouteSettings settings) {
    final args = settings.arguments;
    return {
      WalletDetailPage.routeName: CupertinoPageRoute(
        builder: (_) => WalletDetailPage(
          walletId: args is String
              ? args
              : args is Map
                  ? args['walletId'] ?? ''
                  : '',
        ),
        settings: settings,
      ),
      TransactionListPage.routeName: CupertinoPageRoute(
        builder: (_) => TransactionListPage(
          walletId: args is String
              ? args
              : args is Map
                  ? args['walletId'] ?? ''
                  : '',
        ),
        settings: settings,
      ),
      TransactionDetailPage.routeName: CupertinoPageRoute(
        builder: (_) => TransactionDetailPage(
          walletId: args is Map ? args['walletId'] ?? '' : '',
          transactionId: args is Map ? args['transactionId'] ?? '' : '',
        ),
        settings: settings,
      ),
      TransactionFormPage.routeName: CupertinoPageRoute(
        builder: (_) => TransactionFormPage(
          walletId: args is Map ? args['walletId'] ?? '' : '',
          transactionType: args is Map
              ? args['transactionType'] ?? TransactionType.deposit
              : TransactionType.deposit,
        ),
        settings: settings,
      ),
    };
  }
}
