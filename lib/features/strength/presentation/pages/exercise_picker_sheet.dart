import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/set_entry.dart';
import '../state/strength_providers.dart';
import 'exercise_asset_resolver.dart';

class ExercisePickerSheet extends ConsumerStatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  ConsumerState<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  static const String _allValue = '__all__';

  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = <String>{};

  List<_PickerCatalogRecord> _allItems = const <_PickerCatalogRecord>[];
  List<_PickerCatalogRecord> _visibleItems = const <_PickerCatalogRecord>[];

  bool _loading = true;
  bool _gridMode = true;
  bool _advanced = false;

  String? _selectedMuscleGroup;
  String? _selectedBaseExercise;
  String? _selectedDevice;
  String? _selectedInvolvedMuscleLatin;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    _searchController.addListener(_rebuildVisibleItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_rebuildVisibleItems);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    final records = await _ExerciseCatalogLoader.load();
    if (!mounted) return;

    setState(() {
      _allItems = records.where((e) => !_isExcludedExerciseId(e.id)).toList(growable: false);
      _loading = false;
    });

    _rebuildVisibleItems();
  }

  bool _isExcludedExerciseId(String id) {
    final rx = RegExp(r'^([A-Za-z])?(\d+)([mMfF])?$');
    final match = rx.firstMatch(id.trim());
    final prefix = match?.group(1)?.toUpperCase() ?? '';
    return prefix == 'X';
  }

  List<_PickerCatalogRecord> _pool({
    String? muscle,
    String? base,
    String? device,
    String? primaryMuscle,
  }) {
    return _allItems.where((item) {
      if (muscle != null && !item.muscleGroup.equalsIgnoreCase(muscle)) {
        return false;
      }
      if (base != null && !item.baseExercise.equalsIgnoreCase(base)) {
        return false;
      }
      if (device != null && !item.device.equalsIgnoreCase(device)) {
        return false;
      }
      if (primaryMuscle != null) {
        final matchesPrimary = item.primaryMuscles.any(
              (m) => m.equalsIgnoreCase(primaryMuscle),
        );
        if (!matchesPrimary) {
          return false;
        }
      }
      return true;
    }).toList(growable: false);
  }

  void _rebuildVisibleItems() {
    final query = _searchController.text.trim().toLowerCase();

    final next = _pool(
      muscle: _selectedMuscleGroup,
      base: _selectedBaseExercise,
      device: _selectedDevice,
      primaryMuscle: _advanced ? _selectedInvolvedMuscleLatin : null,
    ).where((item) {
      if (query.isEmpty) {
        return true;
      }

      return item.label.toLowerCase().contains(query) ||
          item.id.toLowerCase().contains(query);
    }).toList(growable: false)
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    if (!mounted) return;

    setState(() {
      _visibleItems = next;
    });
  }

  List<String> _facetValues({
    required String Function(_PickerCatalogRecord item) selector,
    required String facet,
  }) {
    final values = _allItems.where((item) {
      if (facet != 'muscle' &&
          _selectedMuscleGroup != null &&
          !item.muscleGroup.equalsIgnoreCase(_selectedMuscleGroup!)) {
        return false;
      }

      if (facet != 'base' &&
          _selectedBaseExercise != null &&
          !item.baseExercise.equalsIgnoreCase(_selectedBaseExercise!)) {
        return false;
      }

      if (facet != 'device' &&
          _selectedDevice != null &&
          !item.device.equalsIgnoreCase(_selectedDevice!)) {
        return false;
      }

      if (facet != 'primary' &&
          _advanced &&
          _selectedInvolvedMuscleLatin != null &&
          !item.primaryMuscles.any((m) => m.equalsIgnoreCase(_selectedInvolvedMuscleLatin!))) {
        return false;
      }

      return true;
    }).map(selector).where((e) => e.trim().isNotEmpty).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return values;
  }

  List<String> _involvedMuscleFacetValues() {
    final values = _allItems.where((item) {
      if (_selectedMuscleGroup != null &&
          !item.muscleGroup.equalsIgnoreCase(_selectedMuscleGroup!)) {
        return false;
      }

      if (_selectedBaseExercise != null &&
          !item.baseExercise.equalsIgnoreCase(_selectedBaseExercise!)) {
        return false;
      }

      if (_selectedDevice != null &&
          !item.device.equalsIgnoreCase(_selectedDevice!)) {
        return false;
      }

      return true;
    }).expand((item) => item.primaryMuscles).where((e) => e.trim().isNotEmpty).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return values;
  }

  void _normalizeSelections() {
    final muscles = _facetValues(selector: (e) => e.muscleGroup, facet: 'muscle');
    final bases = _facetValues(selector: (e) => e.baseExercise, facet: 'base');
    final devices = _facetValues(selector: (e) => e.device, facet: 'device');
    final primary = _advanced ? _involvedMuscleFacetValues() : const <String>[];

    if (_selectedMuscleGroup != null &&
        !muscles.any((e) => e.equalsIgnoreCase(_selectedMuscleGroup!))) {
      _selectedMuscleGroup = null;
    }

    if (_selectedBaseExercise != null &&
        !bases.any((e) => e.equalsIgnoreCase(_selectedBaseExercise!))) {
      _selectedBaseExercise = null;
    }

    if (_selectedDevice != null &&
        !devices.any((e) => e.equalsIgnoreCase(_selectedDevice!))) {
      _selectedDevice = null;
    }

    if (_advanced &&
        _selectedInvolvedMuscleLatin != null &&
        !primary.any((e) => e.equalsIgnoreCase(_selectedInvolvedMuscleLatin!))) {
      _selectedInvolvedMuscleLatin = null;
    }

    if (!_advanced) {
      _selectedInvolvedMuscleLatin = null;
    }
  }

  Future<void> _confirmSelection() async {
    if (_selectedIds.isEmpty) return;

    final repository = ref.read(strengthRepositoryProvider);
    final selected = <StrengthExerciseSummary>[];

    for (final id in _selectedIds) {
      final item = await repository.getExerciseById(id);
      if (item != null) {
        selected.add(item);
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop(selected);
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    if (_selectedIds.isEmpty) return;

    setState(() {
      _selectedIds.clear();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedMuscleGroup = null;
      _selectedBaseExercise = null;
      _selectedDevice = null;
      _selectedInvolvedMuscleLatin = null;
      _advanced = false;
    });

    _rebuildVisibleItems();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final bottom = mediaQuery.viewInsets.bottom;
    final safeBottom = mediaQuery.padding.bottom;

    _normalizeSelections();

    final muscleGroups = _facetValues(
      selector: (e) => e.muscleGroup,
      facet: 'muscle',
    );
    final baseExercises = _facetValues(
      selector: (e) => e.baseExercise,
      facet: 'base',
    );
    final devices = _facetValues(
      selector: (e) => e.device,
      facet: 'device',
    );
    final involvedMuscles = _advanced
        ? _involvedMuscleFacetValues()
        : const <String>[];

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.strengthExercisePickerSearchHint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
                  child: Row(
                    children: [
                      Text(
                        l10n.strengthExercisePickerFilter,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 8),
                      Builder(
                        builder: (context) {
                          const advancedRed = Color(0xFFFF5A5F);
                          const advancedRedDark = Color(0xFF9E2F2F);

                          return FilterChip(
                            selected: _advanced,
                            showCheckmark: false,
                            shape: const StadiumBorder(),
                            avatar: _advanced
                                ? const CircleAvatar(
                              radius: 10,
                              backgroundColor: advancedRedDark,
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                                : null,
                            label: Text(
                              l10n.strengthExercisePickerAdvanced,
                              style: TextStyle(
                                color: _advanced ? Colors.white : null,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                            side: BorderSide.none,
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                            selectedColor: advancedRed,
                            onSelected: (selected) {
                              setState(() {
                                _advanced = selected;
                                if (!_advanced) {
                                  _selectedInvolvedMuscleLatin = null;
                                }
                              });
                              _rebuildVisibleItems();
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _clearFilters,
                        child: Text(l10n.strengthExercisePickerClearFilters),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                  child: Column(
                    children: [
                      _FilterDropdown(
                        label: l10n.strengthExercisePickerPrimaryMuscleGroup,
                        value: _selectedMuscleGroup ?? _allValue,
                        allValue: _allValue,
                        allLabel: l10n.strengthExercisePickerAll,
                        items: <String>[_allValue, ...muscleGroups],
                        onChanged: (value) {
                          setState(() {
                            _selectedMuscleGroup = value == _allValue ? null : value;
                          });
                          _rebuildVisibleItems();
                        },
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: !_advanced
                            ? const SizedBox.shrink()
                            : Column(
                          key: const ValueKey('advanced_primary_filter'),
                          children: [
                            _FilterDropdown(
                              label: l10n.strengthExercisePickerInvolvedMuscleLatin,
                              value: _selectedInvolvedMuscleLatin ?? _allValue,
                              allValue: _allValue,
                              allLabel: l10n.strengthExercisePickerAll,
                              items: <String>[
                                _allValue,
                                ...involvedMuscles,
                              ],
                              highlighted: true,
                              onChanged: (value) {
                                setState(() {
                                  _selectedInvolvedMuscleLatin =
                                  value == _allValue ? null : value;
                                });
                                _rebuildVisibleItems();
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      _FilterDropdown(
                        label: l10n.strengthExercisePickerBaseExercise,
                        value: _selectedBaseExercise ?? _allValue,
                        allValue: _allValue,
                        allLabel: l10n.strengthExercisePickerAll,
                        items: <String>[_allValue, ...baseExercises],
                        onChanged: (value) {
                          setState(() {
                            _selectedBaseExercise =
                            value == _allValue ? null : value;
                          });
                          _rebuildVisibleItems();
                        },
                      ),
                      const SizedBox(height: 8),
                      _FilterDropdown(
                        label: l10n.strengthExercisePickerDevice,
                        value: _selectedDevice ?? _allValue,
                        allValue: _allValue,
                        allLabel: l10n.strengthExercisePickerAll,
                        items: <String>[_allValue, ...devices],
                        onChanged: (value) {
                          setState(() {
                            _selectedDevice = value == _allValue ? null : value;
                          });
                          _rebuildVisibleItems();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Row(
                    children: [
                      Text(
                        l10n.strengthExercisePickerResults,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      SegmentedButton<bool>(
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          minimumSize: WidgetStateProperty.all(
                            const Size(0, 34),
                          ),
                        ),
                        segments: <ButtonSegment<bool>>[
                          ButtonSegment<bool>(
                            value: false,
                            label: Text(l10n.strengthExercisePickerList),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            label: Text(l10n.strengthExercisePickerImages),
                          ),
                        ],
                        selected: <bool>{_gridMode},
                        onSelectionChanged: (value) {
                          setState(() {
                            _gridMode = value.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _gridMode
                      ? GridView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: _visibleItems.length,
                    itemBuilder: (context, index) {
                      final item = _visibleItems[index];
                      final selected = _selectedIds.contains(item.id);

                      return _ExerciseGridCard(
                        item: item,
                        selected: selected,
                        onTap: () => _toggle(item.id),
                      );
                    },
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    itemCount: _visibleItems.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _visibleItems[index];
                      final selected = _selectedIds.contains(item.id);

                      return _ExerciseListRow(
                        item: item,
                        selected: selected,
                        onTap: () => _toggle(item.id),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 6, 10, safeBottom + 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withValues(alpha: 0.08),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.strengthCommonCancel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed:
                          _selectedIds.isEmpty ? null : _confirmSelection,
                          child: Text(
                            _selectedIds.isEmpty
                                ? l10n.strengthExercisePickerAdd
                                : l10n.strengthExercisePickerAddCount(
                              _selectedIds.length,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: l10n.strengthExercisePickerClearSelection,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 40,
                          height: 36,
                        ),
                        onPressed:
                        _selectedIds.isEmpty ? null : _clearSelection,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseGridCard extends StatelessWidget {
  const _ExerciseGridCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _PickerCatalogRecord item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? colorScheme.onSurface
                : colorScheme.outline.withValues(alpha: 0.18),
            width: selected ? 2.2 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.08)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ExerciseAssetImage(
                    exerciseId: item.id,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseListRow extends StatelessWidget {
  const _ExerciseListRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _PickerCatalogRecord item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? colorScheme.onSurface
                : colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: ExerciseAssetImage(
                exerciseId: item.id,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.allValue,
    required this.allLabel,
    required this.items,
    required this.onChanged,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final String allValue;
  final String allLabel;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final uniqueItems = items.toSet().toList();
    final colorScheme = Theme.of(context).colorScheme;

    const advancedRed = Color(0xFFFF5A5F);
    const advancedRedDark = Color(0xFF9E2F2F);
    const advancedRedFill = Color(0x22FF5A5F);

    final baseBorderColor = highlighted
        ? advancedRed
        : colorScheme.outline.withValues(alpha: 0.65);

    final focusedBorderColor = highlighted
        ? advancedRed
        : colorScheme.onSurface.withValues(alpha: 0.82);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(
        color: baseBorderColor,
        width: highlighted ? 1.2 : 1,
      ),
    );

    return DropdownButtonFormField<String>(
      value: uniqueItems.contains(value) ? value : uniqueItems.first,
      isDense: true,
      isExpanded: true,
      iconEnabledColor: highlighted ? advancedRed : null,
      dropdownColor: colorScheme.surface,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(10, 12, 8, 9),
        constraints: const BoxConstraints(
          minHeight: 45,
        ),
        filled: true,
        fillColor: highlighted ? advancedRedFill : Colors.transparent,
        labelStyle: TextStyle(
          color: highlighted ? advancedRed : null,
          fontWeight: highlighted ? FontWeight.w600 : null,
        ),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 1.2,
          ),
        ),
        border: border,
      ),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: highlighted ? Colors.white : null,
      ),
      selectedItemBuilder: (context) {
        return uniqueItems.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item == allValue ? allLabel : item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: highlighted ? Colors.white : null,
                fontWeight: highlighted ? FontWeight.w600 : null,
              ),
            ),
          );
        }).toList();
      },
      items: uniqueItems
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item == allValue ? allLabel : item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: highlighted ? Colors.white : null,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _PickerCatalogRecord {
  const _PickerCatalogRecord({
    required this.id,
    required this.muscleGroup,
    required this.baseExercise,
    required this.device,
    required this.variation,
    required this.isStatic,
    required this.primaryMuscles,
  });

  final String id;
  final String muscleGroup;
  final String baseExercise;
  final String device;
  final String variation;
  final bool isStatic;
  final List<String> primaryMuscles;

  String get label {
    final parts = <String>[
      baseExercise,
      device,
      variation,
    ].where((e) {
      final normalized = e.trim();
      return normalized.isNotEmpty && normalized != '-' && normalized != '–';
    }).toList();

    return parts.isEmpty ? id : parts.join(' – ');
  }
}

class _ExerciseCatalogLoader {
  _ExerciseCatalogLoader._();

  static List<_PickerCatalogRecord>? _cache;

  static Future<List<_PickerCatalogRecord>> load() async {
    if (_cache != null) {
      return _cache!;
    }

    final raw = await rootBundle.loadString('assets/data/exercises_master.csv');
    final rows = _readCsvRows(raw);
    final records = _parseRows(rows);
    _cache = records;
    return records;
  }

  static List<_PickerCatalogRecord> _parseRows(List<List<String>> rows) {
    if (rows.length < 3) {
      return const <_PickerCatalogRecord>[];
    }

    final header1 = rows[0].map((e) => e.trim()).toList(growable: false);
    final header2 = rows[1].map((e) => e.trim()).toList(growable: false);

    int idx(String name, {int start = 0, int? endExclusive}) {
      final end = endExclusive ?? header1.length;
      for (var i = start; i < end; i++) {
        if (header1[i].trim().toLowerCase() == name.trim().toLowerCase()) {
          return i;
        }
      }
      return -1;
    }

    final idxId = idx('ID') >= 0 ? idx('ID') : 3;
    final idxType = idx('Type');
    final idxMuscleGroup = idx('Muskelgruppe') >= 0 ? idx('Muskelgruppe') : 5;
    final idxExercise = idx('Übung') >= 0 ? idx('Übung') : 6;
    final idxDevice = idx('Gerät') >= 0 ? idx('Gerät') : 7;
    final idxVariation =
    idx('Variation', endExclusive: 9) >= 0 ? idx('Variation', endExclusive: 9) : 8;

    final muscleStartIndex = header1.indexWhere((e) => e == 'OA');
    final firstMuscleColumn = muscleStartIndex >= 0 ? muscleStartIndex : 20;

    final primaryMuscleNames = <int, String>{};
    for (var i = firstMuscleColumn; i < header1.length && i < header2.length; i++) {
      final groupCode = header1[i].trim();
      final muscleName = header2[i].trim();

      if (_looksLikeMuscleGroup(groupCode) && muscleName.isNotEmpty) {
        primaryMuscleNames[i] = muscleName;
      }
    }

    final result = <_PickerCatalogRecord>[];

    for (var rowIndex = 2; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      if (row.length <= idxId) {
        continue;
      }

      final id = _cell(row, idxId);
      if (id.isEmpty) {
        continue;
      }

      final typeValue = idxType >= 0 ? _cell(row, idxType).toLowerCase() : '';
      final primaryMuscles = <String>[];

      for (final entry in primaryMuscleNames.entries) {
        final value = _cell(row, entry.key);
        if (value == '2') {
          primaryMuscles.add(entry.value);
        }
      }

      result.add(
        _PickerCatalogRecord(
          id: id,
          muscleGroup: _cell(row, idxMuscleGroup),
          baseExercise: _cell(row, idxExercise),
          device: _cell(row, idxDevice),
          variation: _cell(row, idxVariation),
          isStatic: typeValue == 's',
          primaryMuscles: primaryMuscles.toSet().toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
        ),
      );
    }

    return result;
  }

  static bool _looksLikeMuscleGroup(String value) {
    final v = value.trim().toUpperCase();
    return const <String>{
      'OA',
      'UA',
      'SC',
      'BR',
      'BA',
      'RU',
      'GE',
      'OS',
      'US',
    }.contains(v);
  }

  static String _cell(List<String> row, int index) {
    if (index < 0 || index >= row.length) {
      return '';
    }
    return row[index].trim();
  }

  static List<List<String>> _readCsvRows(String raw) {
    final input = raw.startsWith('\uFEFF') ? raw.substring(1) : raw;

    final rows = <List<String>>[];
    final currentRow = <String>[];
    final currentCell = StringBuffer();

    var inQuotes = false;
    var i = 0;

    while (i < input.length) {
      final char = input[i];

      if (char == '"') {
        final nextIsQuote = i + 1 < input.length && input[i + 1] == '"';
        if (nextIsQuote) {
          currentCell.write('"');
          i += 2;
          continue;
        }
        inQuotes = !inQuotes;
        i++;
        continue;
      }

      if (char == ';' && !inQuotes) {
        currentRow.add(currentCell.toString());
        currentCell.clear();
        i++;
        continue;
      }

      if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i + 1 < input.length && input[i + 1] == '\n') {
          i++;
        }

        currentRow.add(currentCell.toString());
        currentCell.clear();

        final rowHasContent = currentRow.any((e) => e.isNotEmpty);
        if (rowHasContent) {
          rows.add(List<String>.from(currentRow));
        }
        currentRow.clear();
        i++;
        continue;
      }

      currentCell.write(char);
      i++;
    }

    currentRow.add(currentCell.toString());
    final rowHasContent = currentRow.any((e) => e.isNotEmpty);
    if (rowHasContent) {
      rows.add(List<String>.from(currentRow));
    }

    return rows;
  }
}

extension on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}