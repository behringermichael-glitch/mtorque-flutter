import 'anatomy_models.dart';

class AnatomyAssetResolver {
  static const String skeletonFront =
      'assets/images/anatomy/skeleton_front.png';
  static const String skeletonBack =
      'assets/images/anatomy/skeleton_back.png';

  static String skeletonForSide(AnatomySide side) {
    switch (side) {
      case AnatomySide.front:
        return skeletonFront;
      case AnatomySide.back:
        return skeletonBack;
    }
  }

  static String? overlayPathFor({
    required AnatomySide side,
    required String muscleName,
  }) {
    final normalized = normalizeMuscleName(muscleName);
    if (normalized.isEmpty) {
      return null;
    }

    final sidePrefix = side == AnatomySide.front ? 'front' : 'back';
    return 'assets/images/anatomy/overlays/muscle_${sidePrefix}_$normalized.png';
  }

  static String normalizeMuscleName(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll('.', '')
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('ß', 'ss')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll('-', '_')
        .replaceAll('/', '_')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^a-z0-9_]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }
}