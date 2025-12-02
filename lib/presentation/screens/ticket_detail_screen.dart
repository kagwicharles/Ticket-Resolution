import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/tickets/tickets_cubit.dart';
import '../../logic/tickets/ticket_detail_cubit.dart';
import '../../data/models/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  final int ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    final ticketsCubit = context.read<TicketsCubit>();
    final ticket = ticketsCubit.state.tickets.firstWhere(
      (t) => t.id == ticketId,
      orElse: () =>
          Ticket(id: ticketId, title: 'Unknown', body: 'No body', userId: 0),
    );
    return BlocProvider(
      create: (_) =>
          TicketDetailCubit(ticket: ticket, ticketsCubit: ticketsCubit),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Ticket #${ticket.id}')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<TicketDetailCubit, TicketDetailState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        state.ticket.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            state.ticket.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: state.isResolved || state.saving
                            ? null
                            : () async {
                                await context
                                    .read<TicketDetailCubit>()
                                    .markResolved();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Marked resolved'),
                                  ),
                                );
                              },
                        child: state.saving
                            ? const CircularProgressIndicator.adaptive()
                            : Text(
                                state.isResolved
                                    ? 'Resolved'
                                    : 'Mark as Resolved',
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
