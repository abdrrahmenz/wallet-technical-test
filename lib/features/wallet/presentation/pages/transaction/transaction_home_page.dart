import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wallet_test/features/home/presentation/pages/pages.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../wallet.dart';

class TransactionHomePage extends StatefulWidget {
  const TransactionHomePage({super.key});

  @override
  State<TransactionHomePage> createState() => _TransactionHomePageState();
}

class _TransactionHomePageState extends State<TransactionHomePage> {
  String? selectedWalletId;

  @override
  void initState() {
    super.initState();
    // Load wallets to show in selection
    context.read<WalletBloc>().add(const GetWalletsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactions),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, walletState) {
          if (walletState.status == WalletStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (walletState.wallets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: context.theme.hintColor,
                  ),
                  Dimens.dp16.height,
                  SubTitleText(AppLocalizations.of(context)!.noWalletsFound),
                  Dimens.dp8.height,
                  Text(
                    AppLocalizations.of(context)!.createWalletFirst,
                    textAlign: TextAlign.center,
                  ),
                  Dimens.dp24.height,
                    ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to wallet creation or home page
                      Navigator.pushNamedAndRemoveUntil(
                      context,
                      MainPage.routeName,
                      (route) => false,
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.createWallet),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Wallet Selection Card
                Container(
                  margin: const EdgeInsets.all(Dimens.dp16),
                  padding: const EdgeInsets.all(Dimens.dp16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleText(AppLocalizations.of(context)!.selectWallet),
                      Dimens.dp12.height,
                      DropdownButtonFormField<String>(
                        value: selectedWalletId,
                        hint: Text(AppLocalizations.of(context)!.chooseWallet),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: walletState.wallets.map((wallet) {
                          return DropdownMenuItem<String>(
                            value: wallet.id,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 20,
                                  color: context.theme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        wallet.currency.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        CurrencyUtils.formatCurrency(
                                          wallet.balance,
                                          wallet.currency,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: context.theme.hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          debugPrint('🔄 Wallet selected: $value');
                          setState(() {
                            selectedWalletId = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Transaction List or Empty State
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      220, // Adjust height as needed
                  child: selectedWalletId == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: context.theme.hintColor,
                              ),
                              Dimens.dp16.height,
                              SubTitleText(
                                  AppLocalizations.of(context)!.selectAWallet),
                              Dimens.dp8.height,
                              Text(
                                AppLocalizations.of(context)!.chooseWallet,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : BlocProvider(
                          create: (context) {
                            debugPrint(
                                '🔄 Creating TransactionBloc for wallet: $selectedWalletId');
                            final bloc = GetIt.instance<TransactionBloc>();
                            debugPrint('🔄 Dispatching GetTransactionsEvent');
                            bloc.add(GetTransactionsEvent(
                                walletId: selectedWalletId!));
                            return bloc;
                          },
                          child: TransactionListWidget(
                            walletId: selectedWalletId!,
                            onTransactionTap: (transaction) {
                              debugPrint(
                                  '🔄 Transaction tapped: ${transaction.id}');
                              Navigator.pushNamed(
                                context,
                                TransactionDetailPage.routeName,
                                arguments: {
                                  'walletId': selectedWalletId!,
                                  'transactionId': transaction.id,
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: selectedWalletId != null
          ? FloatingActionButton(
              onPressed: () => _showTransactionTypeBottomSheet(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showTransactionTypeBottomSheet() {
    if (selectedWalletId == null) return;

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
                Navigator.pushNamed(
                  context,
                  TransactionFormPage.routeName,
                  arguments: {
                    'walletId': selectedWalletId!,
                    'transactionType': TransactionType.deposit,
                  },
                );
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
                Navigator.pushNamed(
                  context,
                  TransactionFormPage.routeName,
                  arguments: {
                    'walletId': selectedWalletId!,
                    'transactionType': TransactionType.withdrawal,
                  },
                );
              },
            ),
            Dimens.dp16.height,
          ],
        ),
      ),
    );
  }
}
