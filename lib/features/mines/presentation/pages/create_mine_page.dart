import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_list_provider.dart';

class CreateMinePage extends ConsumerStatefulWidget {
  const CreateMinePage({super.key});

  @override
  ConsumerState<CreateMinePage> createState() => _CreateMinePageState();
}

class _CreateMinePageState extends ConsumerState<CreateMinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  MineStatus _status = MineStatus.active;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final mine = Mine(
        localId: const Uuid().v4(),
        name: _nameController.text.trim(),
        mineCode: _codeController.text.trim(),
        latitude: double.parse(_latController.text),
        longitude: double.parse(_lngController.text),
        status: _status,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(createMineProvider)(mine);
      
      // Update local list state for immediate UI feedback
      ref.read(mineListProvider.notifier).addLocalMine(mine);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving mine: $e')),
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
        title: const Text('Create Mine'),
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Mine Name *',
                        hintText: 'e.g. Blackwood Creek Mine',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Mine Code *',
                        hintText: 'e.g. BCM-001',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppSectionHeader(title: 'Location'),
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude *',
                          hintText: '(-90 to 90)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          final val = double.tryParse(v);
                          if (val == null || val < -90 || val > 90) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude *',
                          hintText: '(-180 to 180)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          final val = double.tryParse(v);
                          if (val == null || val < -180 || val > 180) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppSectionHeader(title: 'Status'),
              AppCard(
                child: DropdownButtonFormField<MineStatus>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Mine Status'),
                  items: MineStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _status = v!),
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
                    : const Text('Save Mine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
