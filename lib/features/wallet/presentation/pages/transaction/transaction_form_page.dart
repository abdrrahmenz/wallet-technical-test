import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../wallet.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    super.key,
    required this.walletId,
    required this.transactionType,
  });

  final String walletId;
  final TransactionType transactionType;

  static const String routeName = '/wallet/transaction/form';

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  @override
  Widget build(BuildContext context) {
    final isDeposit = widget.transactionType == TransactionType.deposit;

    return Scaffold(
      appBar: AppBar(
        title: Text(isDeposit
            ? AppLocalizations.of(context)!.depositMoney
            : AppLocalizations.of(context)!.withdrawMoney),
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          // Only handle navigation, let TransactionFormWidget handle snackbars
          if (state.status == TransactionStateStatus.success &&
              state.selectedTransaction != null) {
            // Check if this is a newly created transaction
            final now = DateTime.now();
            final transactionTime = state.selectedTransaction!.createdAt;
            final timeDifference = now.difference(transactionTime).inSeconds;

            // If transaction was created within the last 10 seconds, consider it new
            if (timeDifference <= 10 && context.mounted) {
              // Navigate back to transaction list after a short delay to allow snackbar to show
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    TransactionListPage.routeName,
                    arguments: widget.walletId,
                  );
                }
              });
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.dp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.dp16),
                  child: Column(
                    children: [
                      Icon(
                        isDeposit
                            ? Icons.add_circle_outline
                            : Icons.remove_circle_outline,
                        size: 48,
                        color: isDeposit ? Colors.green : Colors.red,
                      ),
                      Dimens.dp16.height,
                      HeadingText(
                        isDeposit
                            ? AppLocalizations.of(context)!.depositFunds
                            : AppLocalizations.of(context)!.withdrawFunds,
                      ),
                      Dimens.dp8.height,
                      RegularText(
                        isDeposit
                            ? AppLocalizations.of(context)!.addMoneySecurely
                            : AppLocalizations.of(context)!
                                .withdrawMoneyFromWallet,
                        align: TextAlign.center,
                        style: TextStyle(
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Dimens.dp24.height,

              // Transaction Form
              TransactionFormWidget(
                walletId: widget.walletId,
                transactionType: widget.transactionType,
              ),

              Dimens.dp24.height,

              // Loading indicator
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state.status == TransactionStateStatus.loading ||
                      state.status == TransactionStateStatus.creating) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.dp24),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: Dimens.dp16),
                            Text(AppLocalizations.of(context)!
                                .processingTransaction),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Dimens.dp24.height,

              // Safety Note
              Card(
                color: context.theme.cardColor.withValues(alpha: 0.7),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.dp16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            size: 20,
                            color: context.theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.securityNote,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Dimens.dp8.height,
                      Text(
                        isDeposit
                            ? AppLocalizations.of(context)!.depositSecurityNote
                            : AppLocalizations.of(context)!
                                .withdrawalSecurityNote,
                        style: TextStyle(
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
