import 'package:flutter/foundation.dart';

@immutable
class SetEntry {
  final double? reps;
  final int? durationSec;
  final double? load;
  final String? note;
  final double? rpe;
  final bool allOut;
  final int mods;

  /// Zusätzliche Marker-Felder, die bereits vom StrengthSessionService erwartet werden.
  final int? bfrPercent;
  final double? chainsKg;
  final double? bandsKg;
  final bool superSlowEnabled;
  final String? superSlowNote;

  const SetEntry({
    this.reps,
    this.durationSec,
    this.load,
    this.note,
    this.rpe,
    this.allOut = false,
    this.mods = 0,
    this.bfrPercent,
    this.chainsKg,
    this.bandsKg,
    this.superSlowEnabled = false,
    this.superSlowNote,
  });

  bool get isEmpty =>
      reps == null &&
          durationSec == null &&
          load == null &&
          (note == null || note!.trim().isEmpty) &&
          rpe == null &&
          !allOut &&
          mods == 0 &&
          bfrPercent == null &&
          chainsKg == null &&
          bandsKg == null &&
          !superSlowEnabled &&
          (superSlowNote == null || superSlowNote!.trim().isEmpty);

  double? get loadKg => load;

  bool isComplete({
    required bool isStaticExercise,
  }) {
    return load != null &&
        (isStaticExercise ? durationSec != null : reps != null);
  }

  bool get isCompleteDynamic => load != null && reps != null;

  bool get isCompleteStatic => load != null && durationSec != null;

  SetEntry copyWith({
    Object? reps = _sentinel,
    Object? durationSec = _sentinel,
    Object? load = _sentinel,
    Object? note = _sentinel,
    Object? rpe = _sentinel,
    Object? allOut = _sentinel,
    Object? mods = _sentinel,
    Object? bfrPercent = _sentinel,
    Object? chainsKg = _sentinel,
    Object? bandsKg = _sentinel,
    Object? superSlowEnabled = _sentinel,
    Object? superSlowNote = _sentinel,
  }) {
    return SetEntry(
      reps: identical(reps, _sentinel) ? this.reps : reps as double?,
      durationSec: identical(durationSec, _sentinel)
          ? this.durationSec
          : durationSec as int?,
      load: identical(load, _sentinel) ? this.load : load as double?,
      note: identical(note, _sentinel) ? this.note : note as String?,
      rpe: identical(rpe, _sentinel) ? this.rpe : rpe as double?,
      allOut: identical(allOut, _sentinel) ? this.allOut : allOut as bool,
      mods: identical(mods, _sentinel) ? this.mods : mods as int,
      bfrPercent: identical(bfrPercent, _sentinel)
          ? this.bfrPercent
          : bfrPercent as int?,
      chainsKg: identical(chainsKg, _sentinel)
          ? this.chainsKg
          : chainsKg as double?,
      bandsKg: identical(bandsKg, _sentinel)
          ? this.bandsKg
          : bandsKg as double?,
      superSlowEnabled: identical(superSlowEnabled, _sentinel)
          ? this.superSlowEnabled
          : superSlowEnabled as bool,
      superSlowNote: identical(superSlowNote, _sentinel)
          ? this.superSlowNote
          : superSlowNote as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'durationSec': durationSec,
      if (load != null) 'load': load,
      if (note != null) 'note': note,
      if (rpe != null) 'rpe': rpe,
      'allOut': allOut,
      'mods': mods,
      if (bfrPercent != null) 'bfrPercent': bfrPercent,
      if (chainsKg != null) 'chainsKg': chainsKg,
      if (bandsKg != null) 'bandsKg': bandsKg,
      'superSlowEnabled': superSlowEnabled,
      if (superSlowNote != null) 'superSlowNote': superSlowNote,
    };
  }

