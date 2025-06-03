part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class GetWalletsEvent extends WalletEvent {
  const GetWalletsEvent();
}

class GetWalletByIdEvent extends WalletEvent {
  const GetWalletByIdEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class CreateWalletEvent extends WalletEvent {
  const CreateWalletEvent({
    this.currency,
    this.initialBalance,
  });

  final String? currency;
  final double? initialBalance;

  @override
  List<Object?> get props => [currency, initialBalance];
}
