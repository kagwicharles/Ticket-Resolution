import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_shell.dart';
import '../presentation/screens/ticket_detail_screen.dart';
import '../logic/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

GoRouter buildRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      authCubit.stream.map((s) => s.isAuthenticated),
    ),
    redirect: (context, state) {
      final loggedIn = authCubit.state.isAuthenticated;
      final loggingIn = state.subloc == '/login' || state.subloc == '/';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && (state.subloc == '/login' || state.subloc == '/'))
        return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => child,
            // child will be tickets screen as index 0
            routes: [
              GoRoute(
                path: 'ticket/:id',
                name: 'ticket_detail',
                builder: (context, state) {
                  final idStr = state.params['id']!;
                  final id = int.parse(idStr);
                  return TicketDetailScreen(ticketId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );
}
