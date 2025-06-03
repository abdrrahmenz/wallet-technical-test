import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../wallet.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({
    super.key,
    required this.walletId,
  });

  final String walletId;

  static const String routeName = '/wallet/transactions';

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  void initState() {
    super.initState();
    // Load transactions when page initializes
    context.read<TransactionBloc>().add(
          GetTransactionsEvent(walletId: widget.walletId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactions),
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
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
        child: TransactionListWidget(
          walletId: widget.walletId,
          onTransactionTap: (transaction) {
            Navigator.pushNamed(
              context,
              TransactionDetailPage.routeName,
              arguments: {
                'walletId': widget.walletId,
                'transactionId': transaction.id,
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionTypeBottomSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToTransactionForm(TransactionType type) {
    Navigator.pushReplacementNamed(
      context,
      TransactionFormPage.routeName,
      arguments: {
        'walletId': widget.walletId,
        'transactionType': type,
      },
    );
  }

  void _showTransactionTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(Dimens.dp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingText(AppLocalizations.of(context)!.newTransaction),
            Dimens.dp24.height,
            ListTile(
              leading:
                  const Icon(Icons.add_circle_outline, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.deposit),
              subtitle: Text(AppLocalizations.of(context)!.addMoneyToWallet),
              onTap: () {
                Navigator.pop(context);
                _navigateToTransactionForm(TransactionType.deposit);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.remove_circle_outline, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.withdrawal),
              subtitle:
                  Text(AppLocalizations.of(context)!.withdrawMoneyFromWallet),
              onTap: () {
                Navigator.pop(context);
                _navigateToTransactionForm(TransactionType.withdrawal);
              },
            ),
            Dimens.dp16.height,
          ],
        ),
      ),
    );
  }
}
