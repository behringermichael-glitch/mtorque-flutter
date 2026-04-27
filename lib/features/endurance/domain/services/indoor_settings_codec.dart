import 'dart:convert';

import '../models/indoor_axis_spec.dart';
import '../models/indoor_interval_phase.dart';
import '../models/indoor_interval_protocol.dart';

abstract final class IndoorSettingsCodec {
  static const String keyAxis = 'intervalAxisKey';
  static const String legacyKeyAxis = 'axisKey';
  static const String keyIntervals = 'intervals';
  static const String keyTotalSec = 'intervalTotalSec';
  static const String keyProtocolName = 'protocolName';
  static const String keyDurationSec = 'durSec';
  static const String keyIntensity = 'intensity';
  static const String keyExtra = 'extra';

  static String encode({
    required IndoorIntervalProtocol protocol,
    required String sportCode,
  }) {
    final axis = IndoorAxisSpec.forSportCode(sportCode);
    final extra = axis.extra;

    final root = <String, Object?>{
      keyAxis: protocol.axisKey,
      keyIntervals: protocol.phases.map((phase) {
        final phaseJson = <String, Object?>{
          keyDurationSec: phase.durSec,
          keyIntensity: phase.intensity,
        };

        if (phase.extra.isNotEmpty) {
          phaseJson[keyExtra] = phase.extra;
        }

        return phaseJson;
      }).toList(growable: false),
      keyTotalSec: protocol.totalSec,
      axis.key: protocol.weightedIntensityAverage(
        decimals: axis.decimals,
      ),
    };

    final protocolName = protocol.protocolName?.trim();
    if (protocolName != null && protocolName.isNotEmpty) {
      root[keyProtocolName] = protocolName;
    }

    if (extra != null) {
      final weightedExtra = protocol.weightedExtraAverage(
        key: extra.key,
        fallback: extra.defaultValue,
        decimals: extra.decimals,
      );

      if (weightedExtra != null) {
        root[extra.key] = weightedExtra;
      }
    }

    return jsonEncode(root);
  }

  static IndoorIntervalProtocol decode({
    required String json,
    required String sportCode,
  }) {
    final axis = IndoorAxisSpec.forSportCode(sportCode);
    final decoded = jsonDecode(json);

    if (decoded is! Map<String, dynamic>) {
      return IndoorIntervalProtocol.defaultForSportCode(sportCode);
    }

    final axisKey = _readString(decoded[keyAxis]) ??
        _readString(decoded[legacyKeyAxis]) ??
        axis.key;

    final protocolName = _readString(decoded[keyProtocolName]);

    final rawIntervals = decoded[keyIntervals];
    if (rawIntervals is! List) {
      return IndoorIntervalProtocol.defaultForSportCode(
        sportCode,
        protocolName: protocolName,
      );
    }

    final phases = <IndoorIntervalPhase>[];

    for (final item in rawIntervals) {
      if (item is! Map) {
        continue;
      }

      final durSec = _readInt(item[keyDurationSec]);
      final intensity = _readDouble(item[keyIntensity]);

      if (durSec == null || durSec <= 0 || intensity == null) {
        continue;
      }

      final extra = <String, double>{};
      final rawExtra = item[keyExtra];

      if (rawExtra is Map) {
        for (final entry in rawExtra.entries) {
          final key = entry.key?.toString();
          final value = _readDouble(entry.value);

          if (key != null && key.isNotEmpty && value != null) {
            extra[key] = value;
          }
        }
      }

      phases.add(
        IndoorIntervalPhase(
          durSec: durSec,
          intensity: intensity,
          extra: extra,
        ),
      );
    }

    if (phases.isEmpty) {
      return IndoorIntervalProtocol.defaultForSportCode(
        sportCode,
        protocolName: protocolName,
      );
    }

    return IndoorIntervalProtocol(
      axisKey: axisKey,
      protocolName: protocolName,
      phases: phases,
    );
  }

  static String encodeDefaultForSport(
      String sportCode, {
        String? protocolName,
      }) {
    return encode(
      protocol: IndoorIntervalProtocol.defaultForSportCode(
        sportCode,
        protocolName: protocolName,
      ),
      sportCode: sportCode,
    );
  }

  static String? _readString(Object? value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  static double? _readDouble(Object? value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
  }
}