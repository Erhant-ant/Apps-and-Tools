import 'ticket_note.dart';
import 'ticket_activity.dart';

enum TicketPriority { low, medium, high, critical }

enum TicketStatus { open, assigned, inProgress, waitingUser, resolved, closed }

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.department,
    required this.device,
    required this.operatingSystem,
    required this.assignedTo,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    this.notes = const [],
    this.activities = const [],
    this.resolutionSummary,
    this.resolvedAt,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String department;
  final String device;
  final String operatingSystem;
  final String assignedTo;
  final TicketPriority priority;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final List<TicketNote> notes;
  final List<TicketActivity> activities;
  final String? resolutionSummary;
  final DateTime? resolvedAt;

  // Keeps the original ticket intact while applying a small update.
  SupportTicket copyWith({
    String? assignedTo,
    TicketPriority? priority,
    TicketStatus? status,
    DateTime? updatedAt,
    DateTime? dueAt,
    List<TicketNote>? notes,
    List<TicketActivity>? activities,
    String? resolutionSummary,
    DateTime? resolvedAt,
  }) {
    return SupportTicket(
      id: id,
      title: title,
      description: description,
      category: category,
      department: department,
      device: device,
      operatingSystem: operatingSystem,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      notes: notes ?? this.notes,
      activities: activities ?? this.activities,
      resolutionSummary: resolutionSummary ?? this.resolutionSummary,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
