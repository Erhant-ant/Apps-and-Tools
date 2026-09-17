import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../../data/ticket_store.dart';
import '../../../models/support_ticket.dart';
import '../ticket_details/ticket_details_screen.dart';

class TicketBoardScreen extends StatelessWidget {
  const TicketBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appLanguageController, ticketStore]),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(localized('Work Board', 'Is Panosu'))),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localized('Ticket workflow', 'Ticket is akisi'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  localized(
                    'Track work across each support stage.',
                    'Talepleri her destek asamasinda takip edin.',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: TicketStatus.values
                          .map(
                            (status) => Padding(
                              padding: EdgeInsets.only(
                                right: status == TicketStatus.values.last
                                    ? 0
                                    : 12,
                              ),
                              child: SizedBox(
                                width: 280,
                                child: _BoardColumn(
                                  status: status,
                                  tickets: ticketStore.value
                                      .where(
                                        (ticket) => ticket.status == status,
                                      )
                                      .toList()
                                    ..sort(
                                      (first, second) => second.updatedAt
                                          .compareTo(first.updatedAt),
                                    ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BoardColumn extends StatelessWidget {
  const _BoardColumn({required this.status, required this.tickets});

  final TicketStatus status;
  final List<SupportTicket> tickets;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusLabel(status),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Badge(label: Text('${tickets.length}')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tickets.isEmpty
                  ? Center(
                      child: Text(
                        localized('No tickets', 'Ticket yok'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: tickets.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return _BoardTicketCard(ticket: tickets[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardTicketCard extends StatelessWidget {
  const _BoardTicketCard({required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(ticket.priority);
    final isCompleted =
        ticket.status == TicketStatus.resolved ||
        ticket.status == TicketStatus.closed;
    final isOverdue = !isCompleted && DateTime.now().isAfter(ticket.dueAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TicketDetailsScreen(ticket: ticket),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ticket.id,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 6),
                    Tooltip(
                      message: localized('SLA breached', 'SLA asildi'),
                      child: Icon(
                        Icons.timer_off_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const Spacer(),
                  PopupMenuButton<TicketStatus>(
                    tooltip: localized('Update status', 'Durumu guncelle'),
                    icon: const Icon(Icons.more_horiz, size: 20),
                    onSelected: (status) {
                      ticketStore.updateTicket(
                        ticket.copyWith(status: status, updatedAt: DateTime.now()),
                      );
                    },
                    itemBuilder: (context) {
                      return TicketStatus.values
                          .where((status) => status != ticket.status)
                          .map(
                            (status) => PopupMenuItem(
                              value: status,
                              child: Text(_statusLabel(status)),
                            ),
                          )
                          .toList();
                    },
                  ),
                  Icon(Icons.flag_outlined, size: 16, color: priorityColor),
                  const SizedBox(width: 4),
                  Text(
                    _priorityLabel(ticket.priority),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Text(
                '${ticket.department} - ${ticket.category}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ticket.assignedTo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _priorityColor(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return const Color(0xFF15803D);
    case TicketPriority.medium:
      return const Color(0xFF2563EB);
    case TicketPriority.high:
      return const Color(0xFFD97706);
    case TicketPriority.critical:
      return const Color(0xFFB42318);
  }
}

String _priorityLabel(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return localized('Low', 'Dusuk');
    case TicketPriority.medium:
      return localized('Medium', 'Orta');
    case TicketPriority.high:
      return localized('High', 'Yuksek');
    case TicketPriority.critical:
      return localized('Critical', 'Kritik');
  }
}

Color _statusColor(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return const Color(0xFF2563EB);
    case TicketStatus.assigned:
      return const Color(0xFF7C3AED);
    case TicketStatus.inProgress:
      return const Color(0xFFD97706);
    case TicketStatus.waitingUser:
      return const Color(0xFF0891B2);
    case TicketStatus.resolved:
      return const Color(0xFF15803D);
    case TicketStatus.closed:
      return const Color(0xFF64748B);
  }
}

String _statusLabel(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return localized('Open', 'Acik');
    case TicketStatus.assigned:
      return localized('Assigned', 'Atandi');
    case TicketStatus.inProgress:
      return localized('In Progress', 'Devam Ediyor');
    case TicketStatus.waitingUser:
      return localized('Waiting User', 'Kullanici Bekleniyor');
    case TicketStatus.resolved:
      return localized('Resolved', 'Cozuldu');
    case TicketStatus.closed:
      return localized('Closed', 'Kapandi');
  }
}
