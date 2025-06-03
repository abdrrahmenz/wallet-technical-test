import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/entities.dart';
import '../blocs/blocs.dart';

class TransactionFormWidget extends StatefulWidget {
  const TransactionFormWidget({
    super.key,
    required this.walletId,
    required this.transactionType,
    this.onTransactionCreated,
  });

  final String walletId;
  final TransactionType transactionType;
  final VoidCallback? onTransactionCreated;

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseEnterValidAmount),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final description = _descriptionController.text.trim();
      final reference = _referenceController.text.trim();

      if (widget.transactionType == TransactionType.deposit) {
        context.read<TransactionBloc>().add(
              CreateDepositEvent(
                walletId: widget.walletId,
                amount: amount,
                description: description.isEmpty ? null : description,
                referenceId: reference.isEmpty ? null : reference,
              ),
            );
      } else {
        context.read<TransactionBloc>().add(
              CreateWithdrawalEvent(
                walletId: widget.walletId,
                amount: amount,
                description: description.isEmpty ? null : description,
                referenceId: reference.isEmpty ? null : reference,
              ),
            );
      }
    }
  }

  String get _title => widget.transactionType == TransactionType.deposit
      ? AppLocalizations.of(context)!.depositMoney
      : AppLocalizations.of(context)!.withdrawMoney;

  String get _buttonText => widget.transactionType == TransactionType.deposit
      ? AppLocalizations.of(context)!.deposit
      : AppLocalizations.of(context)!.withdraw;

  Color get _buttonColor => widget.transactionType == TransactionType.deposit
      ? Colors.green
      : Colors.red;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state.status == TransactionStateStatus.success &&
            state.selectedTransaction != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.transactionType == TransactionType.deposit
                  ? AppLocalizations.of(context)!.depositSuccessful
                  : AppLocalizations.of(context)!.withdrawalSuccessful),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form
          _amountController.clear();
          _descriptionController.clear();
          _referenceController.clear();
          // Call callback
          widget.onTransactionCreated?.call();
        } else if (state.status == TransactionStateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure?.message ??
                  AppLocalizations.of(context)!.transactionFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _buttonColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.amount,
                    hintText: AppLocalizations.of(context)!.enterAmount,
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterAmount;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                    decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.descriptionOptional,
                    hintText: AppLocalizations.of(context)!.enterDescription,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.referenceIdOptional,
                    hintText: AppLocalizations.of(context)!.enterReferenceId,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    final isLoading =
                        state.status == TransactionStateStatus.creating;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _buttonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
