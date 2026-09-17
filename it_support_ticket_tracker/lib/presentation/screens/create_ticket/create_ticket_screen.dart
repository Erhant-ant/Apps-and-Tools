import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../../data/ticket_store.dart';
import '../../../models/support_ticket.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deviceController = TextEditingController();

  String _category = 'Hardware';
  String _department = 'Finance';
  String _operatingSystem = 'Windows 11';
  String _assignedTo = 'Unassigned';
  TicketPriority _priority = TicketPriority.medium;
  int _slaHours = 8;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();

    ticketStore.addTicket(
      SupportTicket(
        id: '#${_nextTicketNumber()}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        department: _department,
        device: _deviceController.text.trim().isEmpty
            ? 'Not specified'
            : _deviceController.text.trim(),
        operatingSystem: _operatingSystem,
        assignedTo: _assignedTo,
        priority: _priority,
        status: TicketStatus.open,
        createdAt: now,
        updatedAt: now,
        dueAt: now.add(Duration(hours: _slaHours)),
      ),
    );

    Navigator.of(context).pop();
  }

  // Ticket numbers continue from the highest ticket already in the store.
  int _nextTicketNumber() {
    final highestNumber = ticketStore.value.fold<int>(100, (highest, ticket) {
      final ticketNumber = int.tryParse(ticket.id.replaceFirst('#', '')) ?? 0;
      return ticketNumber > highest ? ticketNumber : highest;
    });

    return highestNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageController,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(title: Text(localized('New Ticket', 'Yeni Ticket'))),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  localized(
                    'Describe the issue so the support team can act quickly.',
                    'Destek ekibinin hizli hareket edebilmesi icin sorunu aciklayin.',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localized('Title', 'Baslik'),
                    hintText: localized(
                      'Example: Cannot login to VPN',
                      'Ornek: VPN girisi yapilamiyor',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localized(
                        'Please enter a title.',
                        'Lutfen bir baslik girin.',
                      );
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: localized('Description', 'Aciklama'),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localized(
                        'Please describe the issue.',
                        'Lutfen sorunu aciklayin.',
                      );
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: localized('Category', 'Kategori'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Hardware',
                      child: Text(localized('Hardware', 'Donanim')),
                    ),
                    DropdownMenuItem(
                      value: 'Software',
                      child: Text(localized('Software', 'Yazilim')),
                    ),
                    DropdownMenuItem(
                      value: 'Network',
                      child: Text(localized('Network', 'Ag')),
                    ),
                    DropdownMenuItem(
                      value: 'Email',
                      child: Text(localized('Email', 'E-posta')),
                    ),
                    DropdownMenuItem(
                      value: 'Printer',
                      child: Text(localized('Printer', 'Yazici')),
                    ),
                    DropdownMenuItem(
                      value: 'Security',
                      child: Text(localized('Security', 'Guvenlik')),
                    ),
                    DropdownMenuItem(
                      value: 'Account',
                      child: Text(localized('Account', 'Hesap')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _department,
                  decoration: InputDecoration(
                    labelText: localized('Department', 'Departman'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Finance',
                      child: Text(localized('Finance', 'Finans')),
                    ),
                    DropdownMenuItem(
                      value: 'Human Resources',
                      child: Text(
                        localized('Human Resources', 'Insan Kaynaklari'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Sales',
                      child: Text(localized('Sales', 'Satis')),
                    ),
                    DropdownMenuItem(
                      value: 'Marketing',
                      child: Text(localized('Marketing', 'Pazarlama')),
                    ),
                    DropdownMenuItem(
                      value: 'Operations',
                      child: Text(localized('Operations', 'Operasyon')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _department = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TicketPriority>(
                  initialValue: _priority,
                  decoration: InputDecoration(
                    labelText: localized('Priority', 'Oncelik'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: TicketPriority.low,
                      child: Text(localized('Low', 'Dusuk')),
                    ),
                    DropdownMenuItem(
                      value: TicketPriority.medium,
                      child: Text(localized('Medium', 'Orta')),
                    ),
                    DropdownMenuItem(
                      value: TicketPriority.high,
                      child: Text(localized('High', 'Yuksek')),
                    ),
                    DropdownMenuItem(
                      value: TicketPriority.critical,
                      child: Text(localized('Critical', 'Kritik')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _priority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _slaHours,
                  decoration: InputDecoration(
                    labelText: localized('SLA target', 'SLA hedefi'),
                    helperText: localized(
                      'Expected resolution time',
                      'Beklenen cozum suresi',
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 4,
                      child: Text(localized('4 hours', '4 saat')),
                    ),
                    DropdownMenuItem(
                      value: 8,
                      child: Text(localized('8 hours', '8 saat')),
                    ),
                    DropdownMenuItem(
                      value: 24,
                      child: Text(localized('1 business day', '1 is gunu')),
                    ),
                    DropdownMenuItem(
                      value: 72,
                      child: Text(localized('3 business days', '3 is gunu')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _slaHours = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deviceController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localized('Device', 'Cihaz'),
                    hintText: localized(
                      'Example: Dell Latitude 5440',
                      'Ornek: Dell Latitude 5440',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _operatingSystem,
                  decoration: InputDecoration(
                    labelText: localized('Operating System', 'Isletim Sistemi'),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Windows 11',
                      child: Text('Windows 11'),
                    ),
                    DropdownMenuItem(
                      value: 'Windows 10',
                      child: Text('Windows 10'),
                    ),
                    DropdownMenuItem(value: 'macOS', child: Text('macOS')),
                    DropdownMenuItem(value: 'Linux', child: Text('Linux')),
                    DropdownMenuItem(value: 'Mobile', child: Text('Mobile')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _operatingSystem = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _assignedTo,
                  decoration: InputDecoration(
                    labelText: localized('Assigned To', 'Atanan Kisi'),
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
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _assignedTo = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _submitTicket,
                    icon: const Icon(Icons.add_task_outlined),
                    label: Text(localized('Create Ticket', 'Ticket Olustur')),
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
