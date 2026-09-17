import 'package:flutter/foundation.dart';

import '../models/support_ticket.dart';
import '../models/ticket_activity.dart';
import '../models/ticket_note.dart';
import 'sample_tickets.dart';

class TicketStore extends ValueNotifier<List<SupportTicket>> {
  TicketStore() : super(List.of(SampleTickets.items));

  void addTicket(SupportTicket ticket) {
    value = [ticket, ...value];
  }

  void updateTicket(SupportTicket updatedTicket) {
    value = value
        .map((ticket) => ticket.id == updatedTicket.id ? updatedTicket : ticket)
        .toList();
  }

  void addNote({
    required String ticketId,
    required String message,
    String author = 'Erhan Ant',
  }) {
    final ticket = value.firstWhere((item) => item.id == ticketId);
    final now = DateTime.now();

    final note = TicketNote(
      id: 'note-${now.microsecondsSinceEpoch}',
      message: message,
      author: author,
      createdAt: now,
    );

    updateTicket(
      ticket.copyWith(
        notes: [...ticket.notes, note],
        activities: [
          ...ticket.activities,
          TicketActivity(
            type: TicketActivityType.noteAdded,
            createdAt: now,
          ),
        ],
        updatedAt: now,
      ),
    );
  }
}

final ticketStore = TicketStore();
