import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';
import '../../../domain/domain.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required this.getWalletsUseCase,
    required this.getWalletByIdUseCase,
    required this.createWalletUseCase,
  }) : super(const WalletState()) {
    on<GetWalletsEvent>(_onGetWallets);
    on<GetWalletByIdEvent>(_onGetWalletById);
    on<CreateWalletEvent>(_onCreateWallet);
  }

  final GetWalletsUseCase getWalletsUseCase;
  final GetWalletByIdUseCase getWalletByIdUseCase;
  final CreateWalletUseCase createWalletUseCase;

  Future<void> _onGetWallets(
    GetWalletsEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      emit(state.copyWith(status: WalletStateStatus.loading));

      final result = await getWalletsUseCase(const NoParams());

      result.fold(
        (failure) => emit(state.copyWith(
          status: WalletStateStatus.failure,
          failure: failure,
        )),
        (wallets) => emit(state.copyWith(
          status: WalletStateStatus.success,
          wallets: wallets,
        )),
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: WalletStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onGetWalletById(
    GetWalletByIdEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      emit(state.copyWith(status: WalletStateStatus.loading));

      final result = await getWalletByIdUseCase(
        GetWalletByIdParams(id: event.id),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: WalletStateStatus.failure,
          failure: failure,
        )),
        (wallet) => emit(state.copyWith(
          status: WalletStateStatus.success,
          selectedWallet: wallet,
        )),
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: WalletStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }

  Future<void> _onCreateWallet(
    CreateWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      emit(state.copyWith(status: WalletStateStatus.loading));

      final result = await createWalletUseCase(
        CreateWalletParams(
          currency: event.currency,
          initialBalance: event.initialBalance,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: WalletStateStatus.failure,
          failure: failure,
        )),
        (wallet) {
          // Add the new wallet to the existing list
          final updatedWallets = List<Wallet>.from(state.wallets)..add(wallet);
          emit(state.copyWith(
            status: WalletStateStatus.success,
            wallets: updatedWallets,
            selectedWallet: wallet,
          ));
        },
      );
    } catch (exception, stackTrace) {
      exception.recordError(
        RecordErrorParams(exception: exception, stackTrace: stackTrace),
      );
      emit(state.copyWith(
        status: WalletStateStatus.failure,
        failure: const ServerFailure(message: 'Something went wrong'),
      ));
    }
  }
}
