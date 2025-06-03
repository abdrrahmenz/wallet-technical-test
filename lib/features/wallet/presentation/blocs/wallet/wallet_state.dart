part of 'wallet_bloc.dart';

enum WalletStateStatus {
  initial,
  loading,
  success,
  failure,
}

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStateStatus.initial,
    this.wallets = const [],
    this.selectedWallet,
    this.failure,
  });

  final WalletStateStatus status;
  final List<Wallet> wallets;
  final Wallet? selectedWallet;
  final Failure? failure;

  WalletState copyWith({
    WalletStateStatus? status,
    List<Wallet>? wallets,
    Wallet? selectedWallet,
    Failure? failure,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      selectedWallet: selectedWallet ?? this.selectedWallet,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, wallets, selectedWallet, failure];
}