  factory SetEntry.fromJson(Map<String, dynamic> json) {
    return SetEntry(
      reps: (json['reps'] as num?)?.toDouble(),
      durationSec: (json['durationSec'] as num?)?.toInt(),
      load: (json['load'] as num?)?.toDouble(),
      note: json['note'] as String?,
      rpe: (json['rpe'] as num?)?.toDouble(),
      allOut: json['allOut'] == true,
      mods: (json['mods'] as num?)?.toInt() ?? 0,
      bfrPercent: (json['bfrPercent'] as num?)?.toInt(),
      chainsKg: (json['chainsKg'] as num?)?.toDouble(),
      bandsKg: (json['bandsKg'] as num?)?.toDouble(),
      superSlowEnabled: json['superSlowEnabled'] == true,
      superSlowNote: json['superSlowNote'] as String?,
    );
  }

  static const _sentinel = Object();
}

@immutable
class StrengthDraftSession {
  final int dateEpochDay;
  final List<String> exerciseOrder;
  final Map<String, List<SetEntry>> setsByExercise;
  final Map<String, String> supersetGroupByExercise;

  const StrengthDraftSession({
    required this.dateEpochDay,
    required this.exerciseOrder,
    required this.setsByExercise,
    required this.supersetGroupByExercise,
  });

  factory StrengthDraftSession.empty({
    required int dateEpochDay,
  }) {
    return StrengthDraftSession(
      dateEpochDay: dateEpochDay,
      exerciseOrder: const [],
      setsByExercise: const {},
      supersetGroupByExercise: const {},
    );
  }

  bool get hasExercises => exerciseOrder.isNotEmpty;

  bool get hasEntries {
    for (final sets in setsByExercise.values) {
      for (final entry in sets) {
        if (!entry.isEmpty) return true;
      }
    }
    return false;
  }

  StrengthDraftSession copyWith({
    int? dateEpochDay,
    List<String>? exerciseOrder,
    Map<String, List<SetEntry>>? setsByExercise,
    Map<String, String>? supersetGroupByExercise,
  }) {
    return StrengthDraftSession(
      dateEpochDay: dateEpochDay ?? this.dateEpochDay,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      setsByExercise: setsByExercise ?? this.setsByExercise,
      supersetGroupByExercise:
      supersetGroupByExercise ?? this.supersetGroupByExercise,
    );
  }

  Map<String, dynamic> toJson() {
    final setsJson = <String, dynamic>{};
    setsByExercise.forEach((key, value) {
      setsJson[key] = value.map((e) => e.toJson()).toList();
    });

    return <String, dynamic>{
      'dateEpochDay': dateEpochDay,
      'exerciseOrder': exerciseOrder,
      'setsByExercise': setsJson,
      'supersetGroupByExercise': supersetGroupByExercise,
    };
  }

  factory StrengthDraftSession.fromJson(Map<String, dynamic> json) {
    final rawSets = (json['setsByExercise'] as Map?) ?? const {};
    final mappedSets = <String, List<SetEntry>>{};
    rawSets.forEach((key, value) {
      mappedSets[key.toString()] = (value as List? ?? const [])
          .map((e) => SetEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    });

    final rawSupersets =
        (json['supersetGroupByExercise'] as Map?) ?? const {};
    final supersets = <String, String>{};
    rawSupersets.forEach((key, value) {
      final text = value.toString().trim();
      if (text.isNotEmpty) {
        supersets[key.toString()] = text;
      }
    });

    return StrengthDraftSession(
      dateEpochDay: (json['dateEpochDay'] as num?)?.toInt() ?? 0,
      exerciseOrder: ((json['exerciseOrder'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      setsByExercise: mappedSets,
      supersetGroupByExercise: supersets,
    );
  }
}

@immutable
class StrengthPlanSummary {
  final String name;

  const StrengthPlanSummary({
    required this.name,
  });
}

@immutable
class StrengthExerciseSummary {
  final String id;
  final String label;
  final bool isStatic;

  const StrengthExerciseSummary({
    required this.id,
    required this.label,
    required this.isStatic,
  });
}