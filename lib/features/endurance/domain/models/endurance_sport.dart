enum EnduranceMode {
  outdoor,
  indoor,
}

class EnduranceSport {
  const EnduranceSport({
    required this.code,
    required this.mode,
    required this.assetName,
  });

  final String code;
  final EnduranceMode mode;
  final String assetName;

  String get assetPath => 'assets/images/endurance/$assetName';
}

abstract final class EnduranceSports {
  static const run = EnduranceSport(
    code: 'RUN',
    mode: EnduranceMode.outdoor,
    assetName: 'run.png',
  );

  static const mountainBike = EnduranceSport(
    code: 'MTB',
    mode: EnduranceMode.outdoor,
    assetName: 'mtb.png',
  );

  static const roadBike = EnduranceSport(
    code: 'ROADBIKE',
    mode: EnduranceMode.outdoor,
    assetName: 'roadbike.png',
  );

  static const rowingOutdoor = EnduranceSport(
    code: 'ROW',
    mode: EnduranceMode.outdoor,
    assetName: 'rowing.png',
  );

  static const walking = EnduranceSport(
    code: 'WALKING',
    mode: EnduranceMode.outdoor,
    assetName: 'walking.png',
  );

  static const nordicWalking = EnduranceSport(
    code: 'NORDIC_WALKING',
    mode: EnduranceMode.outdoor,
    assetName: 'nordic_walking.png',
  );

  static const inlineSkating = EnduranceSport(
    code: 'INLINE_SKATING',
    mode: EnduranceMode.outdoor,
    assetName: 'inline_skating.png',
  );

  static const treadmill = EnduranceSport(
    code: 'TREADMILL',
    mode: EnduranceMode.indoor,
    assetName: 'treadmill.png',
  );

  static const treadmillWalking = EnduranceSport(
    code: 'TREADMILL_WALKING',
    mode: EnduranceMode.indoor,
    assetName: 'treadmill_walking.png',
  );

  static const ergometer = EnduranceSport(
    code: 'ERGOMETER',
    mode: EnduranceMode.indoor,
    assetName: 'ergometer.png',
  );

  static const rower = EnduranceSport(
    code: 'ROWER',
    mode: EnduranceMode.indoor,
    assetName: 'rower.png',
  );

  static const spinning = EnduranceSport(
    code: 'SPINNING',
    mode: EnduranceMode.indoor,
    assetName: 'spinning.png',
  );

  static const crosstrainer = EnduranceSport(
    code: 'CROSSTRAINER',
    mode: EnduranceMode.indoor,
    assetName: 'crosstrainer.png',
  );

  static const stairclimber = EnduranceSport(
    code: 'STAIRCLIMBER',
    mode: EnduranceMode.indoor,
    assetName: 'stairclimber.png',
  );

  static const stepper = EnduranceSport(
    code: 'STEPPER',
    mode: EnduranceMode.indoor,
    assetName: 'stepper.png',
  );

  static const jumpRope = EnduranceSport(
    code: 'JUMPROPE',
    mode: EnduranceMode.indoor,
    assetName: 'jump_rope.png',
  );

  static const skiErgometer = EnduranceSport(
    code: 'SKI_ERGOMETER',
    mode: EnduranceMode.indoor,
    assetName: 'ski_ergometer.png',
  );

  static const armErgometer = EnduranceSport(
    code: 'ARM_ERGOMETER',
    mode: EnduranceMode.indoor,
    assetName: 'arm_ergometer.png',
  );

  static const airBike = EnduranceSport(
    code: 'AIR_BIKE',
    mode: EnduranceMode.indoor,
    assetName: 'air_bike.png',
  );

  static const outdoor = <EnduranceSport>[
    run,
    mountainBike,
    roadBike,
    rowingOutdoor,
    walking,
    nordicWalking,
    inlineSkating,
  ];

  static const indoor = <EnduranceSport>[
    treadmill,
    treadmillWalking,
    ergometer,
    rower,
    spinning,
    crosstrainer,
    stairclimber,
    stepper,
    jumpRope,
    skiErgometer,
    armErgometer,
    airBike,
  ];

  static const all = <EnduranceSport>[
    ...outdoor,
    ...indoor,
  ];
}