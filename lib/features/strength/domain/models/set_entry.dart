/// Flutter-side editable set row.
///
/// This mirrors the editable UI state from the Android strength flow,
/// before values are converted into persisted DB rows.
class SetEntry {
  const SetEntry({
    this.reps,
    this.durationSec,
    this.loadKg,
    this.allOut = false,
    this.bfrPercent,
    this.chainsKg,
    this.bandsKg,
    this.superSlowEnabled = false,
    this.superSlowNote,
  });

  final double? reps;
  final int? durationSec;
  final double? loadKg;
  final bool allOut;
  final int? bfrPercent;
  final double? chainsKg;
  final double? bandsKg;
  final bool superSlowEnabled;
  final String? superSlowNote;

  bool get hasAnyUserInput =>
      reps != null || durationSec != null || loadKg != null || allOut ||
      bfrPercent != null || chainsKg != null || bandsKg != null ||
      superSlowEnabled || (superSlowNote?.trim().isNotEmpty ?? false);

  bool isComplete({required bool isStaticExercise}) {
    if (loadKg == null) return false;

    if (isStaticExercise) {
      return durationSec != null && durationSec! > 0;
    }

    return reps != null && reps! > 0;
  }
}
