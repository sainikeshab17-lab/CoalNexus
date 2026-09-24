import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';

class EditViolationPage extends ConsumerStatefulWidget {
  final String violationId;

  const EditViolationPage({
    super.key,
    required this.violationId,
  });

  @override
  ConsumerState<EditViolationPage> createState() => _EditViolationPageState();
}

class _EditViolationPageState extends ConsumerState<EditViolationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToController;
  
  ViolationSeverity _severity = ViolationSeverity.medium;
  ViolationStatus _status = ViolationStatus.recorded;
  DateTime? _dueDate;
  bool _isSaving = false;
  bool _isLoading = true;
  Violation? _violation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _assignedToController = TextEditingController();
    _loadViolation();
  }

  Future<void> _loadViolation() async {
    final violation = await ref.read(getViolationByIdProvider).call(widget.violationId);
    if (violation != null && mounted) {
      setState(() {
        _violation = violation;
        _titleController.text = violation.title;
        _descriptionController.text = violation.description;
        _assignedToController.text = violation.assignedTo ?? '';
        _severity = violation.severity;
        _status = violation.status;
        _dueDate = violation.dueDate;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _violation == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedViolation = _violation!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _severity,
        status: _status,
        assignedTo: _assignedToController.text.isEmpty ? null : _assignedToController.text.trim(),
        dueDate: _dueDate,
      );

      await ref.read(updateViolationProvider)(updatedViolation);
      
      // Update local list state
      ref.read(violationListProvider.notifier).updateLocalViolation(updatedViolation);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Violation updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating violation: $e')),
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
    if (_isLoading) {
      return const Scaffold(body: AppLoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Violation'),
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
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                      ),
                      maxLines: 3,
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
                        return DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()));
                      }).toList(),
                      onChanged: (v) => setState(() => _severity = v!),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<ViolationStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status *'),
                      items: ViolationStatus.values.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()));
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
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
