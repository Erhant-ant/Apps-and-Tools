import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../../data/ticket_store.dart';
import '../../../models/support_ticket.dart';
import '../../../models/ticket_activity.dart';
import '../../../models/ticket_note.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key, required this.ticket});

  final SupportTicket ticket;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final _noteController = TextEditingController();
  final _resolutionController = TextEditingController();
  late SupportTicket _ticket;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
    _resolutionController.text = _ticket.resolutionSummary ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    _resolutionController.dispose();
    super.dispose();
  }

  void _changeStatus(TicketStatus? newStatus) {
    if (newStatus == null || newStatus == _ticket.status) {
      return;
    }

    final now = DateTime.now();
    final updatedTicket = _ticket.copyWith(
      status: newStatus,
      updatedAt: now,
      resolvedAt:
          newStatus == TicketStatus.resolved || newStatus == TicketStatus.closed
              ? _ticket.resolvedAt ?? now
              : null,
      activities: [
        ..._ticket.activities,
        TicketActivity(
          type: TicketActivityType.statusChanged,
          previousStatus: _ticket.status,
          newStatus: newStatus,
          createdAt: now,
        ),
      ],
    );

    setState(() {
      _ticket = updatedTicket;
    });

    ticketStore.updateTicket(updatedTicket);
  }

  void _saveResolution() {
    final summary = _resolutionController.text.trim();

    if (summary.isEmpty || summary == _ticket.resolutionSummary) {
      return;
    }

    final now = DateTime.now();
    final updatedTicket = _ticket.copyWith(
      resolutionSummary: summary,
      resolvedAt: _ticket.resolvedAt ?? now,
      updatedAt: now,
      activities: [
        ..._ticket.activities,
        TicketActivity(
          type: TicketActivityType.resolutionAdded,
          resolutionSummary: summary,
          createdAt: now,
        ),
      ],
    );

    setState(() {
      _ticket = updatedTicket;
    });

    ticketStore.updateTicket(updatedTicket);
    FocusScope.of(context).unfocus();
  }

  void _changeAssignee(String? assignee) {
    if (assignee == null || assignee == _ticket.assignedTo) {
      return;
    }

    final now = DateTime.now();
    final updatedTicket = _ticket.copyWith(
      assignedTo: assignee,
      updatedAt: now,
      activities: [
        ..._ticket.activities,
        TicketActivity(
          type: TicketActivityType.assigneeChanged,
          previousAssignee: _ticket.assignedTo,
          newAssignee: assignee,
          createdAt: now,
        ),
      ],
    );

    setState(() {
      _ticket = updatedTicket;
    });

    ticketStore.updateTicket(updatedTicket);
  }

  void _changePriority(TicketPriority? priority) {
    if (priority == null || priority == _ticket.priority) {
      return;
    }

    final now = DateTime.now();
    final updatedTicket = _ticket.copyWith(
      priority: priority,
      updatedAt: now,
      activities: [
        ..._ticket.activities,
        TicketActivity(
          type: TicketActivityType.priorityChanged,
          previousPriority: _ticket.priority,
          newPriority: priority,
          createdAt: now,
        ),
      ],
    );

    setState(() {
      _ticket = updatedTicket;
    });

    ticketStore.updateTicket(updatedTicket);
  }

  void _changeSla(Duration? duration) {
    if (duration == null) {
      return;
    }

    final now = DateTime.now();
    final newDueAt = now.add(duration);
    final updatedTicket = _ticket.copyWith(
      dueAt: newDueAt,
      updatedAt: now,
      activities: [
        ..._ticket.activities,
        TicketActivity(
          type: TicketActivityType.slaChanged,
          previousDueAt: _ticket.dueAt,
          newDueAt: newDueAt,
          createdAt: now,
        ),
      ],
    );

    setState(() {
      _ticket = updatedTicket;
    });

    ticketStore.updateTicket(updatedTicket);
  }

  void _addNote() {
    final message = _noteController.text.trim();

    if (message.isEmpty) {
      return;
    }

    ticketStore.addNote(ticketId: _ticket.id, message: message);

    setState(() {
      _ticket = ticketStore.value.firstWhere((item) => item.id == _ticket.id);
    });

    _noteController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageController,
      builder: (context, language, child) {
        final isCompleted =
            _ticket.status == TicketStatus.resolved ||
            _ticket.status == TicketStatus.closed;
        final isOverdue = !isCompleted && DateTime.now().isAfter(_ticket.dueAt);
        final slaLabel = _slaLabel(_ticket.dueAt, isCompleted: isCompleted);

        return Scaffold(
          appBar: AppBar(title: Text(_ticket.id)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _ticket.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TicketChip(
                    label: _statusLabel(_ticket.status),
                    color: _statusColor(_ticket.status),
                  ),
                  _TicketChip(
                    label: _priorityLabel(_ticket.priority),
                    color: _priorityColor(_ticket.priority),
                  ),
                  _TicketChip(
                    label: slaLabel,
                    color: isOverdue
                        ? Theme.of(context).colorScheme.error
                        : const Color(0xFF15803D),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                localized('Quick Actions', 'Hizli Islemler'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _quickActions(),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<TicketStatus>(
                    value: _ticket.status,
                    decoration: InputDecoration(
                      labelText: localized('Update Status', 'Durumu Guncelle'),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: TicketStatus.open,
                        child: Text(localized('Open', 'Acik')),
                      ),
                      DropdownMenuItem(
                        value: TicketStatus.assigned,
                        child: Text(localized('Assigned', 'Atandi')),
                      ),
                      DropdownMenuItem(
                        value: TicketStatus.inProgress,
                        child: Text(localized('In Progress', 'Devam Ediyor')),
                      ),
                      DropdownMenuItem(
                        value: TicketStatus.waitingUser,
                        child: Text(
                          localized('Waiting User', 'Kullanici Bekleniyor'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: TicketStatus.resolved,
                        child: Text(localized('Resolved', 'Cozuldu')),
                      ),
                      DropdownMenuItem(
                        value: TicketStatus.closed,
                        child: Text(localized('Closed', 'Kapandi')),
                      ),
                    ],
                    onChanged: _changeStatus,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localized('SLA deadline', 'SLA hedef suresi'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${localized('Current deadline', 'Mevcut hedef')}: ${_formatDate(_ticket.dueAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Duration>(
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: localized(
                            'Set a new SLA deadline',
                            'Yeni SLA hedefi belirle',
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: const Duration(hours: 4),
                            child: Text(localized('4 hours from now', 'Su andan itibaren 4 saat')),
                          ),
                          DropdownMenuItem(
                            value: const Duration(hours: 8),
                            child: Text(localized('8 hours from now', 'Su andan itibaren 8 saat')),
                          ),
                          DropdownMenuItem(
                            value: const Duration(days: 1),
                            child: Text(localized('Tomorrow', 'Yarin')),
                          ),
                          DropdownMenuItem(
                            value: const Duration(days: 3),
                            child: Text(localized('3 days from now', 'Su andan itibaren 3 gun')),
                          ),
                        ],
                        onChanged: _changeSla,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _ticket.assignedTo,
                    decoration: InputDecoration(
                      labelText: localized(
                        'Assign technician',
                        'Teknisyen ata',
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Unassigned',
                        child: Text(localized('Unassigned', 'Atanmadi')),
                      ),
                      const DropdownMenuItem(
                        value: 'Erhan Ant',
                        child: Text('Erhan Ant'),
                      ),
                    ],
                    onChanged: _changeAssignee,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<TicketPriority>(
                    value: _ticket.priority,
                    decoration: InputDecoration(
                      labelText: localized(
                        'Set priority',
                        'Oncelik belirle',
                      ),
                    ),
                    items: TicketPriority.values
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(_priorityLabel(priority)),
                          ),
                        )
                        .toList(),
                    onChanged: _changePriority,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                localized('Description', 'Aciklama'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _ticket.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              Text(
                localized('Ticket Information', 'Ticket Bilgileri'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: localized('Category', 'Kategori'),
                        value: _ticket.category,
                      ),
                      _InfoRow(
                        label: localized('Department', 'Departman'),
                        value: _ticket.department,
                      ),
                      _InfoRow(
                        label: localized('Device', 'Cihaz'),
                        value: _ticket.device,
                      ),
                      _InfoRow(
                        label: localized('Operating System', 'Isletim Sistemi'),
                        value: _ticket.operatingSystem,
                      ),
                      _InfoRow(
                        label: localized('Assigned To', 'Atanan Kisi'),
                        value: _ticket.assignedTo,
                      ),
                      _InfoRow(
                        label: localized('Created', 'Olusturulma'),
                        value: _formatDate(_ticket.createdAt),
                      ),
                      _InfoRow(
                        label: localized('SLA due', 'SLA bitis'),
                        value: _formatDate(_ticket.dueAt),
                      ),
                      _InfoRow(
                        label: localized('Last Updated', 'Son Guncelleme'),
                        value: _formatDate(_ticket.updatedAt),
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (isCompleted) ...[
                Text(
                  localized('Resolution Summary', 'Cozum Ozeti'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _resolutionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: localized(
                              'Describe the solution provided',
                              'Uygulanan cozumu acikla',
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _saveResolution,
                            icon: const Icon(Icons.task_alt_outlined),
                            label: Text(
                              localized('Save Resolution', 'Cozumu Kaydet'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
              Text(
                localized('Technician Notes', 'Teknisyen Notlari'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _noteController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: localized('Add a note', 'Not ekle'),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: _addNote,
                          icon: const Icon(Icons.add_comment_outlined),
                          label: Text(localized('Add Note', 'Not Ekle')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_ticket.notes.isEmpty)
                Text(
                  localized(
                    'No technician notes have been added yet.',
                    'Henuz teknisyen notu eklenmedi.',
                  ),
                )
              else
                Card(
                  child: Column(
                    children: _ticket.notes.reversed
                        .map((note) => _NoteRow(note: note))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 28),
              Text(
                localized('Activity', 'Hareketler'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ActivityRow(
                        icon: Icons.add_task_outlined,
                        title: localized(
                          'Ticket created',
                          'Ticket olusturuldu',
                        ),
                        subtitle: _formatDate(_ticket.createdAt),
                      ),
                      ..._ticket.activities.reversed.expand(
                        (activity) => [
                          const Divider(),
                          _ActivityRow(
                            icon: _activityIcon(activity.type),
                            title: _activityLabel(activity),
                            subtitle: _formatDate(activity.createdAt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _quickActions() {
    switch (_ticket.status) {
      case TicketStatus.open:
      case TicketStatus.assigned:
        return [
          FilledButton.icon(
            onPressed: () => _changeStatus(TicketStatus.inProgress),
            icon: const Icon(Icons.play_arrow_outlined),
            label: Text(localized('Start Work', 'Calismaya Basla')),
          ),
        ];
      case TicketStatus.inProgress:
        return [
          OutlinedButton.icon(
            onPressed: () => _changeStatus(TicketStatus.waitingUser),
            icon: const Icon(Icons.hourglass_top_outlined),
            label: Text(localized('Wait for User', 'Kullaniciyi Bekle')),
          ),
          FilledButton.icon(
            onPressed: () => _changeStatus(TicketStatus.resolved),
            icon: const Icon(Icons.task_alt_outlined),
            label: Text(localized('Mark Resolved', 'Cozuldu Olarak Isaretle')),
          ),
        ];
      case TicketStatus.waitingUser:
        return [
          FilledButton.icon(
            onPressed: () => _changeStatus(TicketStatus.inProgress),
            icon: const Icon(Icons.play_arrow_outlined),
            label: Text(localized('Resume Work', 'Calismaya Devam Et')),
          ),
        ];
      case TicketStatus.resolved:
        return [
          OutlinedButton.icon(
            onPressed: () => _changeStatus(TicketStatus.inProgress),
            icon: const Icon(Icons.replay_outlined),
            label: Text(localized('Reopen Ticket', 'Ticketi Yeniden Ac')),
          ),
          FilledButton.icon(
            onPressed: () => _changeStatus(TicketStatus.closed),
            icon: const Icon(Icons.lock_outline),
            label: Text(localized('Close Ticket', 'Ticketi Kapat')),
          ),
        ];
      case TicketStatus.closed:
        return [
          OutlinedButton.icon(
            onPressed: () => _changeStatus(TicketStatus.inProgress),
            icon: const Icon(Icons.replay_outlined),
            label: Text(localized('Reopen Ticket', 'Ticketi Yeniden Ac')),
          ),
        ];
    }
  }
}

class _TicketChip extends StatelessWidget {
  const _TicketChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide.none,
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        if (showDivider) const Divider(height: 24),
      ],
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.note});

  final TicketNote note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.message),
          const SizedBox(height: 8),
          Text(
            '${note.author} - ${_formatDate(note.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

IconData _activityIcon(TicketActivityType type) {
  switch (type) {
    case TicketActivityType.statusChanged:
      return Icons.sync_outlined;
    case TicketActivityType.assigneeChanged:
      return Icons.person_outline;
    case TicketActivityType.priorityChanged:
      return Icons.flag_outlined;
    case TicketActivityType.slaChanged:
      return Icons.timer_outlined;
    case TicketActivityType.resolutionAdded:
      return Icons.task_alt_outlined;
    case TicketActivityType.noteAdded:
      return Icons.add_comment_outlined;
  }
}

String _activityLabel(TicketActivity activity) {
  switch (activity.type) {
    case TicketActivityType.statusChanged:
      return localized(
        'Status changed from ${_statusLabel(activity.previousStatus!)} to ${_statusLabel(activity.newStatus!)}',
        'Durum ${_statusLabel(activity.previousStatus!)} konumundan ${_statusLabel(activity.newStatus!)} konumuna degistirildi',
      );
    case TicketActivityType.assigneeChanged:
      return localized(
        'Technician changed from ${activity.previousAssignee} to ${activity.newAssignee}',
        'Teknisyen ${activity.previousAssignee} yerine ${activity.newAssignee} olarak degistirildi',
      );
    case TicketActivityType.priorityChanged:
      return localized(
        'Priority changed from ${_priorityLabel(activity.previousPriority!)} to ${_priorityLabel(activity.newPriority!)}',
        'Oncelik ${_priorityLabel(activity.previousPriority!)} konumundan ${_priorityLabel(activity.newPriority!)} konumuna degistirildi',
      );
    case TicketActivityType.slaChanged:
      return localized(
        'SLA deadline changed from ${_formatDate(activity.previousDueAt!)} to ${_formatDate(activity.newDueAt!)}',
        'SLA hedefi ${_formatDate(activity.previousDueAt!)} konumundan ${_formatDate(activity.newDueAt!)} konumuna degistirildi',
      );
    case TicketActivityType.resolutionAdded:
      return localized('Resolution summary saved', 'Cozum ozeti kaydedildi');
    case TicketActivityType.noteAdded:
      return localized('Technician note added', 'Teknisyen notu eklendi');
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${date.year}-$month-$day $hour:$minute';
}

String _slaLabel(DateTime dueAt, {required bool isCompleted}) {
  if (isCompleted) {
    return localized('SLA completed', 'SLA tamamlandi');
  }

  final difference = dueAt.difference(DateTime.now());
  final duration = _formatDuration(difference.abs());

  return difference.isNegative
      ? localized('SLA breached by $duration', 'SLA $duration asildi')
      : localized('SLA due in $duration', 'SLA hedefine $duration kaldi');
}

String _formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    final hours = duration.inHours.remainder(24);
    return hours == 0 ? '${duration.inDays}d' : '${duration.inDays}d ${hours}h';
  }

  if (duration.inHours > 0) {
    final minutes = duration.inMinutes.remainder(60);
    return minutes == 0 ? '${duration.inHours}h' : '${duration.inHours}h ${minutes}m';
  }

  return '${duration.inMinutes.clamp(1, 59)}m';
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
