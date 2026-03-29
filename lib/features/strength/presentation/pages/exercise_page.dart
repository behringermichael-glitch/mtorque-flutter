import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/set_entry.dart';
import '../../domain/repositories/strength_repository.dart';
import '../state/strength_flow_controller.dart';
import '../state/strength_providers.dart';
import 'exercise_asset_resolver.dart';

class StartRestTimerNotification extends Notification {
  const StartRestTimerNotification();
}

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({
    super.key,
    required this.exerciseId,
    this.showSwipeLeftHint = false,
    this.showSwipeRightHint = false,
  });

  final String exerciseId;
  final bool showSwipeLeftHint;
  final bool showSwipeRightHint;

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  static const int _modBlood = 1;
  static const int _modChain = 2;
  static const int _modEqual = 4;

  Timer? _pendingSync;
  final Set<int> _focusedRows = <int>{};

  @override
  void dispose() {
    _pendingSync?.cancel();
    super.dispose();
  }

  void _handleRowFocusChanged(int rowIndex, bool isFocused) {
    final changed = isFocused
        ? _focusedRows.add(rowIndex)
        : _focusedRows.remove(rowIndex);
    if (changed && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final flowState = ref.watch(strengthFlowControllerProvider);
    final flow = ref.read(strengthFlowControllerProvider.notifier);
    final repository = ref.watch(strengthRepositoryProvider);

    final draft = flowState.draftSession;
    final compactHeader = _focusedRows.isNotEmpty;
    final list =
        draft?.setsByExercise[widget.exerciseId] ?? const <SetEntry>[];

    return FutureBuilder<StrengthExerciseSummary?>(
      future: repository.getExerciseById(widget.exerciseId),
      builder: (context, snapshot) {
        final exercise = snapshot.data;
        final isStatic = exercise?.isStatic ?? false;
        final exerciseName = exercise?.label ?? widget.exerciseId;

        return FutureBuilder<StrengthExerciseStats>(
          future: repository.loadExerciseStats(
            exerciseId: widget.exerciseId,
            isStaticExercise: isStatic,
          ),
          builder: (context, statsSnapshot) {
            final suggestions = _buildLastSessionSuggestions(statsSnapshot.data);

            return Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: compactHeader
                      ? const SizedBox.shrink()
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ExerciseHeader(
                        exerciseId: widget.exerciseId,
                        exerciseName: exerciseName,
                        showSwipeLeftHint: widget.showSwipeLeftHint,
                        showSwipeRightHint: widget.showSwipeRightHint,
                        onInfo: () => _showInfoBottomSheet(
                          context: context,
                          repository: repository,
                          exerciseId: widget.exerciseId,
                        ),
                        onMuscles: () => _showMusclesBottomSheet(
                          context: context,
                          repository: repository,
                          exerciseId: widget.exerciseId,
                        ),
                        onStats: () => _showStatsBottomSheet(
                          context: context,
                          repository: repository,
                          exerciseId: widget.exerciseId,
                          exerciseName: exerciseName,
                          isStaticExercise: isStatic,
                        ),
                        onDelete: () async {
                          final confirmed = await _confirmDeleteExercise(context);
                          if (!mounted || confirmed != true) return;
                          await flow.removeExercise(widget.exerciseId);
                        },
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final suggestion = suggestions[index + 1];

                      return _SetRow(
                        key: ValueKey('set_row_${widget.exerciseId}_$index'),
                        index: index,
                        value: item,
                        isStatic: isStatic,
                        suggestedLoad: suggestion?.$1,
                        suggestedSecond: suggestion?.$2,
                        onChanged: (next) async {
                          final updated = [...list];
                          updated[index] = next;
                          await flow.replaceExerciseSets(
                            exerciseId: widget.exerciseId,
                            sets: updated,
                          );
                        },
                        onOpenMarkers: () async {
                          final updatedEntry = await _showMarkerBottomSheet(
                            context: context,
                            initial: item,
                          );
                          if (!mounted || updatedEntry == null) return;

                          final updated = [...list];
                          updated[index] = updatedEntry;
                          await flow.replaceExerciseSets(
                            exerciseId: widget.exerciseId,
                            sets: updated,
                          );
                          await _scheduleSync(
                            flow: flow,
                            exerciseName: exerciseName,
                            isStatic: isStatic,
                          );
                        },
                        onCompleted: () async {
                          await _scheduleSync(
                            flow: flow,
                            exerciseName: exerciseName,
                            isStatic: isStatic,
                          );
                        },
                        onInputFocusChanged: (isFocused) {
                          _handleRowFocusChanged(index, isFocused);
                        },
                        onDelete: () async {
                          final updated = [...list]..removeAt(index);
                          await flow.replaceExerciseSets(
                            exerciseId: widget.exerciseId,
                            sets: updated,
                          );
                          await _scheduleSync(
                            flow: flow,
                            exerciseName: exerciseName,
                            isStatic: isStatic,
                          );
                        },
                        onStartRestTimer: () {
                          const StartRestTimerNotification().dispatch(context);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: FilledButton(
                      onPressed: () async {
                        final next = [...list, const SetEntry()];
                        await flow.replaceExerciseSets(
                          exerciseId: widget.exerciseId,
                          sets: next,
                        );
                      },
                      child: Text(l10n.strengthExerciseAddSetButton),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Map<int, (double, double)> _buildLastSessionSuggestions(
      StrengthExerciseStats? stats,
      ) {
    if (stats == null || stats.days.isEmpty) {
      return const <int, (double, double)>{};
    }

    final sortedDays = [...stats.days]..sort((a, b) => b.date.compareTo(a.date));
    final latest = sortedDays.firstWhere(
          (day) => day.perSet.isNotEmpty,
      orElse: () => sortedDays.first,
    );

    final map = <int, (double, double)>{};
    for (final point in latest.perSet) {
      map[point.setNumber] = (point.load, point.secondValue);
    }
    return map;
  }

  Future<void> _scheduleSync({
    required StrengthFlowController flow,
    required String exerciseName,
    required bool isStatic,
  }) async {
    _pendingSync?.cancel();
    _pendingSync = Timer(const Duration(milliseconds: 350), () async {
      await flow.syncExerciseToDbIfNeeded(
        exerciseId: widget.exerciseId,
        exerciseName: exerciseName,
        isStaticExercise: isStatic,
      );
    });
  }

  Future<bool?> _confirmDeleteExercise(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthExerciseDeleteExerciseTitle),
          content: Text(l10n.strengthExerciseDeleteExerciseMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.strengthCommonDelete),
            ),
          ],
        );
      },
    );
  }

  Future<SetEntry?> _showMarkerBottomSheet({
    required BuildContext context,
    required SetEntry initial,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final chainController = TextEditingController(
      text: _SetRowState.formatNumber(initial.chainsKg),
    );
    final bandController = TextEditingController(
      text: _SetRowState.formatNumber(initial.bandsKg),
    );
    final superSlowController = TextEditingController(
      text: initial.superSlowNote ?? '',
    );

    final bloodInitial = (initial.mods & _modBlood) != 0;
    final chainInitial = (initial.mods & _modChain) != 0;
    final equalInitial = (initial.mods & _modEqual) != 0;

    return showModalBottomSheet<SetEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        var blood = bloodInitial;
        var chain = chainInitial;
        var equal = equalInitial;
        var superSlow = initial.superSlowEnabled;
        var bfrValue = (initial.bfrPercent ?? 60).clamp(0, 100).toDouble();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final onSurface = Theme.of(context).colorScheme.onSurface;
              final muted = onSurface.withValues(alpha: 0.72);

              Widget buildSection({
                required Widget child,
                required bool enabled,
              }) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: enabled ? 1 : 0.45,
                  child: IgnorePointer(
                    ignoring: !enabled,
                    child: child,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.strengthExerciseMarkersTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: blood,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.strengthExerciseMarkerBfr),
                      onChanged: (value) {
                        setSheetState(() {
                          blood = value ?? false;
                        });
                      },
                    ),
                    buildSection(
                      enabled: blood,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.strengthExerciseBfrPressureLabel,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Slider(
                              min: 0,
                              max: 100,
                              divisions: 100,
                              value: bfrValue,
                              onChanged: (value) {
                                setSheetState(() {
                                  bfrValue = value;
                                });
                              },
                            ),
                            Text(
                              l10n.strengthExerciseBfrValue(bfrValue.round()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: chain,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.strengthExerciseMarkerChain),
                      onChanged: (value) {
                        setSheetState(() {
                          chain = value ?? false;
                        });
                      },
                    ),
                    buildSection(
                      enabled: chain,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _MarkerField(
                          label: l10n.strengthExerciseChainWeightLabel,
                          hint: l10n.strengthExerciseChainWeightHint,
                          suffix: l10n.strengthCommonKgLabel,
                          controller: chainController,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: equal,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.strengthExerciseMarkerBands),
                      onChanged: (value) {
                        setSheetState(() {
                          equal = value ?? false;
                        });
                      },
                    ),
                    buildSection(
                      enabled: equal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _MarkerField(
                          label: l10n.strengthExerciseBandResistanceLabel,
                          hint: l10n.strengthExerciseBandResistanceHint,
                          suffix: l10n.strengthCommonKgLabel,
                          controller: bandController,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: superSlow,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.strengthExerciseMarkerSuperSlow),
                      onChanged: (value) {
                        setSheetState(() {
                          superSlow = value ?? false;
                        });
                      },
                    ),
                    buildSection(
                      enabled: superSlow,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _MarkerField(
                          label: l10n.strengthExerciseSuperSlowActiveLabel,
                          hint: l10n.strengthExerciseSuperSlowHint,
                          suffix: '',
                          controller: superSlowController,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton(
                        onPressed: () {
                          var mods = 0;
                          if (blood) mods |= _modBlood;
                          if (chain) mods |= _modChain;
                          if (equal) mods |= _modEqual;

                          Navigator.of(sheetContext).pop(
                            initial.copyWith(
                              mods: mods,
                              bfrPercent: blood ? bfrValue.round() : null,
                              chainsKg: chain
                                  ? _SetRowState.tryParseDouble(
                                chainController.text,
                              )
                                  : null,
                              bandsKg: equal
                                  ? _SetRowState.tryParseDouble(
                                bandController.text,
                              )
                                  : null,
                              superSlowEnabled: superSlow,
                              superSlowNote: superSlow
                                  ? superSlowController.text.trim().isEmpty
                                  ? null
                                  : superSlowController.text.trim()
                                  : null,
                            ),
                          );
                        },
                        child: Text(l10n.strengthCommonOk),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showInfoBottomSheet({
    required BuildContext context,
    required StrengthRepository repository,
    required String exerciseId,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FutureBuilder<StrengthExerciseDetail?>(
          future: repository.getExerciseDetail(exerciseId),
          builder: (context, snapshot) {
            final detail = snapshot.data;
            final languageCode = Localizations.localeOf(context).languageCode;
            final instruction =
                detail?.instructionForLanguageCode(languageCode) ?? '';

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SingleChildScrollView(
                child: detail == null &&
                    snapshot.connectionState != ConnectionState.done
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail?.label ?? exerciseId,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.strengthExerciseDescriptionTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      instruction.trim().isEmpty
                          ? l10n.strengthExerciseNoDescriptionAvailable
                          : instruction.trim(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showMusclesBottomSheet({
    required BuildContext context,
    required StrengthRepository repository,
    required String exerciseId,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FutureBuilder<StrengthExerciseDetail?>(
          future: repository.getExerciseDetail(exerciseId),
          builder: (context, snapshot) {
            final detail = snapshot.data;
            final languageCode = Localizations.localeOf(context).languageCode;
            final primary = detail?.muscles
                .where((e) => e.role == StrengthMuscleRole.primary)
                .toList() ??
                const <StrengthExerciseMuscleUsage>[];
            final secondary = detail?.muscles
                .where((e) => e.role == StrengthMuscleRole.secondary)
                .toList() ??
                const <StrengthExerciseMuscleUsage>[];

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: detail == null &&
                  snapshot.connectionState != ConnectionState.done
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(),
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail?.label ?? exerciseId,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _MuscleSection(
                      title: l10n.strengthExercisePrimaryMuscles,
                      color: const Color(0xFFFF3C3C),
                      items: primary,
                      languageCode: languageCode,
                      emptyText:
                      l10n.strengthExerciseNoMuscleDataAvailable,
                    ),
                    const SizedBox(height: 18),
                    _MuscleSection(
                      title: l10n.strengthExerciseSecondaryMuscles,
                      color: const Color(0xFF3C7CFF),
                      items: secondary,
                      languageCode: languageCode,
                      emptyText:
                      l10n.strengthExerciseNoMuscleDataAvailable,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showStatsBottomSheet({
    required BuildContext context,
    required StrengthRepository repository,
    required String exerciseId,
    required String exerciseName,
    required bool isStaticExercise,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FutureBuilder<StrengthExerciseStats>(
          future: repository.loadExerciseStats(
            exerciseId: exerciseId,
            isStaticExercise: isStaticExercise,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final stats = snapshot.data ??
                StrengthExerciseStats(
                  exerciseId: exerciseId,
                  exerciseLabel: exerciseName,
                  isStaticExercise: isStaticExercise,
                  maxSetNumber: 0,
                  days: const <StrengthExerciseStatsDay>[],
                );

            return _StatsBottomSheetContent(stats: stats);
          },
        );
      },
    );
  }
}

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({
    required this.exerciseId,
    required this.exerciseName,
    required this.showSwipeLeftHint,
    required this.showSwipeRightHint,
    required this.onInfo,
    required this.onMuscles,
    required this.onStats,
    required this.onDelete,
  });

  final String exerciseId;
  final String exerciseName;
  final bool showSwipeLeftHint;
  final bool showSwipeRightHint;
  final VoidCallback onInfo;
  final VoidCallback onMuscles;
  final VoidCallback onStats;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final iconColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.84);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: ExerciseAssetImage(
                  exerciseId: exerciseId,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(14),
                  placeholderIcon: Icons.image_not_supported_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 148,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compactFontSize = exerciseName.length > 34
                              ? 18.0
                              : exerciseName.length > 24
                              ? 20.0
                              : 22.0;
                          return Text(
                            exerciseName,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.02,
                              fontSize: compactFontSize,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _HeaderActionIcon(
                            icon: Icons.info_outline,
                            color: iconColor,
                            onTap: onInfo,
                          ),
                          const SizedBox(width: 18),
                          _HeaderActionIcon(
                            icon: Icons.accessibility_new_outlined,
                            color: iconColor,
                            onTap: onMuscles,
                          ),
                          const SizedBox(width: 18),
                          _HeaderActionIcon(
                            icon: Icons.bar_chart_outlined,
                            color: iconColor,
                            onTap: onStats,
                          ),
                          const SizedBox(width: 18),
                          _HeaderActionIcon(
                            icon: Icons.delete_outline,
                            color: iconColor,
                            onTap: onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 4,
          right: 4,
          bottom: -10,
          child: IgnorePointer(
            child: _SwipeHintIcons(
              showLeft: showSwipeLeftHint,
              showRight: showSwipeRightHint,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderActionIcon extends StatelessWidget {
  const _HeaderActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}

class _SwipeHintIcons extends StatefulWidget {
  const _SwipeHintIcons({
    required this.showLeft,
    required this.showRight,
  });

  final bool showLeft;
  final bool showRight;

  @override
  State<_SwipeHintIcons> createState() => _SwipeHintIconsState();
}

class _SwipeHintIconsState extends State<_SwipeHintIcons> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _leftAnimation;
  late final Animation<double> _rightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _leftAnimation = Tween<double>(begin: 0, end: -10).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rightAnimation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _startIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _SwipeHintIcons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showLeft != widget.showLeft || oldWidget.showRight != widget.showRight) {
      _startIfNeeded();
    }
  }

  void _startIfNeeded() {
    if (!widget.showLeft && !widget.showRight) {
      _controller.stop();
      _controller.reset();
      return;
    }
    unawaited(_controller.forward(from: 0).then((_) async {
      if (!mounted) return;
      await _controller.reverse();
    }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.46);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: [
            if (widget.showLeft) Transform.translate(offset: Offset(_leftAnimation.value, 0), child: Icon(Icons.chevron_left, color: color, size: 28)) else const SizedBox(width: 28),
            const Spacer(),
            if (widget.showRight) Transform.translate(offset: Offset(_rightAnimation.value, 0), child: Icon(Icons.chevron_right, color: color, size: 28)) else const SizedBox(width: 28),
          ],
        );
      },
    );
  }
}

class _SetRow extends StatefulWidget {
  const _SetRow({
    super.key,
    required this.index,
    required this.value,
    required this.isStatic,
    required this.suggestedLoad,
    required this.suggestedSecond,
    required this.onChanged,
    required this.onOpenMarkers,
    required this.onCompleted,
    required this.onInputFocusChanged,
    required this.onDelete,
    required this.onStartRestTimer,
  });

  final int index;
  final SetEntry value;
  final bool isStatic;
  final double? suggestedLoad;
  final double? suggestedSecond;
  final ValueChanged<SetEntry> onChanged;
  final Future<void> Function() onOpenMarkers;
  final Future<void> Function() onCompleted;
  final ValueChanged<bool> onInputFocusChanged;
  final VoidCallback onDelete;
  final VoidCallback onStartRestTimer;

  @override
  State<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<_SetRow> {
  late final TextEditingController _loadController;
  late final TextEditingController _secondController;
  late final FocusNode _loadFocusNode;
  late final FocusNode _secondFocusNode;
  bool _lastAnyFocus = false;
  String _lastSecondText = '';

  @override
  void initState() {
    super.initState();
    _loadController = TextEditingController(text: formatNumber(widget.value.load));
    _secondController = TextEditingController(
      text: widget.isStatic ? formatInt(widget.value.durationSec) : formatNumber(widget.value.reps),
    );
    _loadFocusNode = FocusNode()..addListener(_handleFocusUpdate);
    _secondFocusNode = FocusNode()..addListener(_handleFocusUpdate);
    _lastSecondText = _secondController.text.trim();
  }

  @override
  void didUpdateWidget(covariant _SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_loadFocusNode.hasFocus) {
      final next = formatNumber(widget.value.load);
      if (_loadController.text != next) _loadController.text = next;
    }

    if (!_secondFocusNode.hasFocus) {
      final next = widget.isStatic ? formatInt(widget.value.durationSec) : formatNumber(widget.value.reps);
      if (_secondController.text != next) _secondController.text = next;
      _lastSecondText = next.trim();
    }
  }

  @override
  void dispose() {
    if (_lastAnyFocus) {
      widget.onInputFocusChanged(false);
    }
    _loadFocusNode.removeListener(_handleFocusUpdate);
    _secondFocusNode.removeListener(_handleFocusUpdate);
    _loadController.dispose();
    _secondController.dispose();
    _loadFocusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusUpdate() {
    final anyFocus = _loadFocusNode.hasFocus || _secondFocusNode.hasFocus;
    if (anyFocus != _lastAnyFocus) {
      _lastAnyFocus = anyFocus;
      widget.onInputFocusChanged(anyFocus);
    }
    if (mounted) setState(() {});
  }

  bool _loadMatchesSuggestion(String value) {
    final parsed = tryParseDouble(value);
    final suggestion = widget.suggestedLoad;
    if (parsed == null || suggestion == null) return false;
    return (parsed - suggestion).abs() <= 0.05;
  }

  String _secondaryHint(AppLocalizations l10n) {
    final base = widget.isStatic ? l10n.strengthCommonDurationShort : 'Wdh.';
    if (_secondController.text.trim().isNotEmpty) return base;
    if (!_secondFocusNode.hasFocus) return base;
    if (widget.suggestedSecond == null) return base;
    if (widget.suggestedLoad == null) return base;

    final loadText = _loadController.text.trim();
    if (loadText.isEmpty || _loadMatchesSuggestion(loadText)) {
      return widget.isStatic ? formatInt(widget.suggestedSecond?.round()) : formatNumber(widget.suggestedSecond);
    }
    return base;
  }

  String _loadHint(AppLocalizations l10n) {
    if (_loadController.text.trim().isNotEmpty) return '';
    if (_loadFocusNode.hasFocus && widget.suggestedLoad != null) {
      return formatNumber(widget.suggestedLoad);
    }
    return l10n.strengthCommonKgLabel;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lineColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.56);
    final deleteBg = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10);
    final deleteFg = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.84);
    final hasMarker = widget.value.mods != 0 || widget.value.superSlowEnabled;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _UnderlineNumberField(
              controller: _loadController,
              focusNode: _loadFocusNode,
              hintText: _loadHint(l10n),
              lineColor: lineColor,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              hintColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
              onChanged: (value) {
                widget.onChanged(widget.value.copyWith(load: tryParseDouble(value)));
                if (mounted) setState(() {});
              },
              onSubmitted: (_) => _secondFocusNode.requestFocus(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _UnderlineNumberField(
              controller: _secondController,
              focusNode: _secondFocusNode,
              hintText: _secondaryHint(l10n),
              lineColor: lineColor,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              hintColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
              onChanged: (value) {
                if (widget.isStatic) {
                  widget.onChanged(widget.value.copyWith(durationSec: int.tryParse(value.trim())));
                } else {
                  widget.onChanged(widget.value.copyWith(reps: tryParseDouble(value)));
                }

                final trimmed = value.trim();
                final shouldStart =
                    _lastSecondText.isEmpty && trimmed.isNotEmpty;
                _lastSecondText = trimmed;
                if (shouldStart) {
                  widget.onStartRestTimer();
                }
              },
              onSubmitted: (_) => widget.onCompleted(),
            ),
          ),
          const SizedBox(width: 10),
          _AllOutIconButton(
            selected: widget.value.allOut,
            onTap: () {
              widget.onChanged(widget.value.copyWith(allOut: !widget.value.allOut));
            },
          ),
          const SizedBox(width: 6),
          _MarkerButton(
            selected: hasMarker,
            onTap: () => widget.onOpenMarkers(),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 42,
            height: 32,
            child: Center(
              child: Material(
                color: deleteBg,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: widget.onDelete,
                  child: SizedBox(
                    width: 42,
                    height: 32,
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: deleteFg,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String formatNumber(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString().replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  static String formatInt(int? value) {
    if (value == null) return '';
    return value.toString();
  }

  static double? tryParseDouble(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }
}

class _UnderlineNumberField extends StatelessWidget {
  const _UnderlineNumberField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.lineColor,
    required this.keyboardType,
    required this.textInputAction,
    required this.hintColor,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color lineColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color hintColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.0),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            height: 1.0,
            color: hintColor,
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lineColor, width: 1.2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lineColor, width: 1.4),
          ),
          contentPadding: const EdgeInsets.only(top: 10, bottom: 6),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _AllOutIconButton extends StatelessWidget {
  const _AllOutIconButton({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFFFF8A00);
    final inactiveColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62);

    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(
          Icons.local_fire_department_outlined,
          size: 31,
          color: selected ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}

class _MarkerButton extends StatelessWidget {
  const _MarkerButton({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.80);

    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.add,
              size: 34,
              color: color,
            ),
            if (selected)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4A4A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MarkerField extends StatelessWidget {
  const _MarkerField({
    required this.label,
    required this.hint,
    required this.suffix,
    required this.controller,
  });

  final String label;
  final String hint;
  final String suffix;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final muted =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: const UnderlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              if (suffix.trim().isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  suffix,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: muted),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MuscleSection extends StatelessWidget {
  const _MuscleSection({
    required this.title,
    required this.color,
    required this.items,
    required this.languageCode,
    required this.emptyText,
  });

  final String title;
  final Color color;
  final List<StrengthExerciseMuscleUsage> items;
  final String languageCode;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]
      ..sort((a, b) => a.muscleName.toLowerCase().compareTo(b.muscleName.toLowerCase()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        if (sorted.isEmpty)
          Text(emptyText)
        else
          for (final item in sorted)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 18,
                    margin: const EdgeInsets.only(top: 2, right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '• ${item.muscleName} (${item.groupNameForLanguageCode(languageCode)})',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class _StatsBottomSheetContent extends StatefulWidget {
  const _StatsBottomSheetContent({
    required this.stats,
  });

  final StrengthExerciseStats stats;

  @override
  State<_StatsBottomSheetContent> createState() =>
      _StatsBottomSheetContentState();
}

class _StatsBottomSheetContentState extends State<_StatsBottomSheetContent> {
  int? _selectedSetNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = widget.stats;

    final visibleDays = stats.days;
    final bars = visibleDays.map((day) {
      if (_selectedSetNumber == null) {
        return _StatsBarValue(
          leftValue: day.totalLoad,
          rightValue: day.totalSecondValue,
          label: _formatTonnage(day.tonnage, context),
          date: day.date,
        );
      }

      final point = day.perSet
          .where((e) => e.setNumber == _selectedSetNumber)
          .cast<StrengthExerciseStatsSetPoint?>()
          .firstWhere(
            (e) => e != null,
        orElse: () => null,
      );

      return _StatsBarValue(
        leftValue: point?.load ?? 0,
        rightValue: point?.secondValue ?? 0,
        label: _formatTonnage(
          (point?.load ?? 0) * (point?.secondValue ?? 0),
          context,
        ),
        date: day.date,
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stats.exerciseLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            if (stats.days.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(l10n.strengthExerciseNoStatsData),
                ),
              )
            else ...[
              _SimpleStatsChart(
                bars: bars,
                leftLegend: l10n.strengthExerciseWeightLegend,
                rightLegend: stats.isStaticExercise
                    ? l10n.strengthExerciseDurationLegend
                    : l10n.strengthExerciseRepsLegend,
                leftAxisTitle: l10n.strengthExerciseWeightAxis,
                rightAxisTitle: stats.isStaticExercise
                    ? l10n.strengthExerciseDurationAxis
                    : l10n.strengthExerciseRepsAxis,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.strengthExerciseOverallChip),
                    selected: _selectedSetNumber == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedSetNumber = null;
                      });
                    },
                  ),
                  for (var i = 1; i <= stats.maxSetNumber; i++)
                    ChoiceChip(
                      label: Text(l10n.strengthExerciseSetChip(i)),
                      selected: _selectedSetNumber == i,
                      onSelected: (_) {
                        setState(() {
                          _selectedSetNumber = i;
                        });
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTonnage(double value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value <= 0) return l10n.strengthExerciseTonnageLabel(0);
    return l10n.strengthExerciseTonnageLabel(value / 1000);
  }
}

class _SimpleStatsChart extends StatelessWidget {
  const _SimpleStatsChart({
    required this.bars,
    required this.leftLegend,
    required this.rightLegend,
    required this.leftAxisTitle,
    required this.rightAxisTitle,
  });

  final List<_StatsBarValue> bars;
  final String leftLegend;
  final String rightLegend;
  final String leftAxisTitle;
  final String rightAxisTitle;

  @override
  Widget build(BuildContext context) {
    final leftMax =
    bars.fold<double>(0, (maxValue, e) => math.max(maxValue, e.leftValue));
    final rightMax =
    bars.fold<double>(0, (maxValue, e) => math.max(maxValue, e.rightValue));
    final leftDivisor = leftMax <= 0 ? 1 : leftMax;
    final rightDivisor = rightMax <= 0 ? 1 : rightMax;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    leftAxisTitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final bar in bars)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        _SingleBar(
                                          value: bar.leftValue,
                                          heightFactor:
                                          bar.leftValue / leftDivisor,
                                          color: const Color(0xFF4A7CFF),
                                        ),
                                        const SizedBox(width: 5),
                                        _SingleBar(
                                          value: bar.rightValue,
                                          heightFactor:
                                          bar.rightValue / rightDivisor,
                                          color: const Color(0xFFC4CAD6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _dayLabel(bar.date, context),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9C1616),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    bar.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    rightAxisTitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _LegendEntry(
                color: const Color(0xFF4A7CFF),
                label: leftLegend,
              ),
              _LegendEntry(
                color: const Color(0xFFC4CAD6),
                label: rightLegend,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime date, BuildContext context) {
    const monthsDe = <int, String>{
      1: 'Jan',
      2: 'Feb',
      3: 'März',
      4: 'Apr',
      5: 'Mai',
      6: 'Juni',
      7: 'Juli',
      8: 'Aug',
      9: 'Sept',
      10: 'Okt',
      11: 'Nov',
      12: 'Dez',
    };

    const monthsEn = <int, String>{
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    final locale = Localizations.localeOf(context).languageCode.toLowerCase();
    final month = locale == 'de' ? monthsDe[date.month]! : monthsEn[date.month]!;
    return '${date.day}\n$month';
  }
}

class _SingleBar extends StatelessWidget {
  const _SingleBar({
    required this.value,
    required this.heightFactor,
    required this.color,
  });

  final double value;
  final double heightFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final factor = heightFactor.isFinite ? heightFactor.clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value <= 0 ? '' : _compact(value),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Container(
          width: 16,
          height: 120 * factor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  String _compact(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _StatsBarValue {
  const _StatsBarValue({
    required this.leftValue,
    required this.rightValue,
    required this.label,
    required this.date,
  });

  final double leftValue;
  final double rightValue;
  final String label;
  final DateTime date;
}