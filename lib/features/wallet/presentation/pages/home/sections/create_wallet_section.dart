part of '../page.dart';

class _CreateWalletSection extends StatefulWidget {
  const _CreateWalletSection({super.key});

  @override
  State<_CreateWalletSection> createState() => _CreateWalletSectionState();
}

class _CreateWalletSectionState extends State<_CreateWalletSection> {
  final _currencyController = TextEditingController();
  final _balanceController = TextEditingController();

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'IDR'];
  String _selectedCurrency = 'USD';

  String _getLocalizedCurrencyName(BuildContext context, String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return AppLocalizations.of(context)!.usdCurrency;
      case 'EUR':
        return AppLocalizations.of(context)!.eurCurrency;
      case 'GBP':
        return AppLocalizations.of(context)!.gbpCurrency;
      case 'JPY':
        return AppLocalizations.of(context)!.jpyCurrency;
      case 'IDR':
        return AppLocalizations.of(context)!.idrCurrency;
      default:
        return currencyCode;
    }
  }

  @override
  void dispose() {
    _currencyController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Dimens.dp16),
      padding: const EdgeInsets.all(Dimens.dp16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(Dimens.dp16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubTitleText(AppLocalizations.of(context)!.createNewWallet),
          Dimens.dp16.height,
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.currency,
              border: const OutlineInputBorder(),
            ),
            items: _currencies.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text(_getLocalizedCurrencyName(context, currency)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCurrency = value;
                });
              }
            },
          ),
          Dimens.dp16.height,
          TextFormField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.initialBalanceOptional,
              border: const OutlineInputBorder(),
              prefixText:
                  '${CurrencyUtils.getCurrencySymbol(_selectedCurrency)} ',
            ),
          ),
          Dimens.dp16.height,
          ElevatedButton(
            onPressed: () {
              final balance = double.tryParse(_balanceController.text);
              context.read<WalletBloc>().add(
                    CreateWalletEvent(
                      currency: _selectedCurrency,
                      initialBalance: balance,
                    ),
                  );

              // Clear form after submission
              _balanceController.clear();
            },
            child: Text(AppLocalizations.of(context)!.createWallet),
          ),
        ],
      ),
    );
  }
}
