import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../repositories/strength_repository.dart';

class StrengthPlanShareService {
  const StrengthPlanShareService({required StrengthRepository repository})
    : _repository = repository;

  final StrengthRepository _repository;

  Future<void> sharePlan(String planName) async {
    final cleanName = planName.trim();
    if (cleanName.isEmpty) {
      throw StateError('Plan name is empty.');
    }

    final exerciseIds = await _repository.loadPlanExerciseIds(cleanName);
    if (exerciseIds == null || exerciseIds.isEmpty) {
      throw StateError('Training plan has no exercises.');
    }

    final payload = <String, dynamic>{
      'type': 'mtorque.strength.plan',
      'version': 1,
      'name': cleanName,
      'exerciseIds': exerciseIds,
    };

    final tempDir = await getTemporaryDirectory();
    final fileName = '${_sanitizeFileName(cleanName)}.mtor';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
      flush: true,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: cleanName,
        text: cleanName,
      ),
    );
  }

  String _sanitizeFileName(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();

    if (cleaned.isEmpty) {
      return 'mtorque_training_plan';
    }

    return cleaned;
  }
}
