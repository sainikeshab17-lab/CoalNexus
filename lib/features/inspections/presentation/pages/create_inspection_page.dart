import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/widgets/app_buttons.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';

class CreateInspectionPage extends ConsumerStatefulWidget {
  const CreateInspectionPage({super.key});

  @override
  ConsumerState<CreateInspectionPage> createState() => _CreateInspectionPageState();
}

class _CreateInspectionPageState extends ConsumerState<CreateInspectionPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMineId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final minesAsync = ref.watch(getCachedMinesProvider).call();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Inspection'),
      ),
      body: FutureBuilder<List<Mine>>(
        future: minesAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoadingIndicator();
          }

          if (snapshot.hasError) {
            return AppErrorView(message: snapshot.error.toString());
          }

          final mines = snapshot.data ?? [];
          if (mines.isEmpty) {
            return const AppEmptyView(
              message: 'No mines available. You need to sync mines first.',
              icon: Icons.layers_outlined,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedMineId,
                    decoration: const InputDecoration(
                      labelText: 'Select Mine',
                      border: OutlineInputBorder(),
                    ),
                    items: mines.map((mine) {
                      return DropdownMenuItem(
                        value: mine.localId,
                        child: Text(mine.name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedMineId = value),
                    validator: (value) => value == null ? 'Please select a mine' : null,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Start Inspection',
                    isLoading: _isSubmitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authNotifierProvider).user;
      if (user == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final inspection = Inspection(
        localId: const Uuid().v4(),
        mineId: _selectedMineId!,
        inspectorId: user.id,
        status: InspectionStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(createInspectionProvider).call(inspection);
      
      // Update local list
      ref.read(inspectionListProvider.notifier).addLocalInspection(inspection);

      if (mounted) {
        context.replace('/inspections/${inspection.localId}');
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
