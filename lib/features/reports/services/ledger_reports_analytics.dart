import 'package:intl/intl.dart';

import '../../../core/constants/app_text.dart';
import '../../ledger/models/ledger_item.dart';
import '../models/reports_chart_data.dart';

abstract final class LedgerReportsAnalytics {
  static ReportsSnapshot build({
    required List<LedgerItem> ledgers,
    required ReportsPeriod period,
  }) {
    final buckets = <String, ({DateTime start, double income, double expense})>{};

    var totalIncome = 0.0;
    var totalExpense = 0.0;

    for (final ledger in ledgers) {
      final config = ledger.config;
      for (final entry in ledger.entries) {
        final key = _bucketKey(entry.createdAt, period);
        final start = _bucketStart(entry.createdAt, period);
        buckets.putIfAbsent(
          key,
          () => (start: start, income: 0.0, expense: 0.0),
        );

        final current = buckets[key]!;
        if (config.creditTypes.contains(entry.type)) {
          buckets[key] = (
            start: current.start,
            income: current.income + entry.amount,
            expense: current.expense,
          );
          totalIncome += entry.amount;
        } else if (config.debitTypes.contains(entry.type)) {
          buckets[key] = (
            start: current.start,
            income: current.income,
            expense: current.expense + entry.amount,
          );
          totalExpense += entry.amount;
        }
      }
    }

    final sortedKeys = buckets.keys.toList()
      ..sort((a, b) => buckets[a]!.start.compareTo(buckets[b]!.start));

    var plPoints = sortedKeys
        .map((key) {
          final bucket = buckets[key]!;
          return PeriodPlPoint(
            label: _labelFor(bucket.start, period),
            periodStart: bucket.start,
            income: bucket.income,
            expense: bucket.expense,
          );
        })
        .toList();

    if (plPoints.isEmpty) {
      plPoints.addAll(_emptyPeriodPoints(period));
    } else if (period == ReportsPeriod.daily) {
      plPoints.sort((a, b) => a.periodStart.compareTo(b.periodStart));
      while (plPoints.length < 7) {
        final first = plPoints.first.periodStart;
        final previous = first.subtract(const Duration(days: 1));
        plPoints.insert(
          0,
          PeriodPlPoint(
            label: _labelFor(previous, period),
            periodStart: previous,
            income: 0,
            expense: 0,
          ),
        );
      }
      if (plPoints.length > 7) {
        plPoints.removeRange(0, plPoints.length - 7);
      }
    }

    final partyRoles = _partyRoleSlices(ledgers);

    return ReportsSnapshot(
      plPoints: plPoints,
      partyRoles: partyRoles,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netPl: totalIncome - totalExpense,
    );
  }

  static List<PartyRoleSlice> _partyRoleSlices(List<LedgerItem> ledgers) {
    var customerTotal = 0.0;
    var supplierTotal = 0.0;

    for (final ledger in ledgers) {
      if (!ledger.config.supportsSubLedgers) continue;
      for (final party in ledger.partyBalances) {
        if (party.balance > 0) {
          customerTotal += party.balance;
        } else if (party.balance < 0) {
          supplierTotal += party.balance.abs();
        }
      }
    }

    return [
      PartyRoleSlice(role: AppText.reportsCustomerRole, amount: customerTotal),
      PartyRoleSlice(role: AppText.reportsSupplierRole, amount: supplierTotal),
    ];
  }

  static List<PeriodPlPoint> _emptyPeriodPoints(ReportsPeriod period) {
    final now = DateTime.now();
    if (period == ReportsPeriod.monthly) {
      return List.generate(6, (index) {
        final month = DateTime(now.year, now.month - (5 - index), 1);
        return PeriodPlPoint(
          label: _labelFor(month, period),
          periodStart: month,
          income: 0,
          expense: 0,
        );
      });
    }

    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day - (6 - index));
      return PeriodPlPoint(
        label: _labelFor(day, period),
        periodStart: day,
        income: 0,
        expense: 0,
      );
    });
  }

  static String _bucketKey(DateTime date, ReportsPeriod period) {
    final start = _bucketStart(date, period);
    return '${start.year}-${start.month}-${start.day}';
  }

  static DateTime _bucketStart(DateTime date, ReportsPeriod period) {
    if (period == ReportsPeriod.monthly) {
      return DateTime(date.year, date.month, 1);
    }
    return DateTime(date.year, date.month, date.day);
  }

  static String _labelFor(DateTime date, ReportsPeriod period) {
    if (period == ReportsPeriod.monthly) {
      return DateFormat('MMM').format(date);
    }
    return DateFormat('E').format(date);
  }
}
