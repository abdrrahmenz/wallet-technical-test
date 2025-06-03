import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallet_test/app/config.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../wallet.dart';

part 'sections/wallet_header_section.dart';
part 'sections/wallet_list_section.dart';
part 'sections/create_wallet_section.dart';
part 'sections/wallet_management_section.dart';

class WalletHomePage extends StatefulWidget {
  const WalletHomePage({super.key});

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  @override
  void initState() {
    super.initState();
    // Load wallets when page initializes
    context.read<WalletBloc>().add(const GetWalletsEvent());
  }


  Future<void> _onRefresh() async {
    context.read<WalletBloc>().add(const GetWalletsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.status == WalletStateStatus.failure) {
          EasyLoading.showError(
            state.failure?.message ??
                AppLocalizations.of(context)!.somethingWentWrong,
          );
        } else if (state.status == WalletStateStatus.loading) {
          EasyLoading.show(status: AppLocalizations.of(context)!.loading);
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          elevation: 0,
          toolbarHeight: 0, // Hide the default app bar content
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _WalletHeaderSection(key: widget.key),
              _WalletManagementSection(key: widget.key),
              _CreateWalletSection(key: widget.key),
              _WalletListSection(key: widget.key),
            ],
          ),
        ),
      ),
    );
  }
}
