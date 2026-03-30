enum AnatomySide {
  front,
  back,
}

enum AnatomyMuscleRole {
  primary,
  secondary,
}

class AnatomyMuscleUsage {
  const AnatomyMuscleUsage({
    required this.muscleName,
    required this.groupName,
    required this.role,
  });

  final String muscleName;
  final String groupName;
  final AnatomyMuscleRole role;
}

class MuscleInfoEntry {
  const MuscleInfoEntry({
    required this.muscleName,
    required this.functionDe,
    required this.functionEn,
    required this.originDe,
    required this.originEn,
    required this.insertionDe,
    required this.insertionEn,
    required this.innervation,
  });

  final String muscleName;
  final String functionDe;
  final String functionEn;
  final String originDe;
  final String originEn;
  final String insertionDe;
  final String insertionEn;
  final String innervation;

  String functionForLanguage(String languageCode) {
    return languageCode.toLowerCase() == 'de' ? functionDe : functionEn;
  }

  String originForLanguage(String languageCode) {
    return languageCode.toLowerCase() == 'de' ? originDe : originEn;
  }

  String insertionForLanguage(String languageCode) {
    return languageCode.toLowerCase() == 'de' ? insertionDe : insertionEn;
  }
}