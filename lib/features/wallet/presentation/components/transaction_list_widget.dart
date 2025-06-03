import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/entities.dart';
import '../blocs/blocs.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({
    super.key,
    required this.walletId,
    this.onTransactionTap,
  });

  final String walletId;
  final void Function(Transaction transaction)? onTransactionTap;

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load transactions on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionBloc>().add(
            GetTransactionsEvent(walletId: widget.walletId),
          );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TransactionBloc>().state;
      if (state.hasMoreData &&
          state.status != TransactionStateStatus.loadingMore) {
        context.read<TransactionBloc>().add(
              LoadMoreTransactionsEvent(walletId: widget.walletId),
            );
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<TransactionBloc>().add(
          RefreshTransactionsEvent(walletId: widget.walletId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        debugPrint('⚡ TransactionListWidget build with state: ${state.status}');
        debugPrint('⚡ Transactions count: ${state.transactions.length}');

        if (state.status == TransactionStateStatus.loading) {
          debugPrint('🔄 Showing loading indicator');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == TransactionStateStatus.failure) {
          debugPrint('❌ Showing error state: ${state.failure?.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  state.failure?.message ??
                      AppLocalizations.of(context)!.failedToLoadTransactions,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TransactionBloc>().add(
                          GetTransactionsEvent(walletId: widget.walletId),
                        );
                  },
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        }

        if (state.transactions.isEmpty) {
          debugPrint('📭 Showing empty state');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noTransactionsYet,
                  style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.transactionsWillAppearHere,
                  style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onRefresh,
                  child: Text(AppLocalizations.of(context)!.refresh),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.transactions.length +
                (state.status == TransactionStateStatus.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.transactions.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final transaction = state.transactions[index];
              return _TransactionItem(
                transaction: transaction,
                onTap: () => widget.onTransactionTap?.call(transaction),
              );
            },
          ),
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.transaction,
    this.onTap,
  });

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    try {
      final isDeposit = transaction.type == TransactionType.deposit;
      final color = isDeposit ? Colors.green : Colors.red;
      final icon = isDeposit ? Icons.add_circle : Icons.remove_circle;
      final prefix = isDeposit ? '+' : '-';

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          title: Text(
            '$prefix\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show transaction ID as fallback if no description
              Text(
                transaction.description?.isNotEmpty == true
                  ? transaction.description!
                  : "${AppLocalizations.of(context)!.transaction} ${transaction.id.substring(0, min(8, transaction.id.length))}...",
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm')
                    .format(transaction.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (transaction.referenceId != null &&
                  transaction.referenceId!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Ref: ${transaction.referenceId!}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error rendering transaction item: $e');
      // Fallback rendering
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: onTap,
          title: Text('${AppLocalizations.of(context)!.transaction} ${transaction.id}'),
          subtitle: Text(AppLocalizations.of(context)!.errorRenderingTransactionDetails),
        ),
      );
    }
  }
}
