import 'package:flutter/material.dart';

import '../board/ticket_board_screen.dart';
import '../create_ticket/create_ticket_screen.dart';
import '../tickets/tickets_screen.dart';
import '../../../core/localization/app_language.dart';
import '../../../data/ticket_store.dart';
import '../../../models/support_ticket.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appLanguageController, ticketStore]),
      builder: (context, child) {
        final language = appLanguageController.value;
        final isNarrow = MediaQuery.sizeOf(context).width < 700;
        final tickets = ticketStore.value;

        final openTickets = tickets
            .where((ticket) => ticket.status == TicketStatus.open)
            .length;
        final inProgressTickets = tickets
            .where((ticket) => ticket.status == TicketStatus.inProgress)
            .length;
        final waitingUserTickets = tickets
            .where((ticket) => ticket.status == TicketStatus.waitingUser)
            .length;
        final closedTickets = tickets
            .where(
              (ticket) =>
                  ticket.status == TicketStatus.resolved ||
                  ticket.status == TicketStatus.closed,
            )
            .length;

        final highPriorityTickets = tickets
            .where(
              (ticket) =>
                  (ticket.priority == TicketPriority.high ||
                      ticket.priority == TicketPriority.critical) &&
                  ticket.status != TicketStatus.resolved &&
                  ticket.status != TicketStatus.closed,
            )
            .toList();

        final overdueTickets = tickets
            .where(
              (ticket) =>
                  ticket.status != TicketStatus.resolved &&
                  ticket.status != TicketStatus.closed &&
                  DateTime.now().isAfter(ticket.dueAt),
            )
            .toList()
          ..sort((first, second) => first.dueAt.compareTo(second.dueAt));

        final metrics = [
          _DashboardMetric(
            label: localized('Open', 'Acik'),
            value: '$openTickets',
            icon: Icons.confirmation_number_outlined,
            color: const Color(0xFF2563EB),
          ),
          _DashboardMetric(
            label: localized('In Progress', 'Devam Eden'),
            value: '$inProgressTickets',
            icon: Icons.build_outlined,
            color: const Color(0xFFD97706),
          ),
          _DashboardMetric(
            label: localized('Waiting User', 'Kullanici Bekleniyor'),
            value: '$waitingUserTickets',
            icon: Icons.hourglass_top_outlined,
            color: const Color(0xFF7C3AED),
          ),
          _DashboardMetric(
            label: localized('Resolved', 'Cozuldu'),
            value: '$closedTickets',
            icon: Icons.task_alt_outlined,
            color: const Color(0xFF15803D),
          ),
          _DashboardMetric(
            label: localized('SLA Breached', 'SLA Asildi'),
            value: '${overdueTickets.length}',
            icon: Icons.timer_off_outlined,
            color: const Color(0xFFB42318),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.support_agent_outlined),
                const SizedBox(width: 10),
                Text(localized('SupportDesk', 'DestekMasasi')),
              ],
            ),
            actions: [
              IconButton(
                tooltip: localized('Open work board', 'Is panosunu ac'),
                icon: const Icon(Icons.view_kanban_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TicketBoardScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: localized('View tickets', 'Ticketlari goruntule'),
                icon: const Icon(Icons.list_alt_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TicketsScreen(),
                    ),
                  );
                },
              ),
              PopupMenuButton<AppLanguage>(
                tooltip: localized('Change language', 'Dili degistir'),
                icon: const Icon(Icons.language_outlined),
                onSelected: (selectedLanguage) {
                  appLanguageController.value = selectedLanguage;
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: AppLanguage.english,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: language == AppLanguage.english
                              ? const Icon(Icons.check)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('English'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: AppLanguage.turkish,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: language == AppLanguage.turkish
                              ? const Icon(Icons.check)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Turkce'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(isNarrow ? 16 : 32),
            children: [
              Text(
                localized('Operations Overview', 'Operasyon Ozeti'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                localized(
                  'Monitor IT support activity and identify work that needs attention.',
                  'IT destek faaliyetlerini takip edin ve dikkat gerektiren isleri belirleyin.',
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                localized(
                  'Demo workspace - sample operational data',
                  'Demo calisma alani - ornek operasyon verileri',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateTicketScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(localized('New Ticket', 'Yeni Ticket')),
                ),
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1000
                      ? 4
                      : constraints.maxWidth >= 600
                      ? 2
                      : 1;

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 3.4 : 2.1,
                    children: metrics
                        .map((metric) => _MetricCard(metric: metric))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 28),
              Text(
                localized('SLA Attention', 'SLA Takibi'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: overdueTickets.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          localized(
                            'No active tickets have missed their SLA target.',
                            'Aktif ticketlarin hicbiri SLA hedefini gecmedi.',
                          ),
                        ),
                      )
                    : Column(
                        children: overdueTickets
                            .map((ticket) => _SlaTicket(ticket: ticket))
                            .toList(),
                      ),
              ),
              const SizedBox(height: 28),
              Text(
                localized('Needs Attention', 'Dikkat Gerektirenler'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: highPriorityTickets
                      .map((ticket) => _AttentionTicket(ticket: ticket))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardMetric {
  const _DashboardMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _DashboardMetric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: metric.color.withValues(alpha: 0.12),
              foregroundColor: metric.color,
              child: Icon(metric.icon),
            ),
            const SizedBox(width: 14),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.value,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttentionTicket extends StatelessWidget {
  const _AttentionTicket({required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final priorityColor = ticket.priority == TicketPriority.critical
        ? const Color(0xFFB42318)
        : const Color(0xFFB45309);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: priorityColor.withValues(alpha: 0.12),
        foregroundColor: priorityColor,
        child: const Icon(Icons.warning_amber_rounded),
      ),
      title: Text(ticket.title),
      subtitle: Text('${ticket.id} - ${ticket.department}'),
      trailing: Chip(
        label: Text(_priorityLabel(ticket.priority)),
        backgroundColor: priorityColor.withValues(alpha: 0.12),
        side: BorderSide.none,
      ),
    );
  }
}

class _SlaTicket extends StatelessWidget {
  const _SlaTicket({required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    const alertColor = Color(0xFFB42318);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: alertColor.withValues(alpha: 0.12),
        foregroundColor: alertColor,
        child: const Icon(Icons.timer_off_outlined),
      ),
      title: Text(ticket.title),
      subtitle: Text(
        '${ticket.id} - ${localized('Due', 'Hedef')}: ${_formatDate(ticket.dueAt)}',
      ),
      trailing: Chip(
        label: Text(localized('Breached', 'Asildi')),
        backgroundColor: alertColor.withValues(alpha: 0.12),
        side: BorderSide.none,
        labelStyle: const TextStyle(color: alertColor),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${date.year}-$month-$day $hour:$minute';
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
