part of supportdays_app;

class MoodOption {
  const MoodOption({
    required this.key,
    required this.labelColor,
    required this.shapeColor,
    required this.shapeStyle,
    required this.widthFactor,
    required this.heightFactor,
    required this.initialCenter,
    required this.initialVelocity,
    required this.cornerA,
    required this.cornerB,
    required this.cornerC,
    required this.cornerD,
    required this.face,
  });

  final String key;
  final Color labelColor;
  final Color shapeColor;
  final BlobShapeStyle shapeStyle;
  final double widthFactor;
  final double heightFactor;
  final Offset initialCenter;
  final Offset initialVelocity;
  final double cornerA;
  final double cornerB;
  final double cornerC;
  final double cornerD;
  final BlobFaceStyle face;
}

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.title,
    required this.summary,
    required this.flowReading,
    required this.actionTip,
    required this.moods,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String,
      flowReading: json['flow_reading'] as String,
      actionTip: json['action_tip'] as String,
      moods: (json['mood'] as List<dynamic>).cast<String>(),
    );
  }

  final int id;
  final String title;
  final String summary;
  final String flowReading;
  final String actionTip;
  final List<String> moods;
}

enum BlobFaceStyle { smile, smallSmile, gentle, sleepy, excited, crying }

enum BlobShapeStyle {
  softPebble,
  wideCloud,
  tallDrop,
  bean,
  wonkyHeart,
  leanPebble,
}

class _BlobState {
  _BlobState({
    required this.mood,
    required this.center,
    required this.velocity,
    required this.wobbleSeed,
    required this.tiltSeed,
  });

  final MoodOption mood;
  Offset center;
  Offset velocity;
  final double wobbleSeed;
  final double tiltSeed;

  double widthFor(Size size) {
    final widthBase = size.width > size.height ? size.height * 1.12 : size.width;
    return widthBase * mood.widthFactor;
  }

  double heightFor(Size size) => size.height * mood.heightFactor;

  double collisionRadiusFor(Size size) {
    return max(widthFor(size), heightFor(size)) * 0.34;
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.drift,
    required this.speed,
    required this.opacity,
  });

  final double x;
  final double y;
  final double radius;
  final double drift;
  final double speed;
  final double opacity;
}

class _TiltMotionController {
  _TiltMotionController({
    required this.intensity,
    required this.smoothing,
    required this.onChanged,
  });

  final double intensity;
  final double smoothing;
  final ValueChanged<Offset> onChanged;
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  Offset _current = Offset.zero;

  void start() {
    _subscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen((event) {
      final target = Offset(
        (-event.x).clamp(-1.4, 1.4) * intensity,
        (event.y).clamp(-1.4, 1.4) * intensity,
      );
      _current = Offset.lerp(_current, target, smoothing) ?? target;
      onChanged(_current);
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
