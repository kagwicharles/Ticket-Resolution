import 'package:flutter/material.dart';
import 'tickets_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return const _HomeScaffold();
  }
}

class _HomeScaffold extends StatefulWidget {
  const _HomeScaffold({super.key});

  @override
  State<_HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<_HomeScaffold> {
  int _index = 0;
  final _pages = [const TicketsScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Tickets'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
