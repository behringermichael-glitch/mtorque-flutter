import 'dart:convert';
import 'dart:ui' as ui;

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/models/set_entry.dart';
import '../../domain/repositories/strength_repository.dart';

class StrengthRepositoryImpl implements StrengthRepository {
  StrengthRepositoryImpl({
    required AppDatabase database,
  }) : _db = database;

  final AppDatabase _db;

  static const _draftPrefs = 'mTORQUE_strength';
  static const _draftKey = 'flutter_active_draft_session';
  static const _activeSessionKey = 'active_session_id';

  static const _plansPrefs = 'mTORQUE_prefs';
  static const _plansKey = 'plans_json';

  static const _catalogAssetPath = 'assets/data/exercises_master.csv';

  List<_ExerciseCatalogRecord>? _catalogCache;
  Map<String, _ExerciseCatalogRecord>? _catalogByIdCache;

  @override
  Future<StrengthDraftSession?> loadDraftSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_draftPrefs::$_draftKey');
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      return StrengthDraftSession.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveDraftSession(StrengthDraftSession? session) async {
    final prefs = await SharedPreferences.getInstance();
    if (session == null) {
      await prefs.remove('$_draftPrefs::$_draftKey');
      return;
    }
    await prefs.setString(
      '$_draftPrefs::$_draftKey',
      jsonEncode(session.toJson()),
    );
  }

