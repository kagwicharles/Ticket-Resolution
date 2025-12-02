import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/auth/auth_cubit.dart';
import '../logic/tickets/ticket_detail_cubit.dart';
import '../logic/tickets/tickets_cubit.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/tickets_screen.dart';

class AppRouter {
  final AuthCubit authCubit;
  final TicketsCubit ticketsCubit;

  AppRouter({required this.authCubit, required this.ticketsCubit});

  late final GoRouter router = GoRouter(
    initialLocation: '/tickets',
    refreshListenable: _GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // If not authenticated and not on login page, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // If authenticated and on login page, redirect to tickets
      if (isAuthenticated && isLoggingIn) {
        return '/tickets';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.list_alt),
                  label: "Tickets",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tickets',
                name: 'tickets',
                builder: (context, state) => const TicketsScreen(),
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    name: 'ticket_details',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);

                      // Find the ticket from TicketsCubit state
                      final ticket = ticketsCubit.state.tickets.firstWhere(
                        (t) => t.id == id,
                        orElse: () => throw Exception('Ticket not found'),
                      );

                      return BlocProvider(
                        create: (context) => TicketDetailCubit(
                          ticket: ticket,
                          ticketsCubit: ticketsCubit,
                        ),
                        child: TicketDetailScreen(ticketId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Helper class to make GoRouter listen to AuthCubit stream
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
