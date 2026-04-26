class StrengthPlanEditorResult {
  const StrengthPlanEditorResult({
    required this.exerciseOrder,
    required this.supersetGroupByExercise,
  });

  final List<String> exerciseOrder;
  final Map<String, String> supersetGroupByExercise;
}

class StrengthPlanEditorSelectionState {
  const StrengthPlanEditorSelectionState({
    required this.canCreateSuperset,
    required this.canDissolveSuperset,
    required this.replacesExistingSuperset,
    this.dissolveGroupId,
  });

  final bool canCreateSuperset;
  final bool canDissolveSuperset;
  final bool replacesExistingSuperset;
  final String? dissolveGroupId;
}

class StrengthPlanEditorService {
  const StrengthPlanEditorService();

  StrengthPlanEditorSelectionState evaluateSelection({
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
    required Set<String> selectedExerciseIds,
  }) {
    final selected = selectedExerciseIds
        .where(exerciseOrder.contains)
        .toSet();

    final canCreate = selected.length >= 2;
    final selectedGroups = <String>{};
    var replacesExisting = false;

    for (final exerciseId in selected) {
      final groupId = supersetGroupByExercise[exerciseId];
      if (groupId == null || groupId.trim().isEmpty) continue;
      selectedGroups.add(groupId);
      replacesExisting = true;
    }

    String? dissolveGroupId;
    var canDissolve = false;

    if (selected.isNotEmpty && selectedGroups.length == 1) {
      final groupId = selectedGroups.single;
      final fullGroup = exerciseOrder
          .where((exerciseId) => supersetGroupByExercise[exerciseId] == groupId)
          .toSet();

      if (fullGroup.isNotEmpty &&
          fullGroup.length == selected.length &&
          fullGroup.containsAll(selected)) {
        dissolveGroupId = groupId;
        canDissolve = true;
      }
    }

    return StrengthPlanEditorSelectionState(
      canCreateSuperset: canCreate,
      canDissolveSuperset: canDissolve,
      replacesExistingSuperset: replacesExisting,
      dissolveGroupId: dissolveGroupId,
    );
  }

  List<String> reorderExercise({
    required List<String> exerciseOrder,
    required int oldIndex,
    required int newIndex,
  }) {
    final next = List<String>.from(exerciseOrder);

    if (oldIndex < 0 || oldIndex >= next.length) {
      return next;
    }

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }

    targetIndex = targetIndex.clamp(0, next.length - 1);

    final moved = next.removeAt(oldIndex);
    next.insert(targetIndex, moved);

    return next;
  }

  Map<String, String> createSuperset({
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
    required Set<String> selectedExerciseIds,
    required String groupId,
  }) {
    final selected = selectedExerciseIds
        .where(exerciseOrder.contains)
        .toSet();

    if (selected.length < 2 || groupId.trim().isEmpty) {
      return normalizeSupersets(
        exerciseOrder: exerciseOrder,
        supersetGroupByExercise: supersetGroupByExercise,
      );
    }

    final next = Map<String, String>.from(supersetGroupByExercise);

    for (final exerciseId in selected) {
      next[exerciseId] = groupId.trim();
    }

    return normalizeSupersets(
      exerciseOrder: exerciseOrder,
      supersetGroupByExercise: next,
    );
  }

  Map<String, String> dissolveSuperset({
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
    required Set<String> selectedExerciseIds,
  }) {
    final state = evaluateSelection(
      exerciseOrder: exerciseOrder,
      supersetGroupByExercise: supersetGroupByExercise,
      selectedExerciseIds: selectedExerciseIds,
    );

    if (!state.canDissolveSuperset || state.dissolveGroupId == null) {
      return normalizeSupersets(
        exerciseOrder: exerciseOrder,
        supersetGroupByExercise: supersetGroupByExercise,
      );
    }

    final next = Map<String, String>.from(supersetGroupByExercise)
      ..removeWhere((_, groupId) => groupId == state.dissolveGroupId);

    return normalizeSupersets(
      exerciseOrder: exerciseOrder,
      supersetGroupByExercise: next,
    );
  }

  Map<String, String> normalizeSupersets({
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
  }) {
    final orderSet = exerciseOrder.toSet();

    final cleaned = <String, String>{};
    supersetGroupByExercise.forEach((exerciseId, groupId) {
      final normalizedGroupId = groupId.trim();
      if (!orderSet.contains(exerciseId)) return;
      if (normalizedGroupId.isEmpty) return;
      cleaned[exerciseId] = normalizedGroupId;
    });

    final countByGroup = <String, int>{};
    for (final groupId in cleaned.values) {
      countByGroup[groupId] = (countByGroup[groupId] ?? 0) + 1;
    }

    cleaned.removeWhere((_, groupId) => (countByGroup[groupId] ?? 0) < 2);

    return cleaned;
  }

  String createGroupId() {
    return 'g-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? supersetLabelForExercise({
    required String exerciseId,
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
  }) {
    final groupId = supersetGroupByExercise[exerciseId];
    if (groupId == null || groupId.trim().isEmpty) return null;

    return supersetLabelForGroup(
      groupId: groupId,
      exerciseOrder: exerciseOrder,
      supersetGroupByExercise: supersetGroupByExercise,
    );
  }

  String supersetLabelForGroup({
    required String groupId,
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
  }) {
    final firstPositionByGroup = <String, int>{};

    for (var index = 0; index < exerciseOrder.length; index++) {
      final exerciseId = exerciseOrder[index];
      final currentGroupId = supersetGroupByExercise[exerciseId];

      if (currentGroupId == null || currentGroupId.trim().isEmpty) continue;
      firstPositionByGroup.putIfAbsent(currentGroupId, () => index);
    }

    final sortedGroups = firstPositionByGroup.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final groupIndex = sortedGroups.indexWhere((entry) => entry.key == groupId);
    if (groupIndex < 0) return '?';

    final code = 'A'.codeUnitAt(0) + groupIndex;
    if (code > 'Z'.codeUnitAt(0)) {
      return 'Z';
    }

    return String.fromCharCode(code);
  }
}