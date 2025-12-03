import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/tickets/tickets_cubit.dart';
import '../widgets/ticket_card.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TicketsCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: BlocBuilder<TicketsCubit, TicketsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state.tickets.isEmpty) {
            // first time: fetch
            cubit.fetchTickets();
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: cubit.fetchTickets,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.tickets.length,
              itemBuilder: (context, i) {
                final t = state.tickets[i];
                final resolved = state.resolvedIds.contains(t.id);
                return TicketCard(ticket: t, resolved: resolved);
              },
            ),
          );
        },
      ),
    );
  }
}