  @override
  Future<int?> getStoredActiveDbSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('$_draftPrefs::$_activeSessionKey');
    if (value == null || value <= 0) return null;
    return value;
  }

  @override
  Future<void> setStoredActiveDbSessionId(int? sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    if (sessionId == null || sessionId <= 0) {
      await prefs.remove('$_draftPrefs::$_activeSessionKey');
      return;
    }
    await prefs.setInt('$_draftPrefs::$_activeSessionKey', sessionId);
  }

  @override
  Future<List<StrengthPlanSummary>> listPlanSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plansKey) ??
        prefs.getString('$_plansPrefs::$_plansKey') ??
        '{}';

    try {
      final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final keys = json.keys.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return keys.map((e) => StrengthPlanSummary(name: e)).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<String>?> loadPlanExerciseIds(String planName) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plansKey) ??
        prefs.getString('$_plansPrefs::$_plansKey') ??
        '{}';

    try {
      final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final value = json[planName];
      if (value is! List) return null;
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> savePlan({
    required String name,
    required List<String> exerciseIds,
    required bool overwrite,
  }) async {
    final cleanName = name.trim();
    final cleanIds =
    exerciseIds.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (cleanName.isEmpty || cleanIds.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plansKey) ??
        prefs.getString('$_plansPrefs::$_plansKey') ??
        '{}';

    final json = raw.trim().isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map);

    if (!overwrite && json.containsKey(cleanName)) return false;

    json[cleanName] = cleanIds;
    return prefs.setString(_plansKey, jsonEncode(json));
  }

  @override
  Future<bool> renamePlan({
    required String oldName,
    required String newName,
    required bool overwrite,
  }) async {
    final oldN = oldName.trim();
    final newN = newName.trim();

    if (oldN.isEmpty || newN.isEmpty) return false;
    if (oldN == newN) return true;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plansKey) ??
        prefs.getString('$_plansPrefs::$_plansKey') ??
        '{}';

    final json = raw.trim().isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map);

    if (!json.containsKey(oldN)) return false;
    if (!overwrite && json.containsKey(newN)) return false;

    json[newN] = json[oldN];
    json.remove(oldN);

    return prefs.setString(_plansKey, jsonEncode(json));
  }

  @override
  Future<bool> deletePlan(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plansKey) ??
        prefs.getString('$_plansPrefs::$_plansKey') ??
        '{}';

    final json = raw.trim().isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map);

    if (!json.containsKey(clean)) return false;
    json.remove(clean);
    return prefs.setString(_plansKey, jsonEncode(json));
  }

  @override
  Future<List<StrengthExerciseSummary>> searchExercises({
    String query = '',
  }) async {
    final all = await _loadExerciseCatalog();
    final q = query.trim().toLowerCase();

    final result = q.isEmpty
        ? all
        : all.where((e) {
      return e.id.toLowerCase().contains(q) ||
          e.label.toLowerCase().contains(q) ||
          e.muscleGroup.toLowerCase().contains(q) ||
          e.name.toLowerCase().contains(q) ||
          e.device.toLowerCase().contains(q) ||
          e.variation.toLowerCase().contains(q);
    }).toList();

    result.sort(
          (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
    );

    return result
        .map(
          (e) => StrengthExerciseSummary(
        id: e.id,
        label: e.label,
        isStatic: e.isStatic,
      ),
    )
        .toList();
  }

  @override
  Future<StrengthExerciseSummary?> getExerciseById(String exerciseId) async {
    await _ensureCatalogLoaded();
    final record = _catalogByIdCache?[exerciseId];
    if (record == null) return null;

    return StrengthExerciseSummary(
      id: record.id,
      label: record.label,
      isStatic: record.isStatic,
    );
  }

  Future<List<_ExerciseCatalogRecord>> _loadExerciseCatalog() async {
    await _ensureCatalogLoaded();
    return _catalogCache ?? const [];
  }

  Future<void> _ensureCatalogLoaded() async {
    if (_catalogCache != null && _catalogByIdCache != null) {
      return;
    }

    try {
      final raw = await rootBundle.loadString(_catalogAssetPath);
      final parsed = _parseMasterCsv(raw);

      _catalogCache = parsed;
      _catalogByIdCache = {
        for (final item in parsed) item.id: item,
      };
    } catch (_) {
      _catalogCache = const [];
      _catalogByIdCache = const {};
    }
  }

  List<_ExerciseCatalogRecord> _parseMasterCsv(String text) {
    final lines = _readCsvLinesWithMultiline(text);
    if (lines.length < 3) return const [];

    final delim = _detectDelimiter(lines.first);

    final header1 = _splitCsvLine(lines[0], delim).map((e) => e.trim()).toList();
    _splitCsvLine(lines[1], delim);

    int idx(String name, {int start = 0, int? endExclusive}) {
      final end = endExclusive == null
          ? header1.length
          : endExclusive.clamp(0, header1.length);
      for (var i = start; i < end; i++) {
        if (header1[i].trim().toLowerCase() == name.toLowerCase()) {
          return i;
        }
      }
      return -1;
    }

    final idxId = idx('ID') >= 0 ? idx('ID') : 3;
    final idxMuscleEn = idx('Muscle') >= 0 ? idx('Muscle') : 8;

    final idxType = () {
      final de = idx('Typ');
      if (de >= 0) return de;
      return idx('Type');
    }();

    final idxMgDe = idx('Muskelgruppe') >= 0 ? idx('Muskelgruppe') : 4;
    final idxNameDe = idx('Übung') >= 0 ? idx('Übung') : 5;
    final idxDevDe = idx('Gerät') >= 0 ? idx('Gerät') : 6;
    final idxVarDe = () {
      final found = idx('Variation', start: 0, endExclusive: idxMuscleEn);
      return found >= 0 ? found : 7;
    }();

    final idxMgEn = idxMuscleEn;
    final idxNameEn = () {
      final found = idx('Exercise', start: idxMuscleEn);
      return found >= 0 ? found : 9;
    }();
    final idxDevEn = () {
      final found = idx('Device', start: idxMuscleEn);
      return found >= 0 ? found : 10;
    }();
    final idxVarEn = () {
      final found = idx('Variation', start: idxMuscleEn);
      return found >= 0 ? found : 11;
    }();

    final isDe =
        ui.PlatformDispatcher.instance.locale.languageCode.toLowerCase() == 'de';

    final out = <_ExerciseCatalogRecord>[];

    for (var i = 2; i < lines.length; i++) {
      final row = _splitCsvLine(lines[i], delim);
      if (row.length <= idxId) continue;

      final id = _cell(row, idxId);
      if (id.isEmpty) continue;

      final typeValue = idxType >= 0 ? _cell(row, idxType).toLowerCase() : '';
      final setType = typeValue.startsWith('s') ? 's' : 'd';

      final muscleGroup = isDe ? _cell(row, idxMgDe) : _cell(row, idxMgEn);
      final name = isDe ? _cell(row, idxNameDe) : _cell(row, idxNameEn);
      final device = isDe ? _cell(row, idxDevDe) : _cell(row, idxDevEn);
      final variation = isDe ? _cell(row, idxVarDe) : _cell(row, idxVarEn);

      out.add(
        _ExerciseCatalogRecord(
          id: id,
          muscleGroup: muscleGroup,
          name: name,
          device: device,
          variation: variation,
          label: _composeLabel(
            name: name,
            device: device,
            variation: variation,
          ),
          isStatic: setType == 's',
        ),
      );
    }

    return out;
  }

  String _composeLabel({
    required String name,
    required String device,
    required String variation,
  }) {
    final parts = [name, device, variation]
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != '-' && e != '–')
        .toList();
    return parts.join(' – ');
  }

  String _cell(List<String> row, int index) {
    if (index < 0 || index >= row.length) return '';
    return row[index].trim();
  }

  String _detectDelimiter(String header) {
    if (header.contains(';')) return ';';
    if (header.contains('\t')) return '\t';
    return ',';
  }

  List<String> _splitCsvLine(String line, String delim) {
    final out = <String>[];
    final sb = StringBuffer();
    var inQuotes = false;
    var i = 0;

    while (i < line.length) {
      final c = line[i];

      if (c == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          sb.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (c == delim && !inQuotes) {
        out.add(sb.toString());
        sb.clear();
      } else {
        sb.write(c);
      }

      i++;
    }

    out.add(sb.toString());
    return out;
  }

  List<String> _readCsvLinesWithMultiline(String text) {
    final result = <String>[];
    final rawLines = text.split('\n');

    final current = StringBuffer();
    var insideQuotes = false;

    for (final raw in rawLines) {
      final line = raw.replaceAll('\r', '');
      final quoteCount = '"'.allMatches(line).length;

      if (!insideQuotes) {
        current.clear();
        current.write(line);
      } else {
        current.write('\n');
        current.write(line);
      }

      if (quoteCount.isOdd) {
        insideQuotes = !insideQuotes;
      }

      if (!insideQuotes) {
        result.add(current.toString());
      }
    }

    return result;
  }

  @override
  Future<int> createStrengthSessionIfMissing() async {
    final stored = await getStoredActiveDbSessionId();
    if (stored != null) {
      final exists = await _db.strengthSessionDao.sessionExists(stored);
      if (exists > 0) return stored;
      await setStoredActiveDbSessionId(null);
    }

    final id = await _db.strengthSessionDao.createSession(
      startEpochMs: DateTime.now().millisecondsSinceEpoch,
    );
    await setStoredActiveDbSessionId(id);
    return id;
  }

  @override
  Future<void> deleteStrengthSessionCompletely(int sessionId) async {
    await _db.transaction(() async {
      await _db.strengthSetDao.deleteSetsForSession(sessionId);
      await _db.strengthSessionDao.deleteSession(sessionId);
      await _db.strengthSetDao.deleteOrphanStrengthSets();
    });
    await setStoredActiveDbSessionId(null);
  }

  @override
  Future<void> finalizeStrengthSession({
    required int sessionId,
    required String? notes,
  }) async {
    await _db.strengthSessionDao.finalizeSession(
      id: sessionId,
      endEpochMs: DateTime.now().millisecondsSinceEpoch,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
    );
    await setStoredActiveDbSessionId(null);
  }

  @override
  Future<DateTime?> getStrengthSessionStart(int sessionId) async {
    final startMs = await _db.strengthSessionDao.getSessionStartMs(sessionId);
    if (startMs == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(startMs);
  }

  @override
  Future<void> replaceExerciseSetsForSession({
    required int sessionId,
    required String exerciseId,
    required String exerciseName,
    required bool isStaticExercise,
    required String? supersetGroupId,
    required List<SetEntry> draftSets,
  }) async {
    final mapped = <StrengthSetsCompanion>[];

    for (var i = 0; i < draftSets.length; i++) {
      final entry = draftSets[i];
      if (!entry.isComplete(isStaticExercise: isStaticExercise)) {
        continue;
      }

      final reps = isStaticExercise ? 1.0 : entry.reps!;
      final durationSec = isStaticExercise ? entry.durationSec : null;
      final loadKg = entry.loadKg!;
      final isBfr = entry.bfrPercent != null;

      mapped.add(
        StrengthSetsCompanion.insert(
          sessionId: sessionId,
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          setNumber: i + 1,
          reps: reps,
          durationSec: Value(durationSec),
          weightKg: loadKg,
          isAllOut: Value(entry.allOut),
          isBfr: Value(isBfr),
          bfrPercent: Value(entry.bfrPercent),
          chainsKg: Value(entry.chainsKg),
          bandsKg: Value(entry.bandsKg),
          isSuperSlow: Value(entry.superSlowEnabled),
          superSlowNote: Value(entry.superSlowNote),
          supersetGroupId: Value(
            supersetGroupId == null || supersetGroupId.trim().isEmpty
                ? null
                : supersetGroupId.trim(),
          ),
        ),
      );
    }

    if (mapped.isEmpty) return;

    await _db.transaction(() async {
      await _db.strengthSetDao.deleteSetsForSessionExercise(
        sessionId: sessionId,
        exerciseId: exerciseId,
      );
      await _db.strengthSetDao.insertSets(mapped);
    });
  }

  @override
  Future<Map<int, ({double load, double secondValue})>> loadLastSuggestions({
    required String exerciseId,
    required bool isStaticExercise,
    required int minCount,
  }) async {
    final sessions = await _db.strengthSessionDao.recentFinishedSessionsWithSets(
      limit: 120,
    );

    final neededCount = minCount < 10 ? 10 : minCount;
    final suggestions = <int, ({double load, double secondValue})>{};

    for (final session in sessions) {
      final matching = session.sets
          .where(
            (set) =>
        set.exerciseId == exerciseId &&
            set.setNumber >= 1 &&
            set.setNumber <= neededCount &&
            set.weightKg > 0 &&
            (isStaticExercise
                ? ((set.durationSec ?? 0) > 0)
                : set.reps > 0),
      )
          .toList()
        ..sort((a, b) => a.setNumber.compareTo(b.setNumber));

      for (final set in matching) {
        if (!suggestions.containsKey(set.setNumber)) {
          suggestions[set.setNumber] = (
          load: set.weightKg,
          secondValue:
          isStaticExercise ? (set.durationSec ?? 0).toDouble() : set.reps,
          );
        }
      }

      if (suggestions.length >= neededCount) break;
    }

    return suggestions;
  }
}

class _ExerciseCatalogRecord {
  final String id;
  final String muscleGroup;
  final String name;
  final String device;
  final String variation;
  final String label;
  final bool isStatic;

  const _ExerciseCatalogRecord({
    required this.id,
    required this.muscleGroup,
    required this.name,
    required this.device,
    required this.variation,
    required this.label,
    required this.isStatic,
  });
}