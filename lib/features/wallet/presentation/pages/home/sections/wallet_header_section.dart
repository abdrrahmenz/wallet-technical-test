part of '../page.dart';

class _WalletHeaderSection extends StatelessWidget {
  const _WalletHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.dp16,
        right: Dimens.dp16,
        top: MediaQuery.of(context).padding.top + Dimens.dp16,
        bottom: Dimens.dp16,
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadingText(AppLocalizations.of(context)!.helloUser),
                    RegularText(
                        '@${state.user?.username ?? AppLocalizations.of(context)!.username}'),
                  ],
                ),
              ),
              SmartNetworkImage(
                state.user?.image ?? AppConfig.profileUrl,
                width: 54,
                height: 54,
                radius: BorderRadius.circular(Dimens.dp100),
                fit: BoxFit.cover,
              ),
            ],
          );
        },
      ),
    );
  }
}
