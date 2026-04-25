import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/set_entry.dart';
import '../../domain/repositories/strength_repository.dart';
import '../state/strength_flow_controller.dart';
import '../state/strength_providers.dart';
import 'exercise_asset_resolver.dart';
import '../widgets/anatomy/exercise_muscles_bottom_sheet.dart';

class StartRestTimerNotification extends Notification {
  const StartRestTimerNotification();
}

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({
    super.key,
    required this.exerciseId,
    this.onHeaderDividerGlobalYChanged,
  });

  final String exerciseId;
  final ValueChanged<double>? onHeaderDividerGlobalYChanged;

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  static const int _modBlood = 1;
  static const int _modChain = 2;
  static const int _modEqual = 4;

  final GlobalKey _headerDividerKey = GlobalKey();

  Timer? _pendingSync;
  final Set<int> _focusedRows = <int>{};
  bool _keyboardWasVisibleWhileRowFocused = false;
  // PATCH 3-A: ValueNotifier ersetzt setState() für den Compact-Header.
  // Nur der Offstage-Subtree wird neu gebaut, nicht der gesamte FutureBuilder-Stack.
  late final ValueNotifier<bool> _compactHeaderNotifier;

  late Future<StrengthExerciseSummary?> _exerciseFuture;
  late Future<StrengthExerciseStats> _statsFuture;
  bool _headerReportQueued = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // PATCH 3-B: Notifier vor den Futures initialisieren.
    _compactHeaderNotifier = ValueNotifier(false);
    _preparePageFutures();
    _scheduleHeaderDividerReport();
  }

  @override
  void didUpdateWidget(covariant ExercisePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.exerciseId != widget.exerciseId) {
      _focusedRows.clear();
      // PATCH 3-C: Notifier beim Exercise-Wechsel synchron zurücksetzen.
      _compactHeaderNotifier.value = false;
      _preparePageFutures();
      _scheduleHeaderDividerReport();
      return;
    }

    if (oldWidget.onHeaderDividerGlobalYChanged !=
        widget.onHeaderDividerGlobalYChanged &&
        widget.onHeaderDividerGlobalYChanged != null &&
        _focusedRows.isEmpty) {
      _scheduleHeaderDividerReport();
    }
  }

  void _preparePageFutures() {
    final repository = ref.read(strengthRepositoryProvider);
    _exerciseFuture = repository.getExerciseById(widget.exerciseId);
    _statsFuture = _exerciseFuture.then(
          (exercise) => repository.loadExerciseStats(
        exerciseId: widget.exerciseId,
        isStaticExercise: exercise?.isStatic ?? false,
      ),
    );
    // PATCH 4: Asset-Pfad vorwärmen, damit beim ersten Render kein Lookup-Jank entsteht.
    ExerciseAssetResolver.warmUp(widget.exerciseId);
  }

  void _scheduleHeaderDividerReport() {
    if (_headerReportQueued) return;
    _headerReportQueued = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerReportQueued = false;
      if (!mounted) return;

      final callback = widget.onHeaderDividerGlobalYChanged;
      if (callback == null) return;
      if (_focusedRows.isNotEmpty) return;

      final dividerContext = _headerDividerKey.currentContext;
      if (dividerContext == null) return;
      final renderObject = dividerContext.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return;

      final globalCenter = renderObject.localToGlobal(
        Offset(0, renderObject.size.height / 2),
      );
      callback(globalCenter.dy);
    });
  }

  void _reportHeaderHidden() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onHeaderDividerGlobalYChanged?.call(-1);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // PATCH 3-D: Notifier vor dem super.dispose() freigeben.
    _compactHeaderNotifier.dispose();
    _pendingSync?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  bool _isKeyboardVisibleFromView() {
    final view = View.of(context);
    return view.viewInsets.bottom > 0;
  }

  // PATCH 3-E: setState(() {}) entfernt — nur noch Notifier-Update.
  // Dadurch wird beim Focus-Wechsel (Tastatur auf/zu) kein kompletter
  // FutureBuilder-Rebuild mehr ausgelöst.
  void _handleRowFocusChanged(int rowIndex, bool isFocused) {
    final wasCompact = _focusedRows.isNotEmpty;

    final changed = isFocused
        ? _focusedRows.add(rowIndex)
        : _focusedRows.remove(rowIndex);

    if (!isFocused && _focusedRows.isEmpty) {
      _keyboardWasVisibleWhileRowFocused = false;
    }

    if (!changed || !mounted) return;

    final isCompact = _focusedRows.isNotEmpty;

    _compactHeaderNotifier.value = isCompact;

    if (isCompact) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (_isKeyboardVisibleFromView()) {
          _keyboardWasVisibleWhileRowFocused = true;
        }
      });
    }

    if (wasCompact == isCompact) return;

    if (isCompact) {
      _reportHeaderHidden();
    } else {
      _scheduleHeaderDividerReport();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncKeyboardDismissalWithHeaderState();
    });
  }

  void _syncKeyboardDismissalWithHeaderState() {
    if (_focusedRows.isEmpty) {
      _keyboardWasVisibleWhileRowFocused = false;
      return;
    }

    final keyboardIsVisible = _isKeyboardVisibleFromView();

    if (keyboardIsVisible) {
      _keyboardWasVisibleWhileRowFocused = true;
      return;
    }

    if (!_keyboardWasVisibleWhileRowFocused) {
      return;
    }

    _keyboardWasVisibleWhileRowFocused = false;
    _clearFocusedInputRowsAfterKeyboardDismiss();
  }

  void _clearFocusedInputRowsAfterKeyboardDismiss() {
    FocusScope.of(context).unfocus(disposition: UnfocusDisposition.scope);
    FocusManager.instance.primaryFocus?.unfocus();

    if (_focusedRows.isEmpty) {
      return;
    }

    _focusedRows.clear();
    _compactHeaderNotifier.value = false;
    _scheduleHeaderDividerReport();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final flow = ref.read(strengthFlowControllerProvider.notifier);
    final repository = ref.read(strengthRepositoryProvider);

    final list = ref.watch(
      strengthFlowControllerProvider.select(
            (state) => state.draftSession?.setsByExercise[widget.exerciseId] ??
            const <SetEntry>[],
      ),
    );

    // PATCH 3-F: `final compactHeader = _focusedRows.isNotEmpty` entfernt.
    // Der Wert kommt jetzt ausschließlich aus dem ValueListenableBuilder unten.

    return RepaintBoundary(
      child: FutureBuilder<StrengthExerciseSummary?>(
        future: _exerciseFuture,
        builder: (context, snapshot) {
          final exercise = snapshot.data;
          final isStatic = exercise?.isStatic ?? false;
          final hasExerciseLoaded =
              snapshot.connectionState == ConnectionState.done;
          final exerciseName = hasExerciseLoaded ? (exercise?.label ?? '') : '';

          return FutureBuilder<StrengthExerciseStats>(
            future: _statsFuture,
            builder: (context, statsSnapshot) {
              final suggestions =
              _buildLastSessionSuggestions(statsSnapshot.data);

              return Column(
                children: [
                  // PATCH 3-F: ValueListenableBuilder isoliert den Offstage-Rebuild.
                  // Wenn der User eine Eingabe fokussiert oder verlässt, baut nur
                  // dieser Subtree neu — nicht die ListView, nicht die FutureBuilder.
                  ValueListenableBuilder<bool>(
                    valueListenable: _compactHeaderNotifier,
                    builder: (context, compactHeader, _) => Offstage(
                      offstage: compactHeader,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ExerciseHeader(
                            exerciseId: widget.exerciseId,
                            exerciseName: exerciseName,
                            animateImage: true,
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
                              final confirmed =
                              await _confirmDeleteExercise(context);
                              if (!mounted || confirmed != true) return;
                              await flow.removeExercise(widget.exerciseId);
                            },
                          ),
                          _ExerciseSectionDivider(
                            dividerKey: _headerDividerKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      child: ListView.builder(
                        key: PageStorageKey<String>(
                          'exercise_list_${widget.exerciseId}',
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                        itemCount: list.length,
                        cacheExtent: 400,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          final suggestion = suggestions[index + 1];

                          return RepaintBoundary(
                            child: _SetRow(
                              key: ValueKey(
                                'set_row_${widget.exerciseId}_$index',
                              ),
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
                                final updatedEntry =
                                await _showMarkerBottomSheet(
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
                                const StartRestTimerNotification()
                                    .dispatch(context);
                              },
                            ),
                          );
                        },
                      ),
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
      ),
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
                  duration: const Duration(milliseconds: 260),
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
      enableDrag: true,
      isDismissible: true,
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
                    _ExerciseInstructionText(
                      text: instruction.trim().isEmpty
                          ? l10n.strengthExerciseNoDescriptionAvailable
                          : instruction.trim(),
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
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (sheetContext) {
        return FutureBuilder<StrengthExerciseDetail?>(
          future: repository.getExerciseDetail(exerciseId),
          builder: (context, snapshot) {
            final detail = snapshot.data;

            if (detail == null &&
                snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final muscles = detail?.muscles ?? const <StrengthExerciseMuscleUsage>[];

            return ExerciseMusclesBottomSheet(
              exerciseId: exerciseId,
              exerciseLabel: detail?.label ?? exerciseId,
              muscles: muscles,
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

class _ExerciseInstructionText extends StatelessWidget {
  const _ExerciseInstructionText({
    required this.text,
  });

  final String text;

  static final RegExp _bulletPattern = RegExp(r'^\s*(?:[-*•‣▪])\s+');
  static final RegExp _numberedPattern = RegExp(r'^\s*\d+[.)]\s+');

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trimRight())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines) _buildLine(context, line, textStyle),
      ],
    );
  }

  Widget _buildLine(
      BuildContext context,
      String line,
      TextStyle? textStyle,
      ) {
    if (line.trim().isEmpty) {
      return const SizedBox(height: 8);
    }

    final trimmedLine = line.trimLeft();

    final bulletMatch = _bulletPattern.firstMatch(trimmedLine);
    if (bulletMatch != null) {
      final bulletText = trimmedLine.substring(bulletMatch.end).trimLeft();

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '•',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                bulletText,
                style: textStyle,
              ),
            ),
          ],
        ),
      );
    }

    final numberedMatch = _numberedPattern.firstMatch(trimmedLine);
    if (numberedMatch != null) {
      final numberLabel = trimmedLine.substring(
        numberedMatch.start,
        numberedMatch.end,
      ).trim();

      final numberedText = trimmedLine.substring(numberedMatch.end).trimLeft();

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                numberLabel,
                style: textStyle,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                numberedText,
                style: textStyle,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        trimmedLine,
        style: textStyle,
      ),
    );
  }
}

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({
    required this.exerciseId,
    required this.exerciseName,
    required this.animateImage,
    required this.onInfo,
    required this.onMuscles,
    required this.onStats,
    required this.onDelete,
  });

  final String exerciseId;
  final String exerciseName;
  final bool animateImage;
  final VoidCallback onInfo;
  final VoidCallback onMuscles;
  final VoidCallback onStats;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final iconColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.84);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: RepaintBoundary(
              child: ExerciseAssetImage(
                exerciseId: exerciseId,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(14),
                placeholderIcon: Icons.image_not_supported_outlined,
                animate: animateImage,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: exerciseName.trim().isEmpty
                        ? const SizedBox(height: 72)
                        : LayoutBuilder(
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
                            height: 1.20,
                            fontSize: compactFontSize,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
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

class _ExerciseSectionDivider extends StatelessWidget {
  const _ExerciseSectionDivider({
    required this.dividerKey,
  });

  final GlobalKey dividerKey;

  @override
  Widget build(BuildContext context) {
    final dividerColor =
    Theme.of(context).dividerColor.withValues(alpha: 0.55);

    return SizedBox(
      height: 24,
      child: Row(
        children: [
          const SizedBox(width: 28),
          Expanded(
            child: Container(
              key: dividerKey,
              height: 1,
              color: dividerColor,
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
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

class _SetRowState extends State<_SetRow> with WidgetsBindingObserver {
  late final TextEditingController _loadController;
  late final TextEditingController _secondController;
  late final FocusNode _loadFocusNode;
  late final FocusNode _secondFocusNode;
  bool _lastAnyFocus = false;
  bool _keyboardVisibleWhileFocused = false;
  bool _lastLoadFocus = false;
  bool _lastSecondFocus = false;
  bool _acceptSecondSuggestionOnBlur = false;
  bool _secondEditedSinceFocus = false;
  String _lastSecondText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadController = TextEditingController(
      text: formatNumber(widget.value.load),
    );
    _secondController = TextEditingController(
      text: widget.isStatic
          ? formatInt(widget.value.durationSec)
          : formatNumber(widget.value.reps),
    );
    _loadFocusNode = FocusNode()..addListener(_handleFocusUpdate);
    _secondFocusNode = FocusNode()..addListener(_handleFocusUpdate);
  }

  @override
  void didUpdateWidget(covariant _SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_loadFocusNode.hasFocus) {
      final next = formatNumber(widget.value.load);
      if (_loadController.text != next) {
        _loadController.text = next;
      }
    }

    if (!_secondFocusNode.hasFocus) {
      final next = widget.isStatic
          ? formatInt(widget.value.durationSec)
          : formatNumber(widget.value.reps);
      if (_secondController.text != next) {
        _secondController.text = next;
      }
      _lastSecondText = next.trim();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

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

  bool _isKeyboardVisibleFromView() {
    final view = View.of(context);
    return view.viewInsets.bottom > 0;
  }

  void _handleFocusUpdate() {
    final anyFocus = _loadFocusNode.hasFocus || _secondFocusNode.hasFocus;

    if (!anyFocus) {
      _keyboardVisibleWhileFocused = false;
    }

    if (anyFocus != _lastAnyFocus) {
      _lastAnyFocus = anyFocus;
      widget.onInputFocusChanged(anyFocus);
    }

    if (anyFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (_isKeyboardVisibleFromView()) {
          _keyboardVisibleWhileFocused = true;
        }
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _submitLoadField() {
    _acceptLoadSuggestionOnly();
    _secondFocusNode.requestFocus();
  }

  void _submitSecondField() {
    _acceptSecondSuggestionOnly();
    widget.onCompleted();

    _loadFocusNode.unfocus();
    _secondFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool _loadMatchesSuggestion(String value) {
    final parsed = tryParseDouble(value);
    final suggestion = widget.suggestedLoad;

    if (parsed == null || suggestion == null) {
      return false;
    }

    return (parsed - suggestion).abs() <= 0.05;
  }

  void _acceptLoadSuggestionOnly() {
    final suggestedLoad = widget.suggestedLoad;
    if (suggestedLoad == null) return;

    final loadText = _loadController.text.trim();
    if (loadText.isNotEmpty) return;

    final nextText = formatNumber(suggestedLoad);

    _loadController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );

    widget.onChanged(
      widget.value.copyWith(load: suggestedLoad),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _acceptSecondSuggestionOnly() {
    final suggestedSecond = widget.suggestedSecond;
    final suggestedLoad = widget.suggestedLoad;

    if (suggestedSecond == null || suggestedLoad == null) return;

    final secondText = _secondController.text.trim();
    if (secondText.isNotEmpty) return;

    final loadText = _loadController.text.trim();
    if (!_loadMatchesSuggestion(loadText)) return;

    if (widget.isStatic) {
      final nextDuration = suggestedSecond.round();
      final nextText = formatInt(nextDuration);

      _secondController.value = TextEditingValue(
        text: nextText,
        selection: TextSelection.collapsed(offset: nextText.length),
      );

      _lastSecondText = nextText.trim();

      widget.onChanged(
        widget.value.copyWith(durationSec: nextDuration),
      );
    } else {
      final nextText = formatNumber(suggestedSecond);

      _secondController.value = TextEditingValue(
        text: nextText,
        selection: TextSelection.collapsed(offset: nextText.length),
      );

      _lastSecondText = nextText.trim();

      widget.onChanged(
        widget.value.copyWith(reps: suggestedSecond),
      );
    }

    widget.onStartRestTimer();

    if (mounted) {
      setState(() {});
    }
  }

  String _secondaryHint(AppLocalizations l10n) {
    final base = widget.isStatic
        ? l10n.strengthCommonDurationShort
        : l10n.strengthCommonRepsShort;

    if (_secondController.text.trim().isNotEmpty) {
      return base;
    }

    if (widget.suggestedSecond == null || widget.suggestedLoad == null) {
      return base;
    }

    final suggestionsShouldBeVisible =
        _loadFocusNode.hasFocus || _secondFocusNode.hasFocus;

    if (!suggestionsShouldBeVisible) {
      return base;
    }

    final loadText = _loadController.text.trim();

    if (loadText.isEmpty || _loadMatchesSuggestion(loadText)) {
      return widget.isStatic
          ? formatInt(widget.suggestedSecond!.round())
          : formatNumber(widget.suggestedSecond);
    }

    return base;
  }

  String _loadHint(AppLocalizations l10n) {
    if (_loadController.text.trim().isNotEmpty) {
      return '';
    }

    final suggestionsShouldBeVisible =
        _loadFocusNode.hasFocus || _secondFocusNode.hasFocus;

    if (suggestionsShouldBeVisible && widget.suggestedLoad != null) {
      return formatNumber(widget.suggestedLoad);
    }

    return l10n.strengthCommonKgLabel;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncKeyboardVisibilityFromMetrics();
    });
  }

  void _syncKeyboardVisibilityFromMetrics() {
    final rowHasFocus = _loadFocusNode.hasFocus || _secondFocusNode.hasFocus;

    if (!rowHasFocus) {
      _keyboardVisibleWhileFocused = false;
      return;
    }

    final keyboardIsVisible = _isKeyboardVisibleFromView();

    if (keyboardIsVisible) {
      _keyboardVisibleWhileFocused = true;
      return;
    }

    if (!_keyboardVisibleWhileFocused) {
      return;
    }

    _keyboardVisibleWhileFocused = false;
    _clearInputFocusAfterKeyboardDismiss();
  }

  void _clearInputFocusAfterKeyboardDismiss() {
    _loadFocusNode.unfocus();
    _secondFocusNode.unfocus();
    FocusScope.of(context).unfocus(disposition: UnfocusDisposition.scope);
    FocusManager.instance.primaryFocus?.unfocus();

    if (_lastAnyFocus) {
      _lastAnyFocus = false;
      widget.onInputFocusChanged(false);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final lineColor = onSurface.withValues(alpha: 0.56);
    final deleteBg = onSurface.withValues(alpha: 0.10);
    final deleteFg = onSurface.withValues(alpha: 0.84);
    final hasMarker = widget.value.mods != 0 || widget.value.superSlowEnabled;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 54,
            child: Center(
              child: Text(
                '${widget.index + 1}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _UnderlineNumberField(
              controller: _loadController,
              focusNode: _loadFocusNode,
              hintText: _loadHint(l10n),
              lineColor: lineColor,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              hintColor: onSurface.withValues(alpha: 0.38),
              onChanged: (value) {
                _secondEditedSinceFocus = true;
                _acceptSecondSuggestionOnBlur = false;

                widget.onChanged(
                  widget.value.copyWith(load: tryParseDouble(value)),
                );
                if (mounted) {
                  setState(() {});
                }
              },
              onSubmitted: (_) => _submitLoadField(),
              onEditingComplete: _submitLoadField,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _UnderlineNumberField(
              controller: _secondController,
              focusNode: _secondFocusNode,
              hintText: _secondaryHint(l10n),
              lineColor: lineColor,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              hintColor: onSurface.withValues(alpha: 0.38),
              onChanged: (value) {
                _secondEditedSinceFocus = true;
                _acceptSecondSuggestionOnBlur = false;

                if (widget.isStatic) {
                  widget.onChanged(
                    widget.value.copyWith(
                      durationSec: int.tryParse(value.trim()),
                    ),
                  );
                } else {
                  widget.onChanged(
                    widget.value.copyWith(reps: tryParseDouble(value)),
                  );
                }

                final trimmed = value.trim();
                final shouldStart = _lastSecondText.isEmpty && trimmed.isNotEmpty;
                _lastSecondText = trimmed;
                if (shouldStart) {
                  widget.onStartRestTimer();
                }

                if (mounted) {
                  setState(() {});
                }
              },
              onSubmitted: (_) => _submitSecondField(),
              onEditingComplete: _submitSecondField,

            ),
          ),
          const SizedBox(width: 14),
          _AllOutIconButton(
            selected: widget.value.allOut,
            onTap: () {
              widget.onChanged(
                widget.value.copyWith(allOut: !widget.value.allOut),
              );
            },
          ),
          const SizedBox(width: 12),
          _MarkerButton(
            selected: hasMarker,
            onTap: () => widget.onOpenMarkers(),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 44,
            height: 34,
            child: Center(
              child: Material(
                color: deleteBg,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onDelete,
                  child: SizedBox(
                    width: 44,
                    height: 34,
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
    return value
        .toString()
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
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
    required this.onEditingComplete,
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
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    final active = focusNode.hasFocus || hasValue;
    final borderWidth = active ? 1.8 : 1.2;
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.0,
      fontSize: 18,
    );

    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: textStyle,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: textStyle?.copyWith(
            color: hintColor,
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: lineColor,
              width: borderWidth,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: lineColor,
              width: borderWidth,
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 16, bottom: 4),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
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

    final visibleDays = [...stats.days]..sort((a, b) => a.date.compareTo(b.date));
    final bars = <_StatsBarValue>[];

    for (final day in visibleDays) {
      if (_selectedSetNumber == null) {
        if (day.totalLoad <= 0 || day.totalSecondValue <= 0) continue;

        bars.add(
          _StatsBarValue(
            leftValue: day.totalLoad,
            rightValue: day.totalSecondValue,
            label: _formatTonnage(day.tonnage, context),
            date: day.date,
          ),
        );
        continue;
      }

      StrengthExerciseStatsSetPoint? point;
      for (final candidate in day.perSet) {
        if (candidate.setNumber == _selectedSetNumber) {
          point = candidate;
          break;
        }
      }

      if (point == null) continue;
      if (point.load <= 0 || point.secondValue <= 0) continue;

      bars.add(
        _StatsBarValue(
          leftValue: point.load,
          rightValue: point.secondValue,
          label: _formatTonnage(point.load * point.secondValue, context),
          date: day.date,
        ),
      );
    }

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
    final valueTons = value <= 0 ? 0.0 : value / 1000.0;

    return l10n.strengthExerciseTonnageLabel(
      double.parse(valueTons.toStringAsFixed(2)),
    );
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
    final brightness = Theme.of(context).brightness;
    final colors = _StatsChartColors(
      plotBackground: AppTheme.statsPlotBackground(brightness),
      leftBar: AppTheme.statsLeftBar(brightness),
      rightBar: AppTheme.statsRightBar(brightness),
      tonnageBackground: AppTheme.statsTonnageBackground,
      tonnageText: AppTheme.statsTonnageText,
      axis: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
      grid: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.22),
      text: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
    );

    final visibleBars = bars
        .where((bar) => bar.leftValue > 0 || bar.rightValue > 0)
        .toList(growable: false);

    return Material(
      color: colors.plotBackground,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        width: double.infinity,
        child: CustomPaint(
          painter: _StatsChartPainter(
            bars: visibleBars,
            leftLegend: leftLegend,
            rightLegend: rightLegend,
            leftAxisTitle: leftAxisTitle,
            rightAxisTitle: rightAxisTitle,
            languageCode: Localizations.localeOf(context).languageCode,
            colors: colors,
          ),
        ),
      ),
    );
  }
}

class _StatsChartPainter extends CustomPainter {
  _StatsChartPainter({
    required List<_StatsBarValue> bars,
    required this.leftLegend,
    required this.rightLegend,
    required this.leftAxisTitle,
    required this.rightAxisTitle,
    required this.languageCode,
    required this.colors,
  }) : bars = _lastSevenSortedBars(bars);

  final List<_StatsBarValue> bars;
  final String leftLegend;
  final String rightLegend;
  final String leftAxisTitle;
  final String rightAxisTitle;
  final String languageCode;
  final _StatsChartColors colors;

  static List<_StatsBarValue> _lastSevenSortedBars(List<_StatsBarValue> bars) {
    final sorted = [...bars]..sort((a, b) => a.date.compareTo(b.date));
    if (sorted.length <= 7) return sorted;
    return sorted.sublist(sorted.length - 7);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (bars.isEmpty) {
      return;
    }

    const padTop = 16.0;
    const padInnerLeft = 4.0;
    const padInnerRight = 4.0;

    final textStyle = TextStyle(
      color: colors.text,
      fontSize: 11,
      height: 1.0,
    );
    final labelStyle = TextStyle(
      color: colors.text,
      fontSize: 10,
      height: 1.0,
    );
    final axisTitleStyle = TextStyle(
      color: colors.text,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
    final legendStyle = TextStyle(
      color: colors.text,
      fontSize: 12,
      height: 1.0,
    );
    final tonnageStyle = TextStyle(
      color: colors.tonnageText,
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );

    final leftScale = _StatsScale.fromValues(bars.map((e) => e.leftValue));
    final rightScale = _StatsScale.fromValues(bars.map((e) => e.rightValue));

    final leftLabelWidth = leftScale.ticks.fold<double>(
      0,
          (maxWidth, tick) => math.max(
        maxWidth,
        _measureText(_formatLeftTick(tick), textStyle).width,
      ),
    );
    final rightLabelWidth = rightScale.ticks.fold<double>(
      0,
          (maxWidth, tick) => math.max(
        maxWidth,
        _measureText(_formatRightTick(tick), textStyle).width,
      ),
    );

    final axisTitleSpace = axisTitleStyle.fontSize! + 14;
    final plotLeft = padInnerLeft + leftLabelWidth + 6 + axisTitleSpace;
    final plotRight =
        size.width - padInnerRight - rightLabelWidth - 6 - axisTitleSpace;

    final bottomPadding = _bottomPadding(textStyle, tonnageStyle, legendStyle);
    final plotTop = padTop;
    final plotBottom = size.height - bottomPadding;

    if (plotRight <= plotLeft || plotBottom <= plotTop) return;

    final axisPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = colors.axis;

    final gridPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colors.grid;

    final leftBarPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = colors.leftBar;

    final rightBarPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = colors.rightBar;

    double mapLeftY(double value) {
      final denominator = math.max(0.000001, leftScale.max - leftScale.min);
      final fraction = (value - leftScale.min) / denominator;
      return plotBottom - fraction * (plotBottom - plotTop);
    }

    double mapRightY(double value) {
      final denominator = math.max(0.000001, rightScale.max - rightScale.min);
      final fraction = (value - rightScale.min) / denominator;
      return plotBottom - fraction * (plotBottom - plotTop);
    }

    _drawGridAndAxes(
      canvas: canvas,
      size: size,
      plotLeft: plotLeft,
      plotRight: plotRight,
      plotTop: plotTop,
      plotBottom: plotBottom,
      leftScale: leftScale,
      rightScale: rightScale,
      textStyle: textStyle,
      axisTitleStyle: axisTitleStyle,
      axisPaint: axisPaint,
      gridPaint: gridPaint,
      mapLeftY: mapLeftY,
      mapRightY: mapRightY,
    );

    final count = bars.length;
    final plotWidth = plotRight - plotLeft;
    final groupWidth = plotWidth / count;
    const barGap = 3.0;
    final barWidth = math.max(0.0, math.min(12.0, (groupWidth - barGap) / 2));

    for (var index = 0; index < bars.length; index++) {
      final bar = bars[index];
      final groupLeft = plotLeft + index * groupWidth;
      final groupRight = groupLeft + groupWidth;
      final centerX = (groupLeft + groupRight) / 2;

      double? leftBarTop;
      double? rightBarTop;
      double? leftBarCenterX;
      double? rightBarCenterX;

      if (bar.leftValue > 0) {
        final x0 = centerX - barGap / 2 - barWidth;
        final x1 = centerX - barGap / 2;
        final y0 = mapLeftY(bar.leftValue);
        canvas.drawRect(Rect.fromLTRB(x0, y0, x1, plotBottom), leftBarPaint);
        leftBarTop = y0;
        leftBarCenterX = (x0 + x1) / 2;
      }

      if (bar.rightValue > 0) {
        final x0 = centerX + barGap / 2;
        final x1 = centerX + barGap / 2 + barWidth;
        final y0 = mapRightY(bar.rightValue);
        canvas.drawRect(Rect.fromLTRB(x0, y0, x1, plotBottom), rightBarPaint);
        rightBarTop = y0;
        rightBarCenterX = (x0 + x1) / 2;
      }

      final minLabelY = plotTop + labelStyle.fontSize!;
      if (leftBarTop != null) {
        final text = _formatLeftValue(bar.leftValue);
        final y = math.max(minLabelY, leftBarTop - 2 - labelStyle.fontSize!);
        _drawText(
          canvas,
          text,
          Offset(leftBarCenterX ?? centerX, y),
          labelStyle,
          align: TextAlign.center,
        );
      }

      if (rightBarTop != null) {
        final text = _formatRightValue(bar.rightValue);
        final y = math.max(minLabelY, rightBarTop - 2 - labelStyle.fontSize!);
        _drawText(
          canvas,
          text,
          Offset(rightBarCenterX ?? centerX, y),
          labelStyle,
          align: TextAlign.center,
        );
      }
    }

    canvas.drawLine(
      Offset(plotLeft, plotBottom),
      Offset(plotRight, plotBottom),
      axisPaint,
    );

    final labelsBottom = _drawXLabels(
      canvas: canvas,
      plotLeft: plotLeft,
      plotRight: plotRight,
      plotBottom: plotBottom,
      textStyle: textStyle,
      tonnageStyle: tonnageStyle,
    );

    _drawLegend(
      canvas: canvas,
      plotLeft: plotLeft,
      plotRight: plotRight,
      labelsBottom: labelsBottom,
      legendStyle: legendStyle,
      leftBarPaint: leftBarPaint,
      rightBarPaint: rightBarPaint,
    );
  }

  void _drawGridAndAxes({
    required Canvas canvas,
    required Size size,
    required double plotLeft,
    required double plotRight,
    required double plotTop,
    required double plotBottom,
    required _StatsScale leftScale,
    required _StatsScale rightScale,
    required TextStyle textStyle,
    required TextStyle axisTitleStyle,
    required Paint axisPaint,
    required Paint gridPaint,
    required double Function(double value) mapLeftY,
    required double Function(double value) mapRightY,
  }) {
    for (final tick in leftScale.ticks) {
      final y = mapLeftY(tick);
      _drawDashedLine(
        canvas,
        Offset(plotLeft, y),
        Offset(plotRight, y),
        gridPaint,
      );
      _drawText(
        canvas,
        _formatLeftTick(tick),
        Offset(plotLeft - 4, y - textStyle.fontSize! * 0.5),
        textStyle,
        align: TextAlign.right,
      );
    }

    for (final tick in rightScale.ticks) {
      final y = mapRightY(tick);
      _drawText(
        canvas,
        _formatRightTick(tick),
        Offset(plotRight + 4, y - textStyle.fontSize! * 0.5),
        textStyle,
      );
    }

    canvas.drawLine(Offset(plotLeft, plotTop), Offset(plotLeft, plotBottom), axisPaint);
    canvas.drawLine(Offset(plotRight, plotTop), Offset(plotRight, plotBottom), axisPaint);

    final midY = (plotTop + plotBottom) / 2;
    final leftTitleX = (4 + plotLeft - 2 - _measureText('0000', textStyle).width) / 2;
    final rightTitleX =
        (plotRight + 2 + _measureText('0000', textStyle).width + size.width - 4) / 2;

    _drawRotatedText(
      canvas,
      leftAxisTitle,
      Offset(leftTitleX, midY),
      axisTitleStyle,
      quarterTurns: -1,
    );

    _drawRotatedText(
      canvas,
      rightAxisTitle,
      Offset(rightTitleX, midY),
      axisTitleStyle,
      quarterTurns: 1,
    );
  }

  double _drawXLabels({
    required Canvas canvas,
    required double plotLeft,
    required double plotRight,
    required double plotBottom,
    required TextStyle textStyle,
    required TextStyle tonnageStyle,
  }) {
    final first = bars.first.date;
    final last = bars.last.date;
    final sameYear = first.year == last.year;

    final lines = sameYear ? 2 : 3;
    final lineHeight = textStyle.fontSize! * 1.10;
    final y1 = plotBottom + textStyle.fontSize! * 1.05;

    final groupWidth = (plotRight - plotLeft) / bars.length;
    final approximateWidth = math.max(
      _measureText('30', textStyle).width,
      math.max(
        _measureText(_monthLabel(first.month), textStyle).width,
        _measureText('2026', textStyle).width,
      ),
    ) + 10;

    final maxLabels = math.max(1, ((plotRight - plotLeft) / approximateWidth).floor());
    final step = math.max(1, (bars.length / maxLabels).ceil());

    var maxBottom = y1 + (lines - 1) * lineHeight;

    for (var index = 0; index < bars.length; index++) {
      if (!(index == 0 || index == bars.length - 1 || index % step == 0)) {
        continue;
      }

      final bar = bars[index];
      final centerX = plotLeft + (index + 0.5) * groupWidth;

      _drawText(
        canvas,
        bar.date.day.toString().padLeft(2, '0'),
        Offset(centerX, y1 - textStyle.fontSize!),
        textStyle,
        align: TextAlign.center,
      );
      _drawText(
        canvas,
        _monthLabel(bar.date.month),
        Offset(centerX, y1 + lineHeight - textStyle.fontSize!),
        textStyle,
        align: TextAlign.center,
      );

      if (!sameYear) {
        _drawText(
          canvas,
          bar.date.year.toString(),
          Offset(centerX, y1 + 2 * lineHeight - textStyle.fontSize!),
          textStyle,
          align: TextAlign.center,
        );
      }

      final lastDateLineY = y1 + (lines - 1) * lineHeight;
      final bottom = _drawTonnageLabel(
        canvas: canvas,
        centerX: centerX,
        baselineY: lastDateLineY + textStyle.fontSize! * 1.9 + 8,
        label: bar.label,
        style: tonnageStyle,
      );

      maxBottom = math.max(maxBottom, bottom);
    }

    return maxBottom;
  }

  double _drawTonnageLabel({
    required Canvas canvas,
    required double centerX,
    required double baselineY,
    required String label,
    required TextStyle style,
  }) {
    final lines = _compactBottomLabelLines(label);
    if (lines.$1.isEmpty) return baselineY;

    const paddingX = 4.0;
    const paddingY = 2.0;
    const lineGap = 1.0;

    final line1Size = _measureText(lines.$1, style);
    final line2Size = lines.$2 == null ? Size.zero : _measureText(lines.$2!, style);
    final textWidth = math.max(line1Size.width, line2Size.width);
    final lineHeight = style.fontSize!;

    final textBlockHeight =
    lines.$2 == null ? lineHeight : lineHeight * 2 + lineGap;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        centerX - textWidth / 2 - paddingX,
        baselineY - textBlockHeight - paddingY / 2,
        centerX + textWidth / 2 + paddingX,
        baselineY + paddingY,
      ),
      const Radius.circular(3),
    );

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = colors.tonnageBackground;

    canvas.drawRRect(rect, paint);

    if (lines.$2 == null) {
      _drawText(
        canvas,
        lines.$1,
        Offset(centerX, baselineY - lineHeight),
        style,
        align: TextAlign.center,
      );
    } else {
      _drawText(
        canvas,
        lines.$1,
        Offset(centerX, baselineY - lineHeight * 2 - lineGap * 0.5),
        style,
        align: TextAlign.center,
      );
      _drawText(
        canvas,
        lines.$2!,
        Offset(centerX, baselineY - lineHeight),
        style,
        align: TextAlign.center,
      );
    }

    return rect.outerRect.bottom;
  }

  void _drawLegend({
    required Canvas canvas,
    required double plotLeft,
    required double plotRight,
    required double labelsBottom,
    required TextStyle legendStyle,
    required Paint leftBarPaint,
    required Paint rightBarPaint,
  }) {
    const boxSize = 11.0;
    const gapBoxText = 6.0;
    const gapEntries = 20.0;

    final leftTextSize = _measureText(leftLegend, legendStyle);
    final rightTextSize = _measureText(rightLegend, legendStyle);

    final width1 = boxSize + gapBoxText + leftTextSize.width;
    final width2 = boxSize + gapBoxText + rightTextSize.width;
    final totalWidth = width1 + gapEntries + width2;

    var x = (plotLeft + plotRight - totalWidth) / 2;
    final y = labelsBottom + legendStyle.fontSize! + 10;
    final boxTop = y - legendStyle.fontSize! * 0.80;
    final boxBottom = boxTop + boxSize;

    canvas.drawRect(Rect.fromLTRB(x, boxTop, x + boxSize, boxBottom), leftBarPaint);
    x += boxSize + gapBoxText;

    _drawText(
      canvas,
      leftLegend,
      Offset(x, y - legendStyle.fontSize!),
      legendStyle,
    );

    x += leftTextSize.width + gapEntries;

    canvas.drawRect(Rect.fromLTRB(x, boxTop, x + boxSize, boxBottom), rightBarPaint);
    x += boxSize + gapBoxText;

    _drawText(
      canvas,
      rightLegend,
      Offset(x, y - legendStyle.fontSize!),
      legendStyle,
    );
  }

  static double _bottomPadding(
      TextStyle textStyle,
      TextStyle tonnageStyle,
      TextStyle legendStyle,
      ) {
    final dateLineHeight = textStyle.fontSize! * 1.10;
    final dateBlockMax = dateLineHeight * 3 + 2;
    final tonBlock = tonnageStyle.fontSize! * 1.6 + 12;
    final legendBlock = legendStyle.fontSize! * 1.4 + 8;
    return 6 + dateBlockMax + tonBlock + legendBlock;
  }

  String _monthLabel(int month) {
    final isGerman = languageCode.toLowerCase().startsWith('de');
    const monthsDe = <int, String>{
      1: 'Jan',
      2: 'Feb',
      3: 'Mär',
      4: 'Apr',
      5: 'Mai',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
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

    return isGerman ? monthsDe[month]! : monthsEn[month]!;
  }

  static Size _measureText(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.size;
  }

  static void _drawText(
      Canvas canvas,
      String text,
      Offset offset,
      TextStyle style, {
        TextAlign align = TextAlign.left,
      }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout();

    final dx = switch (align) {
      TextAlign.center => offset.dx - painter.width / 2,
      TextAlign.right => offset.dx - painter.width,
      _ => offset.dx,
    };

    painter.paint(canvas, Offset(dx, offset.dy));
  }

  static void _drawRotatedText(
      Canvas canvas,
      String text,
      Offset center,
      TextStyle style, {
        required int quarterTurns,
      }) {
    if (text.trim().isEmpty) return;

    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(quarterTurns * math.pi / 2);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  static void _drawDashedLine(
      Canvas canvas,
      Offset start,
      Offset end,
      Paint paint,
      ) {
    const dashWidth = 4.0;
    const dashGap = 4.0;

    final totalDistance = (end - start).distance;
    if (totalDistance <= 0) return;

    final direction = (end - start) / totalDistance;
    var distance = 0.0;

    while (distance < totalDistance) {
      final nextDistance = math.min(distance + dashWidth, totalDistance);
      final dashStart = start + direction * distance;
      final dashEnd = start + direction * nextDistance;
      canvas.drawLine(dashStart, dashEnd, paint);
      distance += dashWidth + dashGap;
    }
  }

  static String _formatLeftTick(double value) {
    if (value.abs() >= 10) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  static String _formatRightTick(double value) {
    return value.toStringAsFixed(0);
  }

  static String _formatLeftValue(double value) {
    if (value.abs() >= 10) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  static String _formatRightValue(double value) {
    return value.toStringAsFixed(0);
  }

  static (String, String?) _compactBottomLabelLines(String label) {
    final raw = label.trim();
    if (raw.isEmpty) return ('', null);

    final match = RegExp(r'^\s*([0-9]+(?:[.,][0-9]+)?)\s*([A-Za-z]+)?\s*$')
        .firstMatch(raw);

    if (match == null) return (raw, null);

    final numberPart = match.group(1)?.replaceAll(',', '.') ?? '';
    final unitPart = match.group(2)?.trim() ?? '';
    final value = double.tryParse(numberPart);

    if (value == null) return (raw, null);

    if (unitPart.toLowerCase() == 'lb' || unitPart.toLowerCase() == 'lbs') {
      if (value.abs() < 1000) {
        final top = value.abs() >= 10 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
        return (top, 'lb');
      }

      return ('${(value / 1000).toStringAsFixed(1)}k', 'lb');
    }

    if (unitPart.toLowerCase() == 't') {
      return (raw.substring(0, raw.length - unitPart.length).trim(), 't');
    }

    return (raw, null);
  }

  @override
  bool shouldRepaint(covariant _StatsChartPainter oldDelegate) {
    return oldDelegate.bars != bars ||
        oldDelegate.leftLegend != leftLegend ||
        oldDelegate.rightLegend != rightLegend ||
        oldDelegate.leftAxisTitle != leftAxisTitle ||
        oldDelegate.rightAxisTitle != rightAxisTitle ||
        oldDelegate.languageCode != languageCode ||
        oldDelegate.colors != colors;
  }
}

class _StatsScale {
  const _StatsScale({
    required this.min,
    required this.max,
    required this.ticks,
  });

  final double min;
  final double max;
  final List<double> ticks;

  factory _StatsScale.fromValues(Iterable<double> values) {
    final validValues = values.where((value) => value.isFinite).toList();
    if (validValues.isEmpty) {
      return const _StatsScale(min: 0, max: 1, ticks: [0, 1]);
    }

    var minValue = validValues.reduce(math.min);
    var maxValue = validValues.reduce(math.max);

    if (minValue >= 0) {
      minValue = 0;
      if (maxValue <= 20) {
        maxValue = 20;
      }
    }

    if (maxValue == minValue) {
      if (minValue == 0) {
        maxValue = 1;
      } else {
        final padding = minValue.abs() * 0.1;
        minValue -= padding;
        maxValue += padding;
      }
    }

    final range = maxValue - minValue;
    if (range <= 0) {
      return _StatsScale(min: minValue, max: maxValue, ticks: [minValue, maxValue]);
    }

    final rawStep = range / 5;
    final step = _niceNumber(rawStep, round: true);
    final niceMin = (minValue / step).floorToDouble() * step;
    final baseMax = (maxValue / step).ceilToDouble() * step;
    final niceMax = baseMax + step;

    final ticks = <double>[];
    var value = niceMin;
    while (value <= niceMax + 1e-9) {
      ticks.add(value);
      value += step;
    }

    return _StatsScale(min: niceMin, max: niceMax, ticks: ticks);
  }

  static double _niceNumber(double range, {required bool round}) {
    if (range <= 0) return 1;

    final exponent = (math.log(range) / math.ln10).floor();
    final fraction = range / math.pow(10, exponent);

    final niceFraction = round
        ? switch (fraction) {
      < 1.5 => 1.0,
      < 3.0 => 2.0,
      < 7.0 => 5.0,
      _ => 10.0,
    }
        : switch (fraction) {
      <= 1.0 => 1.0,
      <= 2.0 => 2.0,
      <= 5.0 => 5.0,
      _ => 10.0,
    };

    return niceFraction * math.pow(10, exponent).toDouble();
  }
}

class _StatsChartColors {
  const _StatsChartColors({
    required this.plotBackground,
    required this.leftBar,
    required this.rightBar,
    required this.tonnageBackground,
    required this.tonnageText,
    required this.axis,
    required this.grid,
    required this.text,
  });

  final Color plotBackground;
  final Color leftBar;
  final Color rightBar;
  final Color tonnageBackground;
  final Color tonnageText;
  final Color axis;
  final Color grid;
  final Color text;

  @override
  bool operator ==(Object other) {
    return other is _StatsChartColors &&
        other.plotBackground == plotBackground &&
        other.leftBar == leftBar &&
        other.rightBar == rightBar &&
        other.tonnageBackground == tonnageBackground &&
        other.tonnageText == tonnageText &&
        other.axis == axis &&
        other.grid == grid &&
        other.text == text;
  }

  @override
  int get hashCode => Object.hash(
    plotBackground,
    leftBar,
    rightBar,
    tonnageBackground,
    tonnageText,
    axis,
    grid,
    text,
  );
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