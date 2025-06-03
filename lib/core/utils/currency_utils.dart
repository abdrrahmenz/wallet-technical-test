import 'package:intl/intl.dart';

class CurrencyUtils {
  /// Get currency symbol for a given currency code
  static String getCurrencySymbol(String currencyCode) {
    try {
      final format =
          NumberFormat.simpleCurrency(name: currencyCode.toUpperCase());
      return format.currencySymbol;
    } catch (e) {
      // Fallback to default symbols for common currencies
      switch (currencyCode.toUpperCase()) {
        case 'USD':
          return '\$';
        case 'EUR':
          return '€';
        case 'GBP':
          return '£';
        case 'JPY':
          return '¥';
        case 'IDR':
          return 'Rp';
        default:
          return currencyCode.toUpperCase();
      }
    }
  }

  /// Format currency with proper symbol and amount
  static String formatCurrency(double amount, String currencyCode) {
    try {
      final format = NumberFormat.simpleCurrency(
        name: currencyCode.toUpperCase(),
        decimalDigits: 2,
      );
      return format.format(amount);
    } catch (e) {
      // Fallback formatting
      final symbol = getCurrencySymbol(currencyCode);
      return '$symbol${amount.toStringAsFixed(2)}';
    }
  }
}
