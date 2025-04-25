// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/trips/presentation/trips_page.dart';
import '../features/trips/presentation/new_trip_page.dart';
import '../features/luggage/presentation/luggage_page.dart';
import '../features/settings/presentation/settings_page.dart';

final appRouterProvider = Provider<GoRouter>(
  (_) => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const TripsPage(),
        routes: [
          GoRoute(path: 'new', builder: (_, __) => const NewTripPage()),
          GoRoute(
            path: 'luggage/:id',
            builder:
                (_, state) => LuggagePage(tripId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    ],
  ),
);
