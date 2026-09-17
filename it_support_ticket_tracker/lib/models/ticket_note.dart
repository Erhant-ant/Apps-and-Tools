class TicketNote {
  const TicketNote({
    required this.id,
    required this.message,
    required this.author,
    required this.createdAt,
  });

  final String id;
  final String message;
  final String author;
  final DateTime createdAt;
}
