import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mtorque_flutter/features/strength/presentation/state/strength_providers.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class StrengthPage extends ConsumerWidget {
  const StrengthPage({super.key});

  static const String routeName = 'strength';
  static const String routePath = '/strength';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(strengthFlowControllerProvider);
    final controller = ref.read(strengthFlowControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navStrength),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.navStrength,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'DB-first strength foundation is active. This page now reads real local strength data.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: state.isLoading
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        label: 'Open session',
                        value: state.hasOpenSession ? 'Yes' : 'No',
                      ),
                      _InfoRow(
                        label: 'Open session id',
                        value: state.openSessionId?.toString() ?? '—',
                      ),
                      _InfoRow(
                        label: 'Open session start',
                        value: _formatEpoch(state.openSessionStartEpochMs),
                      ),
                      _InfoRow(
                        label: 'Open session exercises',
                        value: state.openSessionExerciseCount.toString(),
                      ),
                      _InfoRow(
                        label: 'Open session sets',
                        value: state.openSessionSetCount.toString(),
                      ),
                      _InfoRow(
                        label: 'Finished sessions',
                        value: state.finishedSessionCount.toString(),
                      ),
                      _InfoRow(
                        label: 'Last finished session',
                        value: _formatEpoch(
                          state.lastFinishedSessionEndEpochMs,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current migration status',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The shared local database is live and the Strength page is already connected to real DB data.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Important Android parity rule: A strength session must not be created when this page opens. It should only be created when the first complete set is saved.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: state.hasOpenSession
                    ? controller.finalizeOpenSession
                    : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Finalize open session'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: controller.load,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload strength overview'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatEpoch(int? epochMs) {
    if (epochMs == null) {
      return '—';
    }
    final date = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}