import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/entities.dart';

part 'transaction_model.g.dart';

/// Response model for transaction list API
@JsonSerializable()
class TransactionListResponse {
  final List<TransactionModel> transactions;
  final int total;
  final int page;
  final int limit;

  const TransactionListResponse({
    required this.transactions,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionListResponseToJson(this);
}

@JsonSerializable()
class TransactionModel {
  final String id;
  @JsonKey(name: 'walletId') // Will match walletId or wallet_id
  final String walletId;
  final String type;
  final double amount;
  final String? description;
  @JsonKey(name: 'referenceId') // Will match referenceId or reference_id
  final String? referenceId;
  @JsonKey(
      name: 'timestamp', defaultValue: '') // Will match timestamp or created_at
  final String timestamp;
  @JsonKey(
      name:
          'relatedTransactionId') // Will match relatedTransactionId or related_transaction_id
  final String? relatedTransactionId;

  const TransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.description,
    this.referenceId,
    required this.timestamp,
    this.relatedTransactionId,
  });

  // We're using the generated _$TransactionModelFromJson but also providing a custom
  // fromJson implementation that handles both camelCase and snake_case field names
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 Raw JSON for transaction: $json');

    // Handle different field naming conventions
    Map<String, dynamic> normalizedJson = Map<String, dynamic>.from(json);

    // If we have wallet_id instead of walletId
    if (json.containsKey('wallet_id') && !json.containsKey('walletId')) {
      debugPrint('✏️ Converting wallet_id -> walletId');
      normalizedJson['walletId'] = json['wallet_id'];
    }

    // If we have reference_id instead of referenceId
    if (json.containsKey('reference_id') && !json.containsKey('referenceId')) {
      debugPrint('✏️ Converting reference_id -> referenceId');
      normalizedJson['referenceId'] = json['reference_id'];
    }

    // If we have created_at or updated_at instead of timestamp
    if (!json.containsKey('timestamp')) {
      String timestampValue = json['created_at'] ??
          json['createdAt'] ??
          json['updated_at'] ??
          json['updatedAt'] ??
          DateTime.now().toIso8601String();
      debugPrint('✏️ Using $timestampValue as timestamp');
      normalizedJson['timestamp'] = timestampValue;
    }

    // If we have related_transaction_id instead of relatedTransactionId
    if (json.containsKey('related_transaction_id') &&
        !json.containsKey('relatedTransactionId')) {
      debugPrint(
          '✏️ Converting related_transaction_id -> relatedTransactionId');
      normalizedJson['relatedTransactionId'] = json['related_transaction_id'];
    }

    debugPrint(
        '🔄 Processing transaction: ${normalizedJson['id']} of type ${normalizedJson['type']}');

    try {
      return _$TransactionModelFromJson(normalizedJson);
    } catch (e) {
      debugPrint('❌ Error deserializing transaction: $e');
      debugPrint('❌ Normalized JSON: $normalizedJson');

      // Create a fallback transaction as a last resort
      return TransactionModel(
        id: normalizedJson['id']?.toString() ?? 'unknown',
        walletId: normalizedJson['walletId']?.toString() ??
            normalizedJson['wallet_id']?.toString() ??
            'unknown',
        type: normalizedJson['type']?.toString() ?? 'DEPOSIT',
        amount:
            double.tryParse(normalizedJson['amount']?.toString() ?? '0') ?? 0.0,
        description: normalizedJson['description']?.toString(),
        referenceId: normalizedJson['referenceId']?.toString() ??
            normalizedJson['reference_id']?.toString(),
        timestamp: normalizedJson['timestamp']?.toString() ??
            DateTime.now().toIso8601String(),
        relatedTransactionId:
            normalizedJson['relatedTransactionId']?.toString() ??
                normalizedJson['related_transaction_id']?.toString(),
      );
    }
  }

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  Transaction toEntity() {
    final DateTime parsedTimestamp = _parseDateTime(timestamp);

    return Transaction(
      id: id,
      walletId: walletId,
      type: _parseTransactionType(type),
      amount: amount,
      description: description,
      referenceId: referenceId,
      createdAt: parsedTimestamp,
      updatedAt: parsedTimestamp,
      relatedTransactionId: relatedTransactionId,
    );
  }

  // Note: We previously had a _parseDouble method here, but it's no longer needed
  // because JsonSerializable handles the conversion automatically

  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  static TransactionType _parseTransactionType(String type) {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return TransactionType.deposit;
      case 'WITHDRAWAL':
        return TransactionType.withdrawal;
      default:
        return TransactionType.deposit;
    }
  }
}
