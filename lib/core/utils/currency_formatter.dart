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

  static String format(double amount, {bool compact = false}) {
    if (compact) return formatReadable(amount);
    return '${getActiveCurrencyCode()} ${formatSync(amount)}';
  }

  /// Readable short form for tight UI — full number below 1 Lac,
  /// then "X Lac" / "X Crore" (Pakistani style, no cryptic M/L letters).
  static String formatReadable(double amount) {
    final code = getActiveCurrencyCode();
    final sign = amount < 0 ? '-' : '';
    final abs = amount.abs();

    // 1 Crore = 10,000,000
    if (abs >= 10000000) {
      final crore = abs / 10000000;
      return '$code $sign${_readableUnit(crore)} Crore';
    }

    // 1 Lac = 100,000
    if (abs >= 100000) {
      final lac = abs / 100000;
      return '$code $sign${_readableUnit(lac)} Lac';
    }

    return format(amount);
  }

  static String _readableUnit(double value) {
    if (value >= 100) return value.round().toString();

    final rounded = (value * 100).round() / 100;
    if (rounded == rounded.roundToDouble()) {
      return rounded.toInt().toString();
    }

    final text = rounded.toStringAsFixed(2);
    if (text.endsWith('0')) {
      return rounded.toStringAsFixed(1);
    }
    return text;
  }
}
