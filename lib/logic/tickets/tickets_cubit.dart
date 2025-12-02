import 'package:bloc/bloc.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/utils/constants.dart';
import '../../data/models/ticket.dart';
import '../../data/repositories/ticket_repository.dart';

class TicketsState {
  final bool loading;
  final List<Ticket> tickets;
  final Set<int> resolvedIds;
  final String? error;

  TicketsState({
    this.loading = false,
    this.tickets = const [],
    Set<int>? resolvedIds,
    this.error,
  }) : resolvedIds = resolvedIds ?? {};

  TicketsState copyWith({
    bool? loading,
    List<Ticket>? tickets,
    Set<int>? resolvedIds,
    String? error,
  }) {
    return TicketsState(
      loading: loading ?? this.loading,
      tickets: tickets ?? this.tickets,
      resolvedIds: resolvedIds ?? this.resolvedIds,
      error: error,
    );
  }
}

class TicketsCubit extends Cubit<TicketsState> {
  final TicketRepository repo;
  final LocalStorageService storage;

  TicketsCubit({required this.repo, required this.storage})
    : super(TicketsState()) {
    _init();
  }

  Future<void> _init() async {
    await storage.init();
    final resolved = storage.getString(Constants.resolvedKey);
    final resolvedSet = <int>{};
    if (resolved != null && resolved.isNotEmpty) {
      resolved.split(',').forEach((s) {
        final id = int.tryParse(s);
        if (id != null) resolvedSet.add(id);
      });
    }
    emit(state.copyWith(resolvedIds: resolvedSet));
  }

  Future<void> fetchTickets() async {
    try {
      emit(state.copyWith(loading: true, error: null));
      final list = await repo.fetchTickets();
      emit(state.copyWith(loading: false, tickets: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  bool isResolved(int id) => state.resolvedIds.contains(id);

  Future<void> markResolved(int id) async {
    final newSet = Set<int>.from(state.resolvedIds)..add(id);
    await storage.setString(Constants.resolvedKey, newSet.join(','));
    emit(state.copyWith(resolvedIds: newSet));
  }
}
