import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket.dart';

class TicketRepository {
  final _base = 'https://jsonplaceholder.typicode.com';

  Future<List<Ticket>> fetchTickets() async {
    final res = await http.get(Uri.parse('$_base/posts'));
    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body) as List;
      return jsonList.map((e) => Ticket.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }
}
