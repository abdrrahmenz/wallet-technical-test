import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../settings/settings.dart';
import '../../../../wallet/wallet.dart';
import '../../../home.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> pages = [
    const WalletHomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, int>(
      builder: (context, index) {
        return Scaffold(
          body: pages[index],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimens.dp16),
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: (v) {
                context.read<BottomNavBloc>().add(BottomNavChanged(v));
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                  label: AppLocalizations.of(context)!.wallet,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  label: AppLocalizations.of(context)!.settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
