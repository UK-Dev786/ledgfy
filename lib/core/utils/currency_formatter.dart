import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  // TODO: make currency code dynamic per user settings.
  static String getActiveCurrencyCode() => 'PKR';

  static const int _oneLac = 100000;
  static const int _tenLac = 1000000;
  static const int _oneCrore = 10000000;

  static String formatSync(double amount) {
    return NumberFormat.currency(
      locale: 'en_PK',
      symbol: '',
      decimalDigits: 0,
    ).format(amount).trim();
  }

  static String format(double amount, {bool abbreviate = false}) {
    if (abbreviate) return formatReadable(amount);
    return '${getActiveCurrencyCode()} ${formatSync(amount)}';
  }

  /// Short labels for list cards only — full number below 10 Lac,
  /// then "X Lac" / "X Crore" with spelled-out words.
  static String formatReadable(double amount) {
    final code = getActiveCurrencyCode();
    final sign = amount < 0 ? '-' : '';
    final abs = amount.abs();

    if (abs >= _oneCrore) {
      final crore = abs / _oneCrore;
      return '$code $sign${_readableUnit(crore)} Crore';
    }

    if (abs >= _tenLac) {
      final lac = abs / _oneLac;
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
