import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetWalletByIdParams extends Equatable {
  const GetWalletByIdParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class GetWalletByIdUseCase
    implements UseCaseFuture<Failure, Wallet, GetWalletByIdParams> {
  GetWalletByIdUseCase(this.repository);

  final WalletRepository repository;

  @override
  Future<Either<Failure, Wallet>> call(GetWalletByIdParams params) async {
    return repository.getWalletById(params.id);
  }
}
