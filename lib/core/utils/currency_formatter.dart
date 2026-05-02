import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  // TODO: make currency code dynamic per user settings.
  static String getActiveCurrencyCode() => 'PKR';

  static String formatSync(double amount) {
    return NumberFormat.currency(
      locale: 'en_PK',
      symbol: '',
      decimalDigits: 0,
    ).format(amount).trim();
  }

  static String format(double amount) {
    return '${getActiveCurrencyCode()} ${formatSync(amount)}';
  }
}
