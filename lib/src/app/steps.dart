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
    required this.onViewRecords,
  });

  final AppStrings strings;
  final String name;
  final List<MoodOption> moods;
  final ValueChanged<MoodOption> onSelect;
  final VoidCallback onViewRecords;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty
                    ? strings.moodPrompt
                    : strings.moodPromptWithName(name),
                style: cuteTextStyle(
                  strings.language,
                  fontSize: isTablet ? 38 : 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF28211F),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: onViewRecords,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE5F3FF),
                    foregroundColor: const Color(0xFF31516C),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 22 : 16,
                      vertical: isTablet ? 18 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    strings.viewMyRecordsButton,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: isTablet ? 18 : 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                strings.moodDescription,
                style: TextStyle(
                  color: const Color(0xFF685F5A),
                  height: 1.45,
                  fontSize: isTablet ? 19 : 15,
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
                decoration: const BoxDecoration(color: Color(0xFFFFF5E6)),
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
                        text: label,
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
    final isTablet = _isTabletLayout(context);
    final contentMaxWidth = isTablet ? 620.0 : 420.0;
    final artWidth = isTablet ? 380.0 : 280.0;
    final artHeight = isTablet ? 320.0 : 260.0;
    final titleSize = isTablet ? 44.0 : 32.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: artWidth,
                height: artHeight,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t = _controller.value * pi * 2;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        _MovingCloud(
                          left: artWidth * 0.09 + sin(t) * 44,
                          top: artHeight * 0.10 + cos(t * 0.9) * 18,
                          width: isTablet ? 164 : 140,
                          color: const Color(0xFFFFD8A2),
                        ),
                        _MovingCloud(
                          left: artWidth * 0.56 + sin(t + 1.8) * 48,
                          top: artHeight * 0.45 + cos(t * 1.1 + 0.8) * 20,
                          width: isTablet ? 132 : 112,
                          color: const Color(0xFFF3B6D1),
                        ),
                        _MovingCloud(
                          left: artWidth * 0.30 + sin(t + 3.1) * 54,
                          top: artHeight * 0.28 + cos(t + 0.2) * 26,
                          width: isTablet ? 184 : 156,
                          color: const Color(0xFFAEC3EA),
                        ),
                        Container(
                          width: isTablet ? 132 : 114,
                          height: isTablet ? 132 : 114,
                          decoration: BoxDecoration(
                            color: widget.mood.shapeColor.withValues(
                              alpha: 0.78,
                            ),
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
              SizedBox(height: isTablet ? 36 : 28),
              Text(
                widget.name.isEmpty
                    ? widget.strings.loadingTitle
                    : widget.strings.loadingTitleWithName(widget.name),
                textAlign: TextAlign.center,
                style: cuteTextStyle(
                  widget.strings.language,
                  fontSize: titleSize,
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
                  fontSize: isTablet ? 22 : null,
                ),
              ),
            ],
          ),
        ),
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
    required this.onRecord,
  });

  final AppStrings strings;
  final String name;
  final MoodOption mood;
  final SupportMessage message;
  final VoidCallback onChooseAgain;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isTablet = _isTabletLayout(context);

    return Stack(
      children: [
        Positioned.fill(child: _ResultBackdrop(mood: mood)),
        const Positioned.fill(child: _ParticleBackground()),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight =
                  isTablet
                      ? min(980.0, max(560.0, constraints.maxHeight - 260))
                      : max(305.0, constraints.maxHeight - 235);
              final cardWidth = isTablet ? 640.0 : 560.0;

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      name.isEmpty
                          ? strings.resultTitle
                          : strings.resultTitleWithName(name),
                      style: cuteTextStyle(
                        strings.language,
                        fontSize: isTablet ? 42 : 34,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2F2A27),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: cardWidth,
                            maxHeight: cardHeight,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding:
                                isTablet
                                    ? const EdgeInsets.fromLTRB(32, 34, 32, 34)
                                    : const EdgeInsets.fromLTRB(24, 28, 24, 28),
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
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(
                                      context,
                                    ).copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.title,
                                            style: cuteTextStyle(
                                              strings.language,
                                              fontSize: isTablet ? 44 : 38,
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
                                              fontSize: isTablet ? 29 : 26,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF75645D),
                                              height: 1.55,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: _MoodTag(strings: strings, mood: mood),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 13,
                        bottom: max(12, bottomInset),
                      ),
                      child: Center(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            FilledButton(
                              onPressed: onChooseAgain,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.76,
                                ),
                                foregroundColor: const Color(0xFF32423A),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 36 : 28,
                                  vertical: isTablet ? 18 : 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                strings.chooseAgainButton,
                                style: TextStyle(fontSize: isTablet ? 18 : null),
                              ),
                            ),
                            FilledButton(
                              onPressed: onRecord,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB07C),
                                foregroundColor: const Color(0xFF3C322F),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 36 : 28,
                                  vertical: isTablet ? 18 : 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                strings.recordButton,
                                style: TextStyle(fontSize: isTablet ? 18 : null),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecordFormStep extends StatelessWidget {
  const _RecordFormStep({
    super.key,
    required this.strings,
    required this.dateLabel,
    required this.mood,
    required this.message,
    required this.reasonController,
    required this.onSave,
    required this.onBack,
  });

  final AppStrings strings;
  final String dateLabel;
  final MoodOption mood;
  final SupportMessage message;
  final TextEditingController reasonController;
  final VoidCallback onSave;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);

    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF2FAFF),
                  Color(0xFFE5F5FF),
                  Color(0xFFD9EEFF),
                ],
              ),
            ),
          ),
        ),
        const Positioned.fill(child: _ParticleBackground()),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 34 : 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FDFF),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1438627E),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: Text(strings.chooseAgainButton),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        strings.emotionRecordTitle,
                        style: cuteTextStyle(
                          strings.language,
                          fontSize: isTablet ? 42 : 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF234057),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _RecordInfoCard(
                        label: strings.todayDateLabel,
                        backgroundColor: const Color(0xFFEFF8FF),
                        child: Text(
                          dateLabel,
                          style: cuteTextStyle(
                            strings.language,
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.reasonPrompt,
                        backgroundColor: const Color(0xFFEAF6FF),
                        child: TextField(
                          controller: reasonController,
                          maxLength: 50,
                          minLines: 2,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: strings.reasonHint,
                            filled: true,
                            fillColor: Colors.white,
                            counterStyle: const TextStyle(
                              color: Color(0xFF7592A8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.selectedEmotionLabel,
                        backgroundColor: const Color(0xFFEFF8FF),
                        child: _MoodTag(strings: strings, mood: mood),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.adviceLabel,
                        backgroundColor: const Color(0xFFEAF6FF),
                        child: Text(
                          message.title,
                          style: cuteTextStyle(
                            strings.language,
                            text: message.title,
                            fontSize: isTablet ? 30 : 26,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onSave,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF8FC7F7),
                            foregroundColor: const Color(0xFF1A3950),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 22 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            strings.recordButton,
                            style: TextStyle(fontSize: isTablet ? 22 : 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlyRecordsStep extends StatefulWidget {
  const _MonthlyRecordsStep({
    super.key,
    required this.strings,
    required this.records,
    required this.initiallySelectedDateKey,
    required this.onOpenRecord,
    required this.onBackHome,
  });

  final AppStrings strings;
  final Map<String, EmotionRecord> records;
  final String? initiallySelectedDateKey;
  final ValueChanged<EmotionRecord> onOpenRecord;
  final VoidCallback onBackHome;

  @override
  State<_MonthlyRecordsStep> createState() => _MonthlyRecordsStepState();
}

class _MonthlyRecordsStepState extends State<_MonthlyRecordsStep> {
  late DateTime _focusedMonth;
  String? _selectedDateKey;

  @override
  void initState() {
    super.initState();
    final initialDate =
        widget.initiallySelectedDateKey != null
            ? DateTime.tryParse('${widget.initiallySelectedDateKey}T00:00:00')
            : null;
    _focusedMonth =
        initialDate == null
            ? DateTime(DateTime.now().year, DateTime.now().month)
            : DateTime(initialDate.year, initialDate.month);
    _selectedDateKey = widget.initiallySelectedDateKey;
  }

  @override
  void didUpdateWidget(covariant _MonthlyRecordsStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initiallySelectedDateKey != oldWidget.initiallySelectedDateKey) {
      _selectedDateKey = widget.initiallySelectedDateKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);

    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF4FBFF),
                  Color(0xFFE7F6FF),
                  Color(0xFFDCEFFF),
                ],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: _ParticleBackground(
              density: 1.7,
              scale: 1.2,
              opacityBoost: 1.12,
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.strings.monthlyTitle,
                            style: cuteTextStyle(
                              widget.strings.language,
                              fontSize: isTablet ? 42 : 34,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF234057),
                            ),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: TextButton(
                          onPressed: widget.onBackHome,
                          child: Text(widget.strings.returnHomeButton),
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 10),
                    Text(
                      widget.records.isEmpty
                          ? widget.strings.noRecordMessage
                          : widget.strings.recordGuideMessage,
                      style: const TextStyle(
                        color: Color(0xFF58758A),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(isTablet ? 28 : 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FDFF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      child: Column(
                        children: [
                          _MonthHeader(
                            strings: widget.strings,
                            focusedMonth: _focusedMonth,
                            onPrevious: () {
                              setState(() {
                                _focusedMonth = DateTime(
                                  _focusedMonth.year,
                                  _focusedMonth.month - 1,
                                );
                              });
                            },
                            onNext: () {
                              setState(() {
                                _focusedMonth = DateTime(
                                  _focusedMonth.year,
                                  _focusedMonth.month + 1,
                                );
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          _MonthlyCalendarGrid(
                            strings: widget.strings,
                            focusedMonth: _focusedMonth,
                            records: widget.records,
                            selectedDateKey: _selectedDateKey,
                            onSelect: (dateKey, record) {
                              setState(() {
                                _selectedDateKey = dateKey;
                              });
                              if (record != null) {
                                widget.onOpenRecord(record);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordDetailStep extends StatelessWidget {
  const _RecordDetailStep({
    super.key,
    required this.strings,
    required this.dateLabel,
    required this.record,
    required this.onBackHome,
    required this.onBackToRecords,
  });

  final AppStrings strings;
  final String dateLabel;
  final EmotionRecord record;
  final VoidCallback onBackHome;
  final VoidCallback onBackToRecords;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);

    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF2FAFF),
                  Color(0xFFE3F4FF),
                  Color(0xFFD5ECFF),
                ],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: _ParticleBackground(
              density: 1.7,
              scale: 1.2,
              opacityBoost: 1.12,
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 34 : 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FDFF),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1438627E),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.recordSavedTitle,
                        style: cuteTextStyle(
                          strings.language,
                          fontSize: isTablet ? 42 : 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF234057),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _RecordInfoCard(
                        label: strings.todayDateLabel,
                        backgroundColor: const Color(0xFFEFF8FF),
                        child: Text(
                          dateLabel,
                          style: cuteTextStyle(
                            strings.language,
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.recordReasonLabel,
                        backgroundColor: const Color(0xFFEAF6FF),
                        child: Text(
                          record.reason,
                          style: cuteTextStyle(
                            strings.language,
                            text: record.reason,
                            fontSize: isTablet ? 26 : 22,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.selectedEmotionLabel,
                        backgroundColor: const Color(0xFFEFF8FF),
                        child: Text(
                          strings.moodLabel(record.moodKey),
                          style: cuteTextStyle(
                            strings.language,
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecordInfoCard(
                        label: strings.adviceLabel,
                        backgroundColor: const Color(0xFFEAF6FF),
                        child: Text(
                          record.messageTitle,
                          style: cuteTextStyle(
                            strings.language,
                            text: record.messageTitle,
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF436179),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: onBackHome,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF8FC7F7),
                                foregroundColor: const Color(0xFF1A3950),
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 22 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  strings.returnHomeButton,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: onBackToRecords,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF35516A),
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 22 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  strings.returnToRecordsButton,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordInfoCard extends StatelessWidget {
  const _RecordInfoCard({
    required this.label,
    required this.child,
    this.backgroundColor = const Color(0xFFFFF4EA),
  });

  final String label;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6F8AA1),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.strings,
    required this.focusedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final AppStrings strings;
  final DateTime focusedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  String _label() {
    switch (strings.language) {
      case AppLanguage.korean:
        return '${focusedMonth.year}년 ${focusedMonth.month}월';
      case AppLanguage.japanese:
        return '${focusedMonth.year}年 ${focusedMonth.month}月';
      case AppLanguage.english:
        return '${focusedMonth.month}/${focusedMonth.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            _label(),
            textAlign: TextAlign.center,
            style: cuteTextStyle(
              strings.language,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF35516A),
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _MonthlyCalendarGrid extends StatelessWidget {
  const _MonthlyCalendarGrid({
    required this.strings,
    required this.focusedMonth,
    required this.records,
    required this.selectedDateKey,
    required this.onSelect,
  });

  final AppStrings strings;
  final DateTime focusedMonth;
  final Map<String, EmotionRecord> records;
  final String? selectedDateKey;
  final void Function(String dateKey, EmotionRecord? record) onSelect;

  static const _weekdayLabelsKo = ['일', '월', '화', '수', '목', '금', '토'];
  static const _weekdayLabelsJa = ['日', '月', '火', '水', '木', '金', '土'];
  static const _weekdayLabelsEn = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  List<String> _weekdayLabels() {
    switch (strings.language) {
      case AppLanguage.korean:
        return _weekdayLabelsKo;
      case AppLanguage.japanese:
        return _weekdayLabelsJa;
      case AppLanguage.english:
        return _weekdayLabelsEn;
    }
  }

  String _keyFor(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Color _dotColorForMood(String moodKey) {
    switch (moodKey) {
      case 'tired':
        return const Color(0xFFFFD38C);
      case 'love':
        return const Color(0xFFF3AEC8);
      case 'healing':
        return const Color(0xFFFFA48E);
      case 'gratitude':
        return const Color(0xFFA9BDE8);
      case 'motivation':
        return const Color(0xFFFF9F58);
      case 'growth':
        return const Color(0xFF8F6CCD);
      case 'confused':
        return const Color(0xFFC7D4F3);
      case 'lonely':
        return const Color(0xFFD8B9E6);
      default:
        return const Color(0xFF82BFF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final leadingEmptyCount = firstDay.weekday % 7;
    final totalCellCount = ((leadingEmptyCount + daysInMonth) / 7).ceil() * 7;
    final labels = _weekdayLabels();

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                labels[index],
                style: const TextStyle(
                  color: Color(0xFF7B98AE),
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCellCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final dayNumber = index - leadingEmptyCount + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(
              focusedMonth.year,
              focusedMonth.month,
              dayNumber,
            );
            final dateKey = _keyFor(date);
            final record = records[dateKey];
            final isSelected = dateKey == selectedDateKey;

            return InkWell(
              onTap: () => onSelect(dateKey, record),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFFDDF1FF)
                          : const Color(0xFFF7FCFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color:
                        record != null
                            ? const Color(0xFF8CC7F8)
                            : const Color(0xFFD7EAF8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              record != null
                                  ? const Color(0xFF2E4E66)
                                  : const Color(0xFF6F8AA1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              record != null
                                  ? _dotColorForMood(record.moodKey)
                                  : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ParticleBackground extends StatefulWidget {
  const _ParticleBackground({
    this.density = 1,
    this.scale = 1,
    this.opacityBoost = 1,
  });

  final double density;
  final double scale;
  final double opacityBoost;

  @override
  State<_ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<_ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = const [];
  }

  List<_Particle> _buildParticles({
    required int count,
    required double scale,
    required double opacityBoost,
  }) {
    return List.generate(
      count,
      (index) => _Particle(
        x: (index * 0.13 + 0.07) % 1,
        y: (index * 0.19 + 0.11) % 1,
        radius: (1.8 + (index % 4) * 0.8) * scale,
        drift: (12 + (index % 5) * 5) * scale,
        speed: 0.15 + (index % 6) * 0.05,
        opacity: (0.16 + (index % 4) * 0.045) * opacityBoost,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);
    final baseCount = isTablet ? 46 : 28;
    final baseScale = isTablet ? 1.2 : 1.1;
    final desiredCount = max(1, (baseCount * widget.density).round());
    final desiredScale = baseScale * widget.scale;

    _particles = _buildParticles(
      count: desiredCount,
      scale: desiredScale,
      opacityBoost: widget.opacityBoost,
    );

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
