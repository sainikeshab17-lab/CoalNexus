import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_list_provider.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_sync_status_provider.dart';
import 'package:coalnexus/core/sync/sync_models.dart';

class MineListPage extends ConsumerStatefulWidget {
  const MineListPage({super.key});

  @override
  ConsumerState<MineListPage> createState() => _MineListPageState();
}

class _MineListPageState extends ConsumerState<MineListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mineListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mines'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search mines by name or code...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(mineListProvider.notifier).setSearchQuery('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                ref.read(mineListProvider.notifier).setSearchQuery(value);
                setState(() {}); // Update suffixIcon visibility
              },
            ),
          ),
        ),
      ),
      body: state.when(
        loading: () => const AppLoadingIndicator(message: 'Loading mines...'),
        error: (err, stack) => AppErrorView(
          message: err.toString(),
          onRetry: () => ref.read(mineListProvider.notifier).loadMines(),
        ),
        data: (mines) {
          if (mines.isEmpty) {
            if (_searchController.text.isNotEmpty) {
              return const AppEmptyView(
                message: 'No mines match your search.',
                icon: Icons.search_off,
              );
            }
            return const AppEmptyView(
              message: 'No mines available. Tap + to create one.',
              icon: Icons.layers_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.read(mineListProvider.notifier).loadMines(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: mines.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final mine = mines[index];
                return MineCard(mine: mine);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/mines/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MineCard extends ConsumerWidget {
  final Mine mine;

  const MineCard({super.key, required this.mine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(mineSyncStatusProvider(mine.localId));

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/mines/${mine.localId}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      mine.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _SyncStatusIndicator(status: syncStatusAsync.value),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Code: ${mine.mineCode}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${mine.latitude.toStringAsFixed(4)}, ${mine.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  _MineStatusChip(status: mine.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStatusIndicator extends StatelessWidget {
  final SyncStatus? status;

  const _SyncStatusIndicator({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status == SyncStatus.synced) return const SizedBox.shrink();

    IconData icon;
    Color color;

    switch (status!) {
      case SyncStatus.pending:
        icon = Icons.cloud_upload_outlined;
        color = Colors.grey;
        break;
      case SyncStatus.syncing:
        icon = Icons.sync;
        color = Colors.blue;
        break;
      case SyncStatus.failed:
        icon = Icons.cloud_off;
        color = Colors.red;
        break;
      case SyncStatus.conflict:
        icon = Icons.warning_amber;
        color = Colors.orange;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Tooltip(
      message: 'Sync status: ${status!.name}',
      child: Icon(icon, size: 16, color: color),
    );
  }
}

class _MineStatusChip extends StatelessWidget {
  final MineStatus status;

  const _MineStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case MineStatus.active:
        color = Colors.green;
        break;
      case MineStatus.inactive:
        color = Colors.grey;
        break;
      case MineStatus.suspended:
        color = Colors.orange;
        break;
      case MineStatus.underMaintenance:
        color = Colors.blue;
        break;
    }

    return AppStatusChip(label: status.name, color: color);
  }
}
