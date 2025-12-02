import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final email = authState.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(email, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await context.read<AuthCubit>().logout();
                  // GoRouter redirect will take to login
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
