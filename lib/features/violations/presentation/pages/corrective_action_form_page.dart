import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/features/violations/presentation/providers/corrective_action_providers.dart';

class CorrectiveActionFormPage extends ConsumerStatefulWidget {
  final String violationId;
  final String? actionId;

  const CorrectiveActionFormPage({
    super.key,
    required this.violationId,
    this.actionId,
  });

  @override
  ConsumerState<CorrectiveActionFormPage> createState() => _CorrectiveActionFormPageState();
}

class _CorrectiveActionFormPageState extends ConsumerState<CorrectiveActionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToController;
  String _priority = 'medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  CorrectiveActionStatus _status = CorrectiveActionStatus.assigned;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _assignedToController = TextEditingController();
    _isEditing = widget.actionId != null;

    if (_isEditing) {
      _loadAction();
    }
  }

  Future<void> _loadAction() async {
    setState(() => _isLoading = true);
    final action = await ref.read(getCorrectiveActionByIdProvider).call(widget.actionId!);
    if (action != null) {
      _titleController.text = action.title;
      _descriptionController.text = action.description;
      _assignedToController.text = action.assignedTo;
      _priority = action.priority;
      _dueDate = action.dueDate;
      _status = action.status;
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final action = CorrectiveAction(
        localId: widget.actionId ?? const Uuid().v4(),
        violationId: widget.violationId,
        title: _titleController.text,
        description: _descriptionController.text,
        assignedTo: _assignedToController.text,
        priority: _priority,
        dueDate: _dueDate,
        status: _status,
        createdAt: _isEditing ? now : now, // Ideally keep original
        updatedAt: now,
      );

      if (_isEditing) {
        await ref.read(updateCorrectiveActionProvider).call(action);
      } else {
        await ref.read(createCorrectiveActionProvider).call(action);
      }
      
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving corrective action: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Corrective Action' : 'New Corrective Action'),
      ),
      body: _isLoading 
          ? const AppLoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _assignedToController,
                      decoration: const InputDecoration(labelText: 'Assigned To (User ID)'),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: ['low', 'medium', 'high', 'critical']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase())))
                          .toList(),
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(DateFormat.yMMMd().format(_dueDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setState(() => _dueDate = picked);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: Text(_isEditing ? 'UPDATE ACTION' : 'CREATE ACTION'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
