part of '../page.dart';

class _WalletListSection extends StatelessWidget {
  const _WalletListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state.status == WalletStateStatus.loading &&
            state.wallets.isEmpty) {
          return _buildLoadingSkeleton(context);
        }

        if (state.wallets.isEmpty &&
            state.status != WalletStateStatus.loading) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.dp16),
              child: HeadingText(AppLocalizations.of(context)!.yourWallets),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: Dimens.dp16),
              itemCount: state.wallets.length,
              itemBuilder: (context, index) {
                final wallet = state.wallets[index];
                return WalletCard(
                  wallet: wallet,
                  onTap: () {
                    context.read<WalletBloc>().add(
                          GetWalletByIdEvent(id: wallet.id),
                        );
                    // Navigate to wallet detail page
                    Navigator.pushNamed(
                      context,
                      WalletDetailPage.routeName,
                      arguments: wallet.id,
                    );
                  },
                );
              },
            ),
            Dimens.dp32.height,
          ],
        );
      },
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return SkeletonAnimation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(Dimens.dp16),
            child: Skeleton(width: Dimens.dp150, height: Dimens.dp22),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: Dimens.dp16),
            itemCount: 3,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.symmetric(vertical: Dimens.dp8),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.dp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Skeleton(width: 60, height: 20),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.theme.disabledColor
                                .withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    Dimens.dp12.height,
                    const Skeleton(width: 120, height: 28),
                    Dimens.dp8.height,
                    const Skeleton(width: 140, height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.dp32),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: context.theme.hintColor,
            ),
            Dimens.dp16.height,
            SubTitleText(AppLocalizations.of(context)!.noWalletsYet),
            Dimens.dp8.height,
            RegularText(
              AppLocalizations.of(context)!.createFirstWalletToGetStarted,
              style: TextStyle(color: context.theme.hintColor),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
