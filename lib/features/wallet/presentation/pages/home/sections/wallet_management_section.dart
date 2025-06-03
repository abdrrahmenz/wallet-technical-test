part of '../page.dart';

class _WalletManagementSection extends StatelessWidget {
  const _WalletManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Dimens.dp16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.dp20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Dimens.dp12),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimens.dp12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: context.theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  Dimens.dp16.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubTitleText(
                            AppLocalizations.of(context)!.manageDigitalWallets),
                        Dimens.dp4.height,
                        RegularText(
                          AppLocalizations.of(context)!.viewEditOrganizeWallets,
                          style: TextStyle(
                            color: context.theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.theme.hintColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
