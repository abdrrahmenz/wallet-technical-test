import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../wallet.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({
    super.key,
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;

  static const String routeName = '/wallet/transaction/detail';

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load transaction details when page initializes
    context.read<TransactionBloc>().add(
          GetTransactionByIdEvent(
            walletId: widget.walletId,
            transactionId: widget.transactionId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactionDetails),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              // Refresh transaction details
              context.read<TransactionBloc>().add(
                    GetTransactionByIdEvent(
                      walletId: widget.walletId,
                      transactionId: widget.transactionId,
                    ),
                  );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.status == TransactionStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.selectedTransaction == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.theme.hintColor,
                  ),
                  Dimens.dp16.height,
                  SubTitleText(
                      AppLocalizations.of(context)!.transactionNotFound),
                  Dimens.dp16.height,
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.goBack),
                  ),
                ],
              ),
            );
          }

          return BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state.failure != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failure!.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimens.dp16),
              child: TransactionDetailWidget(
                transaction: state.selectedTransaction!,
              ),
            ),
          );
        },
      ),
    );
  }
}
