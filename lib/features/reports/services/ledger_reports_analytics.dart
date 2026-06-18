import 'package:intl/intl.dart';

import '../../../core/constants/app_text.dart';
import '../../ledger/models/ledger_item.dart';
import '../models/reports_chart_data.dart';

abstract final class LedgerReportsAnalytics {
  static ReportsSnapshot build({
    required List<LedgerItem> ledgers,
    required ReportsPeriod period,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final range = _rangeFor(period, reference);
    final buckets = _emptyBuckets(period, range, reference);

    var totalIncome = 0.0;
    var totalExpense = 0.0;

    for (final ledger in ledgers) {
      final config = ledger.config;
      for (final entry in ledger.entries) {
        final when = entry.occurredAt;
        if (!range.contains(when)) continue;

        final index = _bucketIndex(when, period, range);
        if (index == null || index < 0 || index >= buckets.length) continue;

        final current = buckets[index];
        if (config.creditTypes.contains(entry.type)) {
          buckets[index] = current.copyWith(
            income: current.income + entry.amount,
          );
          totalIncome += entry.amount;
        } else if (config.debitTypes.contains(entry.type)) {
          buckets[index] = current.copyWith(
            expense: current.expense + entry.amount,
          );
          totalExpense += entry.amount;
        }
      }
    }

    return ReportsSnapshot(
      period: period,
      plPoints: buckets,
      partyRoles: _partyRoleSlices(ledgers),
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netPl: totalIncome - totalExpense,
    );
  }

  static DateTime _localDate(DateTime date) {
    final local = date.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static ReportsDateRange _rangeFor(ReportsPeriod period, DateTime now) {
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekday = now.weekday;
    final thisMonday = todayStart.subtract(Duration(days: weekday - DateTime.monday));

    return switch (period) {
      ReportsPeriod.today => ReportsDateRange(
          start: todayStart,
          end: todayStart.add(const Duration(days: 1)),
        ),
      ReportsPeriod.thisWeek => ReportsDateRange(
          start: thisMonday,
          end: thisMonday.add(const Duration(days: 7)),
        ),
      ReportsPeriod.thisMonth => ReportsDateRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 1),
        ),
      ReportsPeriod.thisYear => ReportsDateRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        ),
    };
  }

  static List<PeriodPlPoint> _emptyBuckets(
    ReportsPeriod period,
    ReportsDateRange range,
    DateTime now,
  ) {
    return switch (period) {
      ReportsPeriod.today => List.generate(24, (hour) {
          final start = DateTime(
            range.start.year,
            range.start.month,
            range.start.day,
            hour,
          );
          return PeriodPlPoint(
            label: DateFormat('ha').format(start),
            periodStart: start,
            income: 0,
            expense: 0,
          );
        }),
      ReportsPeriod.thisWeek => List.generate(7, (index) {
          final day = range.start.add(Duration(days: index));
          return PeriodPlPoint(
            label: DateFormat('E').format(day),
            periodStart: day,
            income: 0,
            expense: 0,
          );
        }),
      ReportsPeriod.thisMonth => List.generate(now.day, (index) {
          final day = DateTime(now.year, now.month, index + 1);
          return PeriodPlPoint(
            label: '${day.day}',
            periodStart: day,
            income: 0,
            expense: 0,
          );
        }),
      ReportsPeriod.thisYear => List.generate(now.month, (index) {
          final month = DateTime(now.year, index + 1, 1);
          return PeriodPlPoint(
            label: DateFormat('MMM').format(month),
            periodStart: month,
            income: 0,
            expense: 0,
          );
        }),
    };
  }

  static int? _bucketIndex(
    DateTime date,
    ReportsPeriod period,
    ReportsDateRange range,
  ) {
    if (!range.contains(date)) return null;

    final local = date.toLocal();
    final day = _localDate(local);

    return switch (period) {
      ReportsPeriod.today => local.hour,
      ReportsPeriod.thisWeek => day.difference(_localDate(range.start)).inDays,
      ReportsPeriod.thisMonth => day.day - 1,
      ReportsPeriod.thisYear => day.month - 1,
    };
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
}
