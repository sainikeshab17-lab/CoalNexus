import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:coalnexus/core/widgets/app_buttons.dart';
import 'package:coalnexus/core/widgets/app_text_field.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_detail_provider.dart';

class AddFindingPage extends ConsumerStatefulWidget {
  final String inspectionId;

  const AddFindingPage({super.key, required this.inspectionId});

  @override
  ConsumerState<AddFindingPage> createState() => _AddFindingPageState();
}

class _AddFindingPageState extends ConsumerState<AddFindingPage> {
  final _formKey = GlobalKey<FormState>();
  final _requirementController = TextEditingController();
  final _descriptionController = TextEditingController();
  FindingStatus _selectedStatus = FindingStatus.compliant;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _requirementController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Finding'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _requirementController,
                labelText: 'Requirement ID',
                hintText: 'e.g., MSHA-30-CFR-75.1711',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Detail what was observed...',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<FindingStatus>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Compliance Status',
                  border: OutlineInputBorder(),
                ),
                items: FindingStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Save Finding',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();
      final finding = InspectionFinding(
        localId: const Uuid().v4(),
        inspectionId: widget.inspectionId,
        requirementId: _requirementController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _selectedStatus,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(addInspectionFindingProvider).call(finding);
      
      // Update local detail state
      ref.read(inspectionDetailProvider(widget.inspectionId).notifier).addLocalFinding(finding);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
