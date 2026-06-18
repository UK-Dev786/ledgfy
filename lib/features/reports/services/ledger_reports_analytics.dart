import 'package:intl/intl.dart';

import '../../../core/constants/app_text.dart';
import '../../ledger/models/ledger_entry.dart';
import '../../ledger/models/ledger_item.dart';
import '../../ledger/models/party_balance.dart';
import '../../ledger/shared/khata_report/khata_report_data.dart';
import '../models/reports_chart_data.dart';

abstract final class LedgerReportsAnalytics {
  static ReportsSnapshot build({
    required List<LedgerItem> ledgers,
    required ReportsPeriod period,
    DateTime? now,
    String? actorUserId,
  }) {
    final reference = now ?? DateTime.now();
    final range = _rangeFor(period, reference);
    final buckets = _emptyBuckets(period, range, reference);

    var totalIncome = 0.0;
    var totalExpense = 0.0;

    for (final ledger in ledgers) {
      final config = ledger.config;
      for (final entry in ledger.entries) {
        if (actorUserId != null && entry.createdByUserId != actorUserId) {
          continue;
        }

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
      partyRoles: _partyRoleSlices(
        ledgers,
        range: range,
        actorUserId: actorUserId,
      ),
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netPl: totalIncome - totalExpense,
    );
  }

  static String periodLabel(ReportsPeriod period) {
    return switch (period) {
      ReportsPeriod.today => AppText.reportsPeriodToday,
      ReportsPeriod.thisWeek => AppText.reportsPeriodThisWeek,
      ReportsPeriod.thisMonth => AppText.reportsPeriodThisMonth,
      ReportsPeriod.thisYear => AppText.reportsPeriodThisYear,
    };
  }

  static String periodRangeLabel(ReportsPeriod period, DateTime now) {
    final range = rangeFor(period, now);
    final dayFormat = DateFormat('d MMM yyyy');
    final monthFormat = DateFormat('MMMM yyyy');

    return switch (period) {
      ReportsPeriod.today => dayFormat.format(range.start),
      ReportsPeriod.thisWeek =>
        '${dayFormat.format(range.start)} – ${dayFormat.format(range.end.subtract(const Duration(days: 1)))}',
      ReportsPeriod.thisMonth => monthFormat.format(range.start),
      ReportsPeriod.thisYear => '${range.start.year}',
    };
  }

  static ReportsDateRange rangeFor(ReportsPeriod period, DateTime now) {
    return _rangeFor(period, now);
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

  static List<PartyRoleSlice> _partyRoleSlices(
    List<LedgerItem> ledgers, {
    required ReportsDateRange range,
    String? actorUserId,
  }) {
    var customerTotal = 0.0;
    var supplierTotal = 0.0;

    for (final ledger in ledgers) {
      final config = ledger.config;
      if (!config.supportsSubLedgers) continue;

      final entries = ledger.entries.where((entry) {
        if (actorUserId != null && entry.createdByUserId != actorUserId) {
          return false;
        }
        return range.contains(entry.occurredAt);
      }).toList();

      final parties = PartyBalanceCalculator.calculate(
        entries: entries,
        config: config,
        parties: ledger.parties,
      );

      for (final party in parties) {
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

  static KhataReportData buildKhataReport({
    required List<LedgerItem> ledgers,
    required ReportsSnapshot snapshot,
    required ReportsPeriod period,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final range = rangeFor(period, reference);
    final entries = <KhataReportEntryRow>[];

    for (final ledger in ledgers) {
      final config = ledger.config;
      for (final entry in ledger.entries) {
        if (!range.contains(entry.occurredAt)) continue;

        final isCredit = config.creditTypes.contains(entry.type);
        final isDebit = config.debitTypes.contains(entry.type);
        if (!isCredit && !isDebit) continue;

        entries.add(
          KhataReportEntryRow(
            date: entry.occurredAt,
            ledgerName: ledger.title,
            title: _entryTitle(entry, config.labelForEntry(entry.type)),
            typeLabel: config.labelForEntry(entry.type),
            amount: entry.amount,
            isIncome: isCredit,
          ),
        );
      }
    }

    entries.sort((a, b) => b.date.compareTo(a.date));

    final breakdownRows = snapshot.plPoints
        .where((point) => point.income > 0 || point.expense > 0)
        .map(
          (point) => KhataReportBreakdownRow(
            label: point.label,
            income: point.income,
            expense: point.expense,
          ),
        )
        .toList();

    final partyRoleRows = snapshot.partyRoles
        .where((slice) => slice.amount > 0)
        .map(
          (slice) => KhataReportSummaryRow(
            label: slice.role,
            amount: slice.amount,
          ),
        )
        .toList();

    return KhataReportData(
      kind: KhataReportKind.analytics,
      ledgerTitle: AppText.reportsPrintTitle,
      ledgerTypeLabel:
          '${AppText.reportsPrintPeriod}: ${periodLabel(period)} (${periodRangeLabel(period, reference)})',
      periodLabel: periodLabel(period),
      periodRangeLabel: periodRangeLabel(period, reference),
      summaryRows: [
        KhataReportSummaryRow(
          label: AppText.reportsIncome,
          amount: snapshot.totalIncome,
        ),
        KhataReportSummaryRow(
          label: AppText.reportsExpense,
          amount: snapshot.totalExpense,
        ),
        KhataReportSummaryRow(
          label: AppText.reportsNetPl,
          amount: snapshot.netPl,
        ),
      ],
      breakdownRows: breakdownRows,
      partyRoleRows: partyRoleRows,
      balance: snapshot.netPl,
      balanceLabel: AppText.reportsNetPl,
      entries: entries,
      generatedAt: reference,
    );
  }

  static String _entryTitle(LedgerEntry entry, String fallback) {
    final note = entry.note?.trim();
    if (note != null && note.isNotEmpty) return note;

    final category = entry.category?.trim();
    if (category != null && category.isNotEmpty) return category;

    final party = entry.partyName?.trim();
    if (party != null && party.isNotEmpty) return party;

    return fallback;
  }
}
