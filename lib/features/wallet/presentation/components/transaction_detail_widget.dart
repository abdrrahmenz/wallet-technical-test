import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/entities.dart';

class TransactionDetailWidget extends StatelessWidget {
  const TransactionDetailWidget({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('$label ${AppLocalizations.of(context)!.copiedToClipboard}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == TransactionType.deposit;
    final color = isDeposit ? Colors.green : Colors.red;
    final icon = isDeposit ? Icons.add_circle : Icons.remove_circle;
    final prefix = isDeposit ? '+' : '-';
    final typeText = isDeposit
        ? AppLocalizations.of(context)!.deposit
        : AppLocalizations.of(context)!.withdrawal;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  radius: 24,
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$prefix\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        typeText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // _StatusChip(status: transaction.status),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Details
            _DetailRow(
              label: AppLocalizations.of(context)!.transactionId,
              value: transaction.id,
              onTap: () => _copyToClipboard(context, transaction.id,
                  AppLocalizations.of(context)!.transactionId),
            ),
            _DetailRow(
              label: AppLocalizations.of(context)!.walletId,
              value: transaction.walletId,
              onTap: () => _copyToClipboard(context, transaction.walletId,
                  AppLocalizations.of(context)!.walletId),
            ),
            if (transaction.description != null &&
                transaction.description!.isNotEmpty)
              _DetailRow(
                label: AppLocalizations.of(context)!.description,
                value: transaction.description!,
              ),
            if (transaction.referenceId != null &&
                transaction.referenceId!.isNotEmpty)
              _DetailRow(
                label: AppLocalizations.of(context)!.referenceId,
                value: transaction.referenceId!,
                onTap: () => _copyToClipboard(context, transaction.referenceId!,
                    AppLocalizations.of(context)!.referenceId),
              ),
            _DetailRow(
              label: AppLocalizations.of(context)!.createdAt,
              value: DateFormat('MMM dd, yyyy • HH:mm:ss')
                  .format(transaction.createdAt),
            ),
            if (transaction.updatedAt != transaction.createdAt)
              _DetailRow(
                label: AppLocalizations.of(context)!.updatedAt,
                value: DateFormat('MMM dd, yyyy • HH:mm:ss')
                    .format(transaction.updatedAt),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
