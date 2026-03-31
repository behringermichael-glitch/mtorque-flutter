import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../domain/repositories/strength_repository.dart';
import 'anatomy_asset_resolver.dart';
import 'anatomy_models.dart';
import 'muscle_info_repository.dart';

class ExerciseMusclesBottomSheet extends StatefulWidget {
  const ExerciseMusclesBottomSheet({
    super.key,
    required this.exerciseId,
    required this.exerciseLabel,
    required this.muscles,
  });

  final String exerciseId;
  final String exerciseLabel;
  final List<StrengthExerciseMuscleUsage> muscles;

  @override
  State<ExerciseMusclesBottomSheet> createState() =>
      _ExerciseMusclesBottomSheetState();
}

class _ExerciseMusclesBottomSheetState
    extends State<ExerciseMusclesBottomSheet> {
  String? _selectedMuscle;

  @override
  void initState() {
    super.initState();
    MuscleInfoRepository.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    final primary = widget.muscles
        .where((e) => e.role == StrengthMuscleRole.primary)
        .map(
          (e) => AnatomyMuscleUsage(
        muscleName: e.muscleName,
        groupName: e.groupNameForLanguageCode(languageCode),
        role: AnatomyMuscleRole.primary,
      ),
    )
        .toList()
      ..sort(
            (a, b) => a.muscleName.toLowerCase().compareTo(
          b.muscleName.toLowerCase(),
        ),
      );

    final secondary = widget.muscles
        .where((e) => e.role == StrengthMuscleRole.secondary)
        .map(
          (e) => AnatomyMuscleUsage(
        muscleName: e.muscleName,
        groupName: e.groupNameForLanguageCode(languageCode),
        role: AnatomyMuscleRole.secondary,
      ),
    )
        .toList()
      ..sort(
            (a, b) => a.muscleName.toLowerCase().compareTo(
          b.muscleName.toLowerCase(),
        ),
      );

    final all = <AnatomyMuscleUsage>[
      ...primary,
      ...secondary,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: FutureBuilder<void>(
        future: MuscleInfoRepository.ensureLoaded(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Text(
                widget.exerciseLabel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _SkeletonCard(
                allMuscles: all,
                selectedMuscle: _selectedMuscle,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  l10n.strengthExerciseMuscleZoomHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.72),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MuscleSectionList(
                        title: l10n.strengthExercisePrimaryMuscles,
                        items: primary,
                        selectedMuscle: _selectedMuscle,
                        onMuscleTap: _handleMuscleTap,
                      ),
                      const SizedBox(height: 14),
                      _MuscleSectionList(
                        title: l10n.strengthExerciseSecondaryMuscles,
                        items: secondary,
                        selectedMuscle: _selectedMuscle,
                        onMuscleTap: _handleMuscleTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleMuscleTap(String muscleName) {
    setState(() {
      _selectedMuscle = _selectedMuscle == muscleName ? null : muscleName;
    });
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.allMuscles,
    required this.selectedMuscle,
  });

  final List<AnatomyMuscleUsage> allMuscles;
  final String? selectedMuscle;

  @override
  Widget build(BuildContext context) {
    final cardColor =
    AppTheme.anatomyPanelBackground(Theme.of(context).brightness);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _SkeletonPanel(
              side: AnatomySide.front,
              allMuscles: allMuscles,
              selectedMuscle: selectedMuscle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SkeletonPanel(
              side: AnatomySide.back,
              allMuscles: allMuscles,
              selectedMuscle: selectedMuscle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPanel extends StatefulWidget {
  const _SkeletonPanel({
    required this.side,
    required this.allMuscles,
    required this.selectedMuscle,
  });

  final AnatomySide side;
  final List<AnatomyMuscleUsage> allMuscles;
  final String? selectedMuscle;

  @override
  State<_SkeletonPanel> createState() => _SkeletonPanelState();
}

class _SkeletonPanelState extends State<_SkeletonPanel>
    with SingleTickerProviderStateMixin {
  late final TransformationController _controller;
  late final AnimationController _animationController;

  Animation<Matrix4>? _matrixAnimation;
  TapDownDetails? _lastDoubleTapDown;

  double _currentScale = 1.0;

  static const double _zoomLevelOne = 2.0;
  static const double _zoomLevelTwo = 3.2;

  @override
  void initState() {
    super.initState();

    _controller = TransformationController();
    _controller.addListener(_handleMatrixChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
      final animation = _matrixAnimation;
      if (animation != null) {
        _controller.value = animation.value;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.removeListener(_handleMatrixChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleMatrixChanged() {
    final nextScale = _controller.value.getMaxScaleOnAxis();
    if ((nextScale - _currentScale).abs() < 0.001) {
      return;
    }

    if (mounted) {
      setState(() {
        _currentScale = nextScale;
      });
    }
  }

  void _animateTo(Matrix4 target) {
    _animationController.stop();

    _matrixAnimation = Matrix4Tween(
      begin: _controller.value,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController
      ..reset()
      ..forward();
  }

  void _handleDoubleTap() {
    final tapPosition = _lastDoubleTapDown?.localPosition;
    final currentScale = _currentScale;

    if (currentScale < 1.2) {
      _animateTo(_matrixForScaleAtTap(_zoomLevelOne, tapPosition));
      return;
    }

    if (currentScale < 2.5) {
      _animateTo(_matrixForScaleAtTap(_zoomLevelTwo, tapPosition));
      return;
    }

    _animateTo(Matrix4.identity());
  }

  Matrix4 _matrixForScaleAtTap(double scale, Offset? tapPosition) {
    if (tapPosition == null) {
      return Matrix4.identity()..scale(scale);
    }

    return Matrix4.identity()
      ..translate(
        -tapPosition.dx * (scale - 1),
        -tapPosition.dy * (scale - 1),
      )
      ..scale(scale);
  }

  @override
  Widget build(BuildContext context) {
    final isZoomed = _currentScale > 1.01;

    return AspectRatio(
      aspectRatio: 0.46,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTapDown: (details) {
            _lastDoubleTapDown = details;
          },
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1,
            maxScale: _zoomLevelTwo,
            panEnabled: isZoomed,
            scaleEnabled: true,
            constrained: true,
            boundaryMargin: const EdgeInsets.all(140),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AnatomyAssetResolver.skeletonForSide(widget.side),
                  fit: BoxFit.contain,
                ),
                for (final muscle in widget.allMuscles)
                  _OverlayLayer(
                    side: widget.side,
                    muscle: muscle,
                    selectedMuscle: widget.selectedMuscle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayLayer extends StatelessWidget {
  const _OverlayLayer({
    required this.side,
    required this.muscle,
    required this.selectedMuscle,
  });

  final AnatomySide side;
  final AnatomyMuscleUsage muscle;
  final String? selectedMuscle;

  @override
  Widget build(BuildContext context) {
    final assetPath = AnatomyAssetResolver.overlayPathFor(
      side: side,
      muscleName: muscle.muscleName,
    );

    if (assetPath == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(_resolveColor(), BlendMode.srcIn),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Color _resolveColor() {
    if (selectedMuscle != null && selectedMuscle != muscle.muscleName) {
      return AppTheme.anatomyInactiveMuscle;
    }

    switch (muscle.role) {
      case AnatomyMuscleRole.primary:
        return AppTheme.anatomyPrimaryMuscle;
      case AnatomyMuscleRole.secondary:
        return AppTheme.anatomySecondaryMuscle;
    }
  }
}

class _MuscleSectionList extends StatelessWidget {
  const _MuscleSectionList({
    required this.title,
    required this.items,
    required this.selectedMuscle,
    required this.onMuscleTap,
  });

  final String title;
  final List<AnatomyMuscleUsage> items;
  final String? selectedMuscle;
  final ValueChanged<String> onMuscleTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = items.isNotEmpty &&
        items.first.role == AnatomyMuscleRole.primary
        ? AppTheme.anatomyPrimaryMuscle
        : AppTheme.anatomySecondaryMuscle;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in items)
            _MuscleTile(
              item: item,
              isSelected: selectedMuscle == item.muscleName,
              onTap: () => onMuscleTap(item.muscleName),
            ),
        ],
      ),
    );
  }
}

class _MuscleTile extends StatelessWidget {
  const _MuscleTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AnatomyMuscleUsage item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final info = MuscleInfoRepository.findByMuscleName(item.muscleName);

    final detailBackground =
    AppTheme.anatomyPanelBackground(Theme.of(context).brightness);

    final stripeColor = item.role == AnatomyMuscleRole.primary
        ? AppTheme.anatomyPrimaryMuscle
        : AppTheme.anatomySecondaryMuscle;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Text(
                    '• ${item.muscleName} (${item.groupName})',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6, bottom: 12),
                decoration: BoxDecoration(
                  color: detailBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 6,
                        decoration: BoxDecoration(
                          color: stripeColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoBlock(
                                label: l10n.muscleLabelFunction,
                                value: info?.functionForLanguage(languageCode) ?? '',
                              ),
                              _InfoBlock(
                                label: l10n.muscleLabelOrigin,
                                value: info?.originForLanguage(languageCode) ?? '',
                              ),
                              _InfoBlock(
                                label: l10n.muscleLabelInsertion,
                                value:
                                info?.insertionForLanguage(languageCode) ?? '',
                              ),
                              _InfoBlock(
                                label: l10n.muscleLabelInnervation,
                                value: info?.innervation ?? '',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cleanedLines = value
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.replaceFirst(RegExp(r'^•\s*'), ''))
        .toList();

    if (cleanedLines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          for (final line in cleanedLines)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text('•'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      line,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}