part of '../../main.dart';

class _EntryStep extends StatefulWidget {
  const _EntryStep({
    super.key,
    required this.strings,
    required this.name,
    required this.onStart,
    required this.onEditName,
  });

  final AppStrings strings;
  final String name;
  final VoidCallback onStart;
  final VoidCallback onEditName;

  @override
  State<_EntryStep> createState() => _EntryStepState();
}

class _EntryStepState extends State<_EntryStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();
  late final _TiltMotionController _tiltController = _TiltMotionController(
    intensity: 5.6,
    smoothing: 0.06,
    onChanged: (offset) {
      if (mounted) {
        setState(() {
          _tiltOffset = offset;
        });
      }
    },
  );
  Offset _tiltOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _tiltController.start();
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * pi * 2;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final entryWidthBase = width > height ? height * 1.14 : width;

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DottedPaperPainter(
                      color: const Color(0xFFE3D9C8),
                    ),
                  ),
                ),
                _EntryBlob(
                  left: -width * 0.08 + sin(t) * 12 + _tiltOffset.dx * 0.55,
                  top:
                      height * 0.02 + cos(t * 0.8) * 10 + _tiltOffset.dy * 0.55,
                  width: entryWidthBase * 0.54,
                  height: height * 0.34,
                  color: const Color(0xFFFFD38C),
                  shapeStyle: BlobShapeStyle.softPebble,
                  face: BlobFaceStyle.crying,
                ),
                _EntryBlob(
                  left:
                      width * 0.46 + cos(t * 0.7) * 10 - _tiltOffset.dx * 0.48,
                  top:
                      -height * 0.01 +
                      sin(t * 0.9) * 12 +
                      _tiltOffset.dy * 0.44,
                  width: entryWidthBase * 0.54,
                  height: height * 0.32,
                  color: const Color(0xFFF3AEC8),
                  shapeStyle: BlobShapeStyle.wideCloud,
                  face: BlobFaceStyle.gentle,
                ),
                _EntryBlob(
                  left: width * 0.20 + sin(t * 1.1) * 8 + _tiltOffset.dx * 0.36,
                  top:
                      height * 0.22 + cos(t * 0.6) * 14 - _tiltOffset.dy * 0.30,
                  width: entryWidthBase * 0.48,
                  height: height * 0.30,
                  color: const Color(0xFFA9BDE8),
                  shapeStyle: BlobShapeStyle.tallDrop,
                  face: BlobFaceStyle.sleepy,
                ),
                _EntryBlob(
                  left:
                      -width * 0.10 +
                      cos(t * 0.85) * 11 -
                      _tiltOffset.dx * 0.28,
                  top:
                      height * 0.33 + sin(t * 0.7) * 10 + _tiltOffset.dy * 0.24,
                  width: entryWidthBase * 0.34,
                  height: height * 0.20,
                  color: const Color(0xFFFFA48E),
                  shapeStyle: BlobShapeStyle.bean,
                  face: BlobFaceStyle.smallSmile,
                ),
                _EntryBlob(
                  left:
                      -width * 0.03 +
                      sin(t * 0.75) * 10 +
                      _tiltOffset.dx * 0.52,
                  top:
                      height * 0.72 +
                      cos(t * 0.95) * 12 -
                      _tiltOffset.dy * 0.62,
                  width: entryWidthBase * 0.52,
                  height: height * 0.24,
                  color: const Color(0xFFFF9F58),
                  shapeStyle: BlobShapeStyle.wonkyHeart,
                  face: BlobFaceStyle.excited,
                ),
                _EntryBlob(
                  left:
                      width * 0.48 + cos(t * 0.8) * 10 - _tiltOffset.dx * 0.60,
                  top:
                      height * 0.60 +
                      sin(t * 0.92) * 14 -
                      _tiltOffset.dy * 0.36,
                  width: entryWidthBase * 0.48,
                  height: height * 0.30,
                  color: const Color(0xFF8F6CCD),
                  shapeStyle: BlobShapeStyle.leanPebble,
                  face: BlobFaceStyle.smallSmile,
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: _NameBadge(
                            text:
                                widget.name.isEmpty
                                    ? widget.strings.entryHeader
                                    : widget.strings.entryHeaderWithName(
                                      widget.name,
                                    ),
                            onTap: widget.onEditName,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: widget.onStart,
                              borderRadius: BorderRadius.circular(999),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: width * 0.86,
                                ),
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 52,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.72),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: const Color(0xFF3B3431),
                                      width: 1.3,
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.strings.entryButton,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: cuteTextStyle(
                                        widget.strings.language,
                                        fontSize: 52,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2C2421),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _MoodStep extends StatelessWidget {
  const _MoodStep({
    super.key,
    required this.strings,
    required this.name,
    required this.moods,
    required this.onSelect,
  });

  final AppStrings strings;
  final String name;
  final List<MoodOption> moods;
  final ValueChanged<MoodOption> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty
                          ? strings.moodPrompt
                          : strings.moodPromptWithName(name),
                      style: cuteTextStyle(
                        strings.language,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF28211F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.moodDescription,
                      style: const TextStyle(
                        color: Color(0xFF685F5A),
                        height: 1.45,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _FloatingMoodField(
            moods: moods,
            strings: strings,
            onSelect: onSelect,
          ),
        ),
      ],
    );
  }
}

