import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';

/// Central route configuration for Ledgify
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // TODO: Add remaining routes
      // - OTP verification
      // - PIN setup
      // - Business setup
      // - Home/Dashboard
      // - Ledger
      // - Invoice
      // - Inventory
      // - Reports
      // - AI Chat
      // - Settings
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Route not found: ${state.uri}')),
      );
    },
  );
}
