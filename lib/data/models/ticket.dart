class Ticket {
  final int id;
  final String title;
  final String body;
  final int userId;

  Ticket({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
    userId: json['userId'] as int,
  );
}
