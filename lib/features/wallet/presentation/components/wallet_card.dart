import 'package:flutter/material.dart';
import 'package:wallet_test/features/wallet/wallet.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.wallet,
    this.onTap,
  });

  final Wallet wallet;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: Dimens.dp8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.dp12),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.dp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubTitleText(wallet.currency.toUpperCase()),
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: context.theme.primaryColor,
                  ),
                ],
              ),
              Dimens.dp12.height,
              HeadingText(CurrencyUtils.formatCurrency(
                  wallet.balance, wallet.currency)),
              Dimens.dp8.height,
              RegularText(
                '${AppLocalizations.of(context)!.created}: ${DateFormatUtils.formatDate(wallet.createdAt)}',
                style: TextStyle(
                  color: context.theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
