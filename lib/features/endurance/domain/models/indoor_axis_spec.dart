class IndoorAxisSpec {
  const IndoorAxisSpec({
    required this.key,
    required this.min,
    required this.max,
    required this.step,
    required this.decimals,
    required this.defaultValue,
    this.extra,
  });

  final String key;
  final double min;
  final double max;
  final double step;
  final int decimals;
  final double defaultValue;
  final IndoorAxisSpec? extra;

  static IndoorAxisSpec forSportCode(String sportCode) {
    switch (sportCode.trim().toUpperCase()) {
      case 'TREADMILL':
      case 'TREADMILL_WALKING':
        return const IndoorAxisSpec(
          key: 'speedKmh',
          min: 2.0,
          max: 25.0,
          step: 0.1,
          decimals: 1,
          defaultValue: 10.0,
          extra: IndoorAxisSpec(
            key: 'inclinePct',
            min: 0.0,
            max: 20.0,
            step: 0.5,
            decimals: 1,
            defaultValue: 0.0,
          ),
        );

      case 'ERGOMETER':
        return const IndoorAxisSpec(
          key: 'powerW',
          min: 50.0,
          max: 800.0,
          step: 5.0,
          decimals: 0,
          defaultValue: 100.0,
        );

      case 'ROWER':
        return const IndoorAxisSpec(
          key: 'powerW',
          min: 50.0,
          max: 500.0,
          step: 5.0,
          decimals: 0,
          defaultValue: 100.0,
        );

      case 'SPINNING':
      case 'CROSSTRAINER':
      case 'STAIRCLIMBER':
      case 'STEPPER':
        return const IndoorAxisSpec(
          key: 'level',
          min: 1.0,
          max: 20.0,
          step: 1.0,
          decimals: 0,
          defaultValue: 5.0,
        );

      case 'JUMPROPE':
        return const IndoorAxisSpec(
          key: 'intensity',
          min: 1.0,
          max: 10.0,
          step: 1.0,
          decimals: 0,
          defaultValue: 5.0,
        );

      case 'SKI_ERGOMETER':
        return const IndoorAxisSpec(
          key: 'powerW',
          min: 30.0,
          max: 600.0,
          step: 5.0,
          decimals: 0,
          defaultValue: 100.0,
        );

      case 'ARM_ERGOMETER':
        return const IndoorAxisSpec(
          key: 'powerW',
          min: 20.0,
          max: 400.0,
          step: 5.0,
          decimals: 0,
          defaultValue: 100.0,
        );

      case 'AIR_BIKE':
        return const IndoorAxisSpec(
          key: 'powerW',
          min: 30.0,
          max: 1200.0,
          step: 5.0,
          decimals: 0,
          defaultValue: 100.0,
        );

      default:
        return const IndoorAxisSpec(
          key: 'intensity',
          min: 1.0,
          max: 10.0,
          step: 0.5,
          decimals: 1,
          defaultValue: 5.0,
        );
    }
  }

  double roundValue(double value) {
    final factor = _pow10(decimals);
    return (value * factor).roundToDouble() / factor;
  }

  static double _pow10(int decimals) {
    var result = 1.0;
    for (var i = 0; i < decimals; i++) {
      result *= 10.0;
    }
    return result;
  }
}