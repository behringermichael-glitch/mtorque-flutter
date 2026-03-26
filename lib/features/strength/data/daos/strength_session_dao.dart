import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/strength_sessions_table.dart';
import '../tables/strength_sets_table.dart';

part 'strength_session_dao.g.dart';

class StrengthSessionWithSets {
  const StrengthSessionWithSets({
    required this.session,
    required this.sets,
  });

  final StrengthSession session;
  final List<StrengthSet> sets;
}

class StrengthDayCount {
  const StrengthDayCount({
    required this.day,
    required this.count,
  });

  final String day;
  final int count;
}

@DriftAccessor(tables: [StrengthSessions, StrengthSets])
class StrengthSessionDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthSessionDaoMixin {
  StrengthSessionDao(super.db);

  Future<int> sessionExists(int id) async {
    final row = await (selectOnly(strengthSessions)
          ..addColumns([strengthSessions.id.count()])
          ..where(strengthSessions.id.equals(id)))
        .getSingle();

    return row.read(strengthSessions.id.count()) ?? 0;
  }

  Future<int?> getSessionStartMs(int id) {
    return (select(strengthSessions)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .map((row) => row.startEpochMs)
        .getSingleOrNull();
  }

  Future<int> createSession({
    required int startEpochMs,
    String? notes,
  }) {
    return into(strengthSessions).insert(
      StrengthSessionsCompanion.insert(
        startEpochMs: startEpochMs,
        notes: Value(notes),
      ),
    );
  }

  Future<void> finalizeSession({
    required int id,
    required int endEpochMs,
    String? notes,
  }) {
    return (update(strengthSessions)..where((t) => t.id.equals(id))).write(
      StrengthSessionsCompanion(
        endEpochMs: Value(endEpochMs),
        notes: Value(notes),
      ),
    );
  }

  Future<void> updateSessionStartMs({
    required int id,
    required int startEpochMs,
  }) {
    return (update(strengthSessions)..where((t) => t.id.equals(id))).write(
      StrengthSessionsCompanion(
        startEpochMs: Value(startEpochMs),
      ),
    );
  }

  Future<void> deleteSession(int id) {
    return (delete(strengthSessions)..where((t) => t.id.equals(id))).go();
  }

  Future<List<StrengthSession>> finishedSessions() {
    return (select(strengthSessions)
          ..where((t) => t.endEpochMs.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.startEpochMs)]))
        .get();
  }

  Future<List<StrengthSession>> recentFinishedSessions({int limit = 120}) {
    return (select(strengthSessions)
          ..where((t) => t.endEpochMs.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.endEpochMs)])
          ..limit(limit))
        .get();
  }

  Future<List<StrengthSessionWithSets>> recentFinishedSessionsWithSets({
    int limit = 120,
  }) async {
    final sessions = await recentFinishedSessions(limit: limit);
    if (sessions.isEmpty) return const [];

    final ids = sessions.map((e) => e.id).toList();
    final allSets = await (select(strengthSets)
          ..where((t) => t.sessionId.isIn(ids))
          ..orderBy([
            (t) => OrderingTerm.asc(t.sessionId),
            (t) => OrderingTerm.asc(t.exerciseId),
            (t) => OrderingTerm.asc(t.setNumber),
          ]))
        .get();

    final bySession = <int, List<StrengthSet>>{};
    for (final set in allSets) {
      bySession.putIfAbsent(set.sessionId, () => <StrengthSet>[]).add(set);
    }

    return sessions
        .map(
          (session) => StrengthSessionWithSets(
            session: session,
            sets: bySession[session.id] ?? const [],
          ),
        )
        .toList(growable: false);
  }
}
