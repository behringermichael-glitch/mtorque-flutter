import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'anatomy_models.dart';

class MuscleInfoRepository {
  MuscleInfoRepository._();

  static final Map<String, MuscleInfoEntry> _cache =
  <String, MuscleInfoEntry>{};
  static bool _loaded = false;

  static Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }

    final raw = await rootBundle.loadString('assets/data/muscle_info.csv');
    final rows = _parseSemicolonCsv(raw);

    for (final row in rows.skip(1)) {
      if (row.length < 9) {
        continue;
      }

      final muscleName = row[1].trim();
      if (muscleName.isEmpty) {
        continue;
      }

      _cache[_normalizeLookupKey(muscleName)] = MuscleInfoEntry(
        muscleName: muscleName,
        functionDe: row[2].trim(),
        functionEn: row[3].trim(),
        originDe: row[4].trim(),
        originEn: row[5].trim(),
        insertionDe: row[6].trim(),
        insertionEn: row[7].trim(),
        innervation: row[8].trim(),
      );
    }

    _loaded = true;
  }

  static MuscleInfoEntry? findByMuscleName(String muscleName) {
    return _cache[_normalizeLookupKey(muscleName)];
  }

  static String _normalizeLookupKey(String input) {
    return input.trim().toLowerCase();
  }

  static List<List<String>> _parseSemicolonCsv(String input) {
    final List<List<String>> rows = <List<String>>[];
    final List<String> currentRow = <String>[];
    final StringBuffer currentField = StringBuffer();

    var inQuotes = false;
    var i = 0;

    while (i < input.length) {
      final char = input[i];

      if (char == '"') {
        if (inQuotes && i + 1 < input.length && input[i + 1] == '"') {
          currentField.write('"');
          i += 2;
          continue;
        }
        inQuotes = !inQuotes;
        i++;
        continue;
      }

      if (char == ';' && !inQuotes) {
        currentRow.add(currentField.toString());
        currentField.clear();
        i++;
        continue;
      }

      if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i + 1 < input.length && input[i + 1] == '\n') {
          i++;
        }

        currentRow.add(currentField.toString());
        currentField.clear();

        final trimmedRow = List<String>.from(currentRow);
        while (trimmedRow.isNotEmpty && trimmedRow.last.isEmpty) {
          trimmedRow.removeLast();
        }
        if (trimmedRow.isNotEmpty) {
          rows.add(trimmedRow);
        }

        currentRow.clear();
        i++;
        continue;
      }

      currentField.write(char);
      i++;
    }

    currentRow.add(currentField.toString());
    final trimmedRow = List<String>.from(currentRow);
    while (trimmedRow.isNotEmpty && trimmedRow.last.isEmpty) {
      trimmedRow.removeLast();
    }
    if (trimmedRow.isNotEmpty) {
      rows.add(trimmedRow);
    }

    return rows;
  }
}