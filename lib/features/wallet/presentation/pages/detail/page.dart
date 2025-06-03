import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../wallet.dart';

class WalletDetailPage extends StatefulWidget {
  const WalletDetailPage({
    super.key,
    required this.walletId,
  });

  final String walletId;

  static const String routeName = '/wallet/detail';

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWalletByIdEvent(id: widget.walletId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.walletDetails),
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state.status == WalletStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.selectedWallet == null) {
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
                  SubTitleText(AppLocalizations.of(context)!.walletNotFound),
                ],
              ),
            );
          }

          final wallet = state.selectedWallet!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.dp16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Wallet Overview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.dp24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 48,
                          color: context.theme.primaryColor,
                        ),
                        Dimens.dp16.height,
                        HeadingText(wallet.currency.toUpperCase()),
                        Dimens.dp8.height,
                        Text(
                          CurrencyUtils.formatCurrency(
                              wallet.balance, wallet.currency),
                          style:
                              context.theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Dimens.dp24.height,

                // Wallet Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.dp16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubTitleText(
                            AppLocalizations.of(context)!.walletInformation),
                        Dimens.dp16.height,
                        _buildInfoRow(
                            AppLocalizations.of(context)!.walletId, wallet.id),
                        _buildInfoRow(AppLocalizations.of(context)!.currency,
                            wallet.currency.toUpperCase()),
                        _buildInfoRow(
                            AppLocalizations.of(context)!.balance,
                            CurrencyUtils.formatCurrency(
                                wallet.balance, wallet.currency)),
                        _buildInfoRow(
                          AppLocalizations.of(context)!.created,
                          DateFormatUtils.formatDate(wallet.createdAt),
                        ),
                        _buildInfoRow(
                          AppLocalizations.of(context)!.lastUpdated,
                          DateFormatUtils.formatDate(wallet.updatedAt),
                        ),
                      ],
                    ),
                  ),
                ),

                Dimens.dp24.height,

                // Transaction Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TransactionFormPage.routeName,
                            arguments: {
                              'walletId': widget.walletId,
                              'transactionType': TransactionType.deposit,
                            },
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: Text(AppLocalizations.of(context)!.deposit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Dimens.dp16.width,
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TransactionFormPage.routeName,
                            arguments: {
                              'walletId': widget.walletId,
                              'transactionType': TransactionType.withdrawal,
                            },
                          );
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        label: Text(AppLocalizations.of(context)!.withdraw),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                Dimens.dp16.height,

                // View Transactions Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        TransactionListPage.routeName,
                        arguments: widget.walletId,
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: Text(AppLocalizations.of(context)!.viewTransactions),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.dp8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegularText(label),
          RegularText(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
