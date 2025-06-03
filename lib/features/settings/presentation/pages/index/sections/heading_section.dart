part of '../page.dart';

class _HeadingSection extends StatefulWidget {
  const _HeadingSection({super.key});

  @override
  State<_HeadingSection> createState() => _HeadingSectionState();
}

class _HeadingSectionState extends State<_HeadingSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Row(
          children: [
            SmartNetworkImage(
              state.user?.image ?? AppConfig.profileUrl,
              width: 64,
              height: 64,
              radius: BorderRadius.circular(Dimens.dp100),
              fit: BoxFit.cover,
            ),
            Dimens.dp12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingText('${l10n.hello}, ${state.user?.name}'),
                  RegularText('@${state.user?.username}'),
                ],
              ),
            ),
            Dimens.dp12.width,
            GestureDetector(
              onTap: () {
                showConfirm();
              },
              child: Icon(
                Icons.logout,
                color: context.theme.colorScheme.error,
              ),
            ),
          ],
        );
      },
    );
  }

  void showConfirm() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(Dimens.dp16),
          backgroundColor: context.theme.scaffoldBackgroundColor,
          surfaceTintColor: context.theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.dp16),
          ),
          title: SubTitleText(
            l10n.confirmSignOut,
            align: TextAlign.center,
          ),
          content: RegularText.normalSolid(
            context,
            l10n.signOutDescription,
            align: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ButtonActionConfirm(
              onCancel: () {
                Navigator.pop(context);
              },
              onConfirm: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