class _FloatingMoodField extends StatefulWidget {
  const _FloatingMoodField({
    required this.moods,
    required this.strings,
    required this.onSelect,
  });

  final List<MoodOption> moods;
  final AppStrings strings;
  final ValueChanged<MoodOption> onSelect;

  @override
  State<_FloatingMoodField> createState() => _FloatingMoodFieldState();
}

class _FloatingMoodFieldState extends State<_FloatingMoodField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController.unbounded(
    vsync: this,
  )..repeat(min: 0, max: 1, period: const Duration(seconds: 1));

  final Random _random = Random();
  final List<_BlobState> _blobs = [];
  late final _TiltMotionController _tiltController = _TiltMotionController(
    intensity: 1.4,
    smoothing: 0.05,
    onChanged: (offset) {
      if (mounted) {
        setState(() {
          _tiltOffset = offset;
        });
      }
    },
  );

  Size _size = Size.zero;
  Duration? _lastElapsed;
  Offset _tiltOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_tick);
    _tiltController.start();
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
    _tiltController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _resetBlobs(Size size) {
    _blobs
      ..clear()
      ..addAll(
        widget.moods.map(
          (mood) => _BlobState(
            mood: mood,
            center: Offset(
              mood.initialCenter.dx * size.width,
              mood.initialCenter.dy * size.height,
            ),
            velocity: mood.initialVelocity,
            wobbleSeed: _random.nextDouble() * pi * 2,
            tiltSeed: _random.nextDouble() * pi * 2,
          ),
        ),
      );
  }

  void _tick() {
    if (!mounted || _size == Size.zero || _blobs.isEmpty) {
      return;
    }

    final elapsed = _controller.lastElapsedDuration;
    if (elapsed == null) {
      return;
    }

    final lastElapsed = _lastElapsed ?? elapsed;
    var dt =
        (elapsed - lastElapsed).inMicroseconds / Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;
    if (dt <= 0) {
      return;
    }
    dt = dt.clamp(0.0, 0.032);

    final bounds = Rect.fromLTWH(0, 0, _size.width, _size.height);
    const padding = 18.0;

    for (final blob in _blobs) {
      blob.center += blob.velocity * dt;

      final radiusX = blob.widthFor(_size) / 2;
      final radiusY = blob.heightFor(_size) / 2;

      if (blob.center.dx - radiusX < padding) {
        blob.center = Offset(padding + radiusX, blob.center.dy);
        blob.velocity = Offset(blob.velocity.dx.abs(), blob.velocity.dy);
      } else if (blob.center.dx + radiusX > bounds.width - padding) {
        blob.center = Offset(bounds.width - padding - radiusX, blob.center.dy);
        blob.velocity = Offset(-blob.velocity.dx.abs(), blob.velocity.dy);
      }

      if (blob.center.dy - radiusY < padding) {
        blob.center = Offset(blob.center.dx, padding + radiusY);
        blob.velocity = Offset(blob.velocity.dx, blob.velocity.dy.abs());
      } else if (blob.center.dy + radiusY > bounds.height - padding) {
        blob.center = Offset(blob.center.dx, bounds.height - padding - radiusY);
        blob.velocity = Offset(blob.velocity.dx, -blob.velocity.dy.abs());
      }
    }

    for (var i = 0; i < _blobs.length; i++) {
      for (var j = i + 1; j < _blobs.length; j++) {
        final a = _blobs[i];
        final b = _blobs[j];
        final delta = b.center - a.center;
        final distance = delta.distance;
        final minDistance =
            a.collisionRadiusFor(_size) + b.collisionRadiusFor(_size);
        if (distance == 0 || distance >= minDistance) {
          continue;
        }

        final normal = delta / distance;
        final overlap = minDistance - distance;
        a.center -= normal * (overlap / 2);
        b.center += normal * (overlap / 2);

        final relativeVelocity = a.velocity - b.velocity;
        final speedAlongNormal =
            relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy;
        if (speedAlongNormal > 0) {
          continue;
        }

        final impulse = normal * speedAlongNormal;
        a.velocity -= impulse;
        b.velocity += impulse;

        a.velocity *= 0.98;
        b.velocity *= 0.98;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newSize = Size(constraints.maxWidth, constraints.maxHeight);
        final sizeDelta =
            Offset(
              _size.width - newSize.width,
              _size.height - newSize.height,
            ).distance;
        if (sizeDelta > 1 || _blobs.isEmpty) {
          _size = newSize;
          _lastElapsed = null;
          _resetBlobs(newSize);
        }

        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFF7E4).withValues(alpha: 0.8),
                      const Color(0xFFFFF1D8).withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
            ),
            for (final blob in _blobs)
              _FloatingBlobWidget(
                blob: blob,
                size: _size,
                tiltOffset: _tiltOffset,
                label: widget.strings.moodLabel(blob.mood.key),
                onTap: () => widget.onSelect(blob.mood),
              ),
          ],
        );
      },
    );
  }
}

