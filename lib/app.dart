import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/tickets/tickets_cubit.dart';
import 'data/repositories/ticket_repository.dart';
import 'core/services/local_storage_service.dart';
import 'presentation/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = LocalStorageService();
    final authCubit = AuthCubit(storage: storage);
    final ticketsCubit = TicketsCubit(
      repo: TicketRepository(),
      storage: storage,
    );

    final appRouter = AppRouter(
      authCubit: authCubit,
      ticketsCubit: ticketsCubit,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<TicketsCubit>.value(value: ticketsCubit),
      ],
      child: MaterialApp.router(
        title: 'Ticket Resolution',
        routerConfig: appRouter.router,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
