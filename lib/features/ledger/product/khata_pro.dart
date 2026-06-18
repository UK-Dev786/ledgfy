/// Ledgify Khata Pro — product definition vs basic digital khata apps.
///
/// Position: professional Easy Khata alternative with smarter books,
/// party-wise udhar, typed ledgers, and business-grade reporting (roadmap).
abstract final class KhataPro {
  static const String edition = 'Pro';
  static const String positioning =
      'Professional digital khata for serious businesses';

  /// Shipped in UI today.
  static const List<String> liveCapabilities = [
    'Multi-book ledgers (Udhar, Cash, Expense, Project)',
    'Category-specific entry flows per ledger type',
    'Party-wise udhar balance (per customer/supplier)',
    'Full PKR amounts on detail, smart labels on list',
    'PDF & shareable khata reports with Ledgify branding',
    'Opening balance per ledger',
    'Given / Received udhar with party name',
    'Cash in / cash out cash book',
    'Expense tracker with categories',
    'Project income vs cost per project',
    'Reports tab with Syncfusion P&L charts',
    'Customer vs supplier outstanding chart',
  ];

  /// Next pro milestones (Firebase + backend).
  static const List<String> roadmapCapabilities = [
    'Cloud sync & multi-device backup',
    'SMS / WhatsApp payment reminders',
    'Supplier vs customer role tags on parties',
    'Staff logins with roles and full activity history',
  ];
}
