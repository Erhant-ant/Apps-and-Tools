import 'package:flutter/material.dart';

import '../ticket_details/ticket_details_screen.dart';
import '../../../core/localization/app_language.dart';
import '../../../data/ticket_store.dart';
import '../../../models/support_ticket.dart';

enum _TicketSort { newest, oldest, priority }

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  String _searchQuery = '';
  TicketStatus? _selectedStatus;
  TicketPriority? _selectedPriority;
  String? _selectedDepartment;
  _TicketSort _selectedSort = _TicketSort.newest;

  bool get _hasActiveFilters {
    return _selectedStatus != null ||
        _selectedPriority != null ||
        _selectedDepartment != null;
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedPriority = null;
      _selectedDepartment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appLanguageController, ticketStore]),
      builder: (context, child) {
        final departments = ticketStore.value
            .map((ticket) => ticket.department)
            .toSet()
            .toList()
          ..sort();
        final visibleTickets = ticketStore.value.where((ticket) {
          final query = _searchQuery.toLowerCase();
          final matchesSearch =
              ticket.id.toLowerCase().contains(query) ||
              ticket.title.toLowerCase().contains(query) ||
              ticket.department.toLowerCase().contains(query) ||
              ticket.category.toLowerCase().contains(query);

          return matchesSearch &&
              (_selectedStatus == null || ticket.status == _selectedStatus) &&
              (_selectedPriority == null ||
                  ticket.priority == _selectedPriority) &&
              (_selectedDepartment == null ||
                  ticket.department == _selectedDepartment);
        }).toList()
          ..sort(_compareTickets);

        return Scaffold(
          appBar: AppBar(title: Text(localized('Tickets', 'Ticketlar'))),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: localized(
                      'Search by ticket, department, or category',
                      'Ticket, departman veya kategori ara',
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const filterWidth = 220.0;
                    final useFullWidth = constraints.maxWidth < filterWidth * 2;
                    final width = useFullWidth ? constraints.maxWidth : filterWidth;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: width,
                          child: DropdownButtonFormField<TicketStatus?>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: localized('Status', 'Durum'),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  localized('All statuses', 'Tum durumlar'),
                                ),
                              ),
                              ...TicketStatus.values.map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(_statusLabel(status)),
                                ),
                              ),
                            ],
                            onChanged: (status) {
                              setState(() {
                                _selectedStatus = status;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: DropdownButtonFormField<TicketPriority?>(
                            value: _selectedPriority,
                            decoration: InputDecoration(
                              labelText: localized('Priority', 'Oncelik'),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  localized('All priorities', 'Tum oncelikler'),
                                ),
                              ),
                              ...TicketPriority.values.map(
                                (priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(_priorityLabel(priority)),
                                ),
                              ),
                            ],
                            onChanged: (priority) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: DropdownButtonFormField<String?>(
                            value: _selectedDepartment,
                            decoration: InputDecoration(
                              labelText: localized('Department', 'Departman'),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  localized(
                                    'All departments',
                                    'Tum departmanlar',
                                  ),
                                ),
                              ),
                              ...departments.map(
                                (department) => DropdownMenuItem(
                                  value: department,
                                  child: Text(department),
                                ),
                              ),
                            ],
                            onChanged: (department) {
                              setState(() {
                                _selectedDepartment = department;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: DropdownButtonFormField<_TicketSort>(
                            value: _selectedSort,
                            decoration: InputDecoration(
                              labelText: localized('Sort by', 'Sirala'),
                            ),
                            items: _TicketSort.values
                                .map(
                                  (sort) => DropdownMenuItem(
                                    value: sort,
                                    child: Text(_sortLabel(sort)),
                                  ),
                                )
                                .toList(),
                            onChanged: (sort) {
                              if (sort == null) {
                                return;
                              }

                              setState(() {
                                _selectedSort = sort;
                              });
                            },
                          ),
                        ),
                        if (_hasActiveFilters)
                          TextButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.filter_alt_off_outlined),
                            label: Text(
                              localized('Clear filters', 'Filtreleri temizle'),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: visibleTickets.isEmpty
                      ? Center(
                          child: Text(
                            localized(
                              'No tickets found.',
                              'Ticket bulunamadi.',
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: visibleTickets.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return _TicketCard(ticket: visibleTickets[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _compareTickets(SupportTicket first, SupportTicket second) {
    switch (_selectedSort) {
      case _TicketSort.newest:
        return second.updatedAt.compareTo(first.updatedAt);
      case _TicketSort.oldest:
        return first.createdAt.compareTo(second.createdAt);
      case _TicketSort.priority:
        final priorityComparison =
            _priorityRank(second.priority).compareTo(_priorityRank(first.priority));
        return priorityComparison != 0
            ? priorityComparison
            : second.updatedAt.compareTo(first.updatedAt);
    }
  }
}

int _priorityRank(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return 1;
    case TicketPriority.medium:
      return 2;
    case TicketPriority.high:
      return 3;
    case TicketPriority.critical:
      return 4;
  }
}

String _sortLabel(_TicketSort sort) {
  switch (sort) {
    case _TicketSort.newest:
      return localized('Recently updated', 'Son guncellenen');
    case _TicketSort.oldest:
      return localized('Oldest first', 'En eski once');
    case _TicketSort.priority:
      return localized('Highest priority', 'En yuksek oncelik');
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(ticket.priority);

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TicketDetailsScreen(ticket: ticket),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: priorityColor.withValues(alpha: 0.12),
          foregroundColor: priorityColor,
          child: Icon(_categoryIcon(ticket.category)),
        ),
        title: Text(ticket.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${ticket.id} - ${ticket.department} - ${ticket.category}',
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _StatusBadge(status: ticket.status),
            const SizedBox(height: 6),
            Text(
              _priorityLabel(ticket.priority),
              style: TextStyle(
                color: priorityColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
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

IconData _categoryIcon(String category) {
  switch (category) {
    case 'Printer':
      return Icons.print_outlined;
    case 'Network':
      return Icons.wifi_outlined;
    case 'Email':
      return Icons.email_outlined;
    case 'Hardware':
      return Icons.memory_outlined;
    case 'Account':
      return Icons.person_outline;
    default:
      return Icons.confirmation_number_outlined;
  }
}