class _FloatingBlobWidget extends StatelessWidget {
  const _FloatingBlobWidget({
    required this.blob,
    required this.size,
    required this.tiltOffset,
    required this.label,
    required this.onTap,
  });

  final _BlobState blob;
  final Size size;
  final Offset tiltOffset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = blob.widthFor(size);
    final height = blob.heightFor(size);
    final fontScale = blob.mood.key == 'motivation' ? 0.88 : 1.0;
    final t = DateTime.now().millisecondsSinceEpoch / 1000;
    final wobble = sin(t * 0.8 + blob.wobbleSeed) * 6;
    final tilt = sin(t * 0.55 + blob.tiltSeed) * 0.05;
    final parallax = Offset(
      tiltOffset.dx * (0.36 + (blob.wobbleSeed % 1.1) * 0.12),
      tiltOffset.dy * (0.30 + (blob.tiltSeed % 1.1) * 0.10),
    );

    return Positioned(
      left: blob.center.dx - width / 2 + wobble + parallax.dx,
      top:
          blob.center.dy -
          height / 2 +
          cos(t * 0.7 + blob.wobbleSeed) * 5 +
          parallax.dy,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: tilt,
          child: CustomPaint(
            painter: _BlobPainter(
              color: blob.mood.shapeColor,
              shapeStyle: blob.mood.shapeStyle,
              cornerA: blob.mood.cornerA,
              cornerB: blob.mood.cornerB,
              cornerC: blob.mood.cornerC,
              cornerD: blob.mood.cornerD,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, 0.42),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: cuteTextStyle(
                        AppLanguage.fromLocale(
                          WidgetsBinding.instance.platformDispatcher.locale,
                        ),
                        fontSize: min(width, height) * 0.15 * fontScale,
                        fontWeight: FontWeight.w700,
                        color: blob.mood.labelColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -0.26),
                    child: IgnorePointer(
                      child: SizedBox(
                        width: width * 0.42,
                        height: height * 0.28,
                        child: CustomPaint(
                          painter: _FacePainter(
                            style: blob.mood.face,
                            color: blob.mood.labelColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingStep extends StatefulWidget {
  const _LoadingStep({
    super.key,
    required this.strings,
    required this.name,
    required this.mood,
  });

  final AppStrings strings;
  final String name;
  final MoodOption mood;

  @override
  State<_LoadingStep> createState() => _LoadingStepState();
}

class _LoadingStepState extends State<_LoadingStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 260,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value * pi * 2;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _MovingCloud(
                      left: 36 + sin(t) * 44,
                      top: 24 + cos(t * 0.9) * 18,
                      width: 140,
                      color: const Color(0xFFFFD8A2),
                    ),
                    _MovingCloud(
                      left: 162 + sin(t + 1.8) * 48,
                      top: 118 + cos(t * 1.1 + 0.8) * 20,
                      width: 112,
                      color: const Color(0xFFF3B6D1),
                    ),
                    _MovingCloud(
                      left: 94 + sin(t + 3.1) * 54,
                      top: 72 + cos(t + 0.2) * 26,
                      width: 156,
                      color: const Color(0xFFAEC3EA),
                    ),
                    Container(
                      width: 114,
                      height: 114,
                      decoration: BoxDecoration(
                        color: widget.mood.shapeColor.withValues(alpha: 0.78),
                        shape: BoxShape.circle,
                      ),
                      child: CustomPaint(
                        painter: _FacePainter(
                          style: widget.mood.face,
                          color: const Color(0xFF3C312E),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Text(
            widget.name.isEmpty
                ? widget.strings.loadingTitle
                : widget.strings.loadingTitleWithName(widget.name),
            textAlign: TextAlign.center,
            style: cuteTextStyle(
              widget.strings.language,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF302825),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.strings.loadingBody(
              widget.strings.moodLabel(widget.mood.key),
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF645651),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({
    super.key,
    required this.strings,
    required this.name,
    required this.mood,
    required this.message,
    required this.onChooseAgain,
  });

  final AppStrings strings;
  final String name;
  final MoodOption mood;
  final SupportMessage message;
  final VoidCallback onChooseAgain;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _ResultBackdrop(mood: mood)),
        const Positioned.fill(child: _ParticleBackground()),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 50),
                        child: Text(
                          name.isEmpty
                              ? strings.resultTitle
                              : strings.resultTitleWithName(name),
                          style: cuteTextStyle(
                            strings.language,
                            fontSize: 34,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF2F2A27),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 39),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFFFBF5,
                          ).withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0E6E5447),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 48),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.title,
                                    style: cuteTextStyle(
                                      strings.language,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF64534C),
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    message.flowReading,
                                    style: cuteTextStyle(
                                      strings.language,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF75645D),
                                      height: 1.55,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: _MoodTag(strings: strings, mood: mood),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Center(
                          child: FilledButton(
                            onPressed: onChooseAgain,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.76,
                              ),
                              foregroundColor: const Color(0xFF32423A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(strings.chooseAgainButton),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ParticleBackground extends StatefulWidget {
  const _ParticleBackground();

  @override
  State<_ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<_ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  late final List<_Particle> _particles = List.generate(
    16,
    (index) => _Particle(
      x: (index * 0.13 + 0.07) % 1,
      y: (index * 0.19 + 0.11) % 1,
      radius: 1.6 + (index % 4) * 0.75,
      drift: 12 + (index % 5) * 5,
      speed: 0.15 + (index % 6) * 0.05,
      opacity: 0.12 + (index % 4) * 0.035,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            progress: _controller.value,
            particles: _particles,
          ),
        );
      },
    );
  }
}
