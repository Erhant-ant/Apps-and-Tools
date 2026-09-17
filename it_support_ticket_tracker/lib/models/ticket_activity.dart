import 'support_ticket.dart';

enum TicketActivityType {
  statusChanged,
  assigneeChanged,
  priorityChanged,
  slaChanged,
  resolutionAdded,
  noteAdded,
}

class TicketActivity {
  const TicketActivity({
    required this.type,
    required this.createdAt,
    this.previousStatus,
    this.newStatus,
    this.previousAssignee,
    this.newAssignee,
    this.previousPriority,
    this.newPriority,
    this.previousDueAt,
    this.newDueAt,
    this.resolutionSummary,
  });

  final TicketActivityType type;
  final DateTime createdAt;
  final TicketStatus? previousStatus;
  final TicketStatus? newStatus;
  final String? previousAssignee;
  final String? newAssignee;
  final TicketPriority? previousPriority;
  final TicketPriority? newPriority;
  final DateTime? previousDueAt;
  final DateTime? newDueAt;
  final String? resolutionSummary;
}
