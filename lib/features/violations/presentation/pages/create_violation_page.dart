import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';

class CreateViolationPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;

  const CreateViolationPage({super.key, this.initialData});

  @override
  ConsumerState<CreateViolationPage> createState() => _CreateViolationPageState();
}

class _CreateViolationPageState extends ConsumerState<CreateViolationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _mineIdController;
  late final TextEditingController _inspectionIdController;
  late final TextEditingController _findingIdController;
  late final TextEditingController _assignedToController;
  
  ViolationSeverity _severity = ViolationSeverity.medium;
  ViolationStatus _status = ViolationStatus.recorded;
  DateTime? _dueDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.initialData?['description'] as String?);
    _mineIdController = TextEditingController(text: widget.initialData?['mineId'] as String?);
    _inspectionIdController = TextEditingController(text: widget.initialData?['inspectionId'] as String?);
    _findingIdController = TextEditingController(text: widget.initialData?['findingId'] as String?);
    _assignedToController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mineIdController.dispose();
    _inspectionIdController.dispose();
    _findingIdController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final violation = Violation(
        localId: const Uuid().v4(),
        mineId: _mineIdController.text.trim(),
        inspectionId: _inspectionIdController.text.trim(),
        findingId: _findingIdController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _severity,
        status: _status,
        assignedTo: _assignedToController.text.isEmpty ? null : _assignedToController.text.trim(),
        dueDate: _dueDate,
        detectedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(createViolationProvider)(violation);
      
      // Update local list state
      ref.read(violationListProvider.notifier).addLocalViolation(violation);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Violation reported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reporting violation: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Violation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Violation Title *',
                        hintText: 'Brief summary of the violation',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Detailed description of the violation',
                      ),
                      maxLines: 3,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppSectionHeader(title: 'Context'),
              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mineIdController,
                      decoration: const InputDecoration(labelText: 'Mine ID *'),
                      readOnly: widget.initialData?['mineId'] != null,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _inspectionIdController,
                      decoration: const InputDecoration(labelText: 'Inspection ID *'),
                      readOnly: widget.initialData?['inspectionId'] != null,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _findingIdController,
                      decoration: const InputDecoration(labelText: 'Finding ID *'),
                      readOnly: widget.initialData?['findingId'] != null,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppSectionHeader(title: 'Classification'),
              AppCard(
                child: Column(
                  children: [
                    DropdownButtonFormField<ViolationSeverity>(
                      initialValue: _severity,
                      decoration: const InputDecoration(labelText: 'Severity *'),
                      items: ViolationSeverity.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _severity = v!),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField<ViolationStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status *'),
                      items: ViolationStatus.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppSectionHeader(title: 'Assignment & Deadline'),
              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _assignedToController,
                      decoration: const InputDecoration(
                        labelText: 'Assign To',
                        hintText: 'User ID or Name',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(_dueDate == null ? 'Not set' : DateFormat.yMMMd().format(_dueDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectDueDate,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Report Violation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
