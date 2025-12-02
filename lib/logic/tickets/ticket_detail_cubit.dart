import 'package:bloc/bloc.dart';
import '../../data/models/ticket.dart';
import 'tickets_cubit.dart';

class TicketDetailState {
  final Ticket ticket;
  final bool isResolved;
  final bool saving;

  TicketDetailState({
    required this.ticket,
    this.isResolved = false,
    this.saving = false,
  });

  TicketDetailState copyWith({bool? isResolved, bool? saving}) {
    return TicketDetailState(
      ticket: ticket,
      isResolved: isResolved ?? this.isResolved,
      saving: saving ?? this.saving,
    );
  }
}

class TicketDetailCubit extends Cubit<TicketDetailState> {
  final TicketsCubit ticketsCubit;

  TicketDetailCubit({required Ticket ticket, required this.ticketsCubit})
    : super(
        TicketDetailState(
          ticket: ticket,
          isResolved: ticketsCubit.isResolved(ticket.id),
        ),
      );

  Future<void> markResolved() async {
    if (state.isResolved) return;
    emit(state.copyWith(saving: true));
    await ticketsCubit.markResolved(state.ticket.id);
    emit(state.copyWith(isResolved: true, saving: false));
  }
}
