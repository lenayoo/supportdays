part of '../../main.dart';

bool _isTabletLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).shortestSide >= 700;
}

class _ResultBackdrop extends StatelessWidget {
  const _ResultBackdrop({required this.mood});

  final MoodOption mood;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTabletLayout(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF8EA), Color(0xFFFFF1DE), Color(0xFFFCEAD8)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final tabletScale =
              isTablet ? (size.width / 820).clamp(1.0, 1.18) : 1.0;
          final panelWidth =
              isTablet
                  ? min(size.width * 0.50, 500.0 * tabletScale)
                  : size.width - 150;
          final panelHeight =
              isTablet
                  ? min(size.height * 0.42, 390.0 * tabletScale)
                  : panelWidth / 0.78;
          final panelTop = isTablet ? max(148.0, size.height * 0.19) : 150.0;

          return Stack(
            children: [
              Positioned(
                left: isTablet ? -44 : -60,
                top: isTablet ? -18 : -30,
                child: _BackdropShape(
                  width: isTablet ? 320 * tabletScale : 240,
                  height: isTablet ? 252 * tabletScale : 200,
                  color: const Color(0xFFFFD38C),
                ),
              ),
              Positioned(
                right: isTablet ? -42 : -70,
                top: isTablet ? 28 : 40,
                child: _BackdropShape(
                  width: isTablet ? 330 * tabletScale : 250,
                  height: isTablet ? 264 * tabletScale : 210,
                  color: const Color(0xFFF3AEC8),
                ),
              ),
              Positioned(
                left: isTablet ? 18 : 36,
                top: isTablet ? 210 : 220,
                child: _BackdropShape(
                  width: isTablet ? 188 * tabletScale : 128,
                  height: isTablet ? 150 * tabletScale : 106,
                  color: const Color(0xFFFFB39D),
                ),
              ),
              Positioned(
                left: (size.width - panelWidth) / 2,
                top: panelTop,
                child:
                    isTablet
                        ? _BackdropBlob(
                          width: panelWidth,
                          height: panelHeight,
                          color: mood.shapeColor.withValues(alpha: 0.28),
                          shapeStyle: mood.shapeStyle,
                          cornerA: mood.cornerA,
                          cornerB: mood.cornerB,
                          cornerC: mood.cornerC,
                          cornerD: mood.cornerD,
                        )
                        : _BackdropShape(
                          width: panelWidth,
                          height: panelHeight,
                          color: mood.shapeColor.withValues(
                            alpha: isTablet ? 0.82 : 0.92,
                          ),
                        ),
              ),
              if (isTablet)
                Positioned(
                  left: size.width * 0.14,
                  top: size.height * 0.14,
                  child: _BackdropBlob(
                    width: 168 * tabletScale,
                    height: 132 * tabletScale,
                    color: const Color(0xFFFFE1A8).withValues(alpha: 0.62),
                    shapeStyle: BlobShapeStyle.bean,
                    cornerA: 0.48,
                    cornerB: 0.56,
                    cornerC: 0.44,
                    cornerD: 0.60,
                  ),
                ),
              if (isTablet)
                Positioned(
                  right: size.width * 0.10,
                  top: size.height * 0.50,
                  child: _BackdropBlob(
                    width: 144 * tabletScale,
                    height: 118 * tabletScale,
                    color: const Color(0xFFD9D4F4).withValues(alpha: 0.56),
                    shapeStyle: BlobShapeStyle.softPebble,
                    cornerA: 0.54,
                    cornerB: 0.38,
                    cornerC: 0.62,
                    cornerD: 0.46,
                  ),
                ),
              if (isTablet)
                Positioned(
                  left: size.width * 0.10,
                  bottom: size.height * 0.13,
                  child: _BackdropBlob(
                    width: 188 * tabletScale,
                    height: 144 * tabletScale,
                    color: const Color(0xFFFFD8CF).withValues(alpha: 0.52),
                    shapeStyle: BlobShapeStyle.wideCloud,
                    cornerA: 0.46,
                    cornerB: 0.58,
                    cornerC: 0.40,
                    cornerD: 0.52,
                  ),
                ),
              if (isTablet)
                Positioned(
                  left: size.width * 0.56,
                  top: size.height * 0.12,
                  child: _BackdropBlob(
                    width: 132 * tabletScale,
                    height: 104 * tabletScale,
                    color: const Color(0xFFCFE0F6).withValues(alpha: 0.50),
                    shapeStyle: BlobShapeStyle.leanPebble,
                    cornerA: 0.42,
                    cornerB: 0.60,
                    cornerC: 0.48,
                    cornerD: 0.36,
                  ),
                ),
              Positioned(
                left: isTablet ? -14 : -24,
                bottom: isTablet ? -6 : -12,
                child: _BackdropShape(
                  width: isTablet ? 308 * tabletScale : 220,
                  height: isTablet ? 212 * tabletScale : 160,
                  color: const Color(0xFFFF9F58),
                ),
              ),
              Positioned(
                right: isTablet ? -10 : -26,
                bottom: isTablet ? -14 : -26,
                child: _BackdropShape(
                  width: isTablet ? 294 * tabletScale : 210,
                  height: isTablet ? 244 * tabletScale : 200,
                  color: const Color(0xFF8F6CCD),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackdropBlob extends StatelessWidget {
  const _BackdropBlob({
    required this.width,
    required this.height,
    required this.color,
    required this.shapeStyle,
    required this.cornerA,
    required this.cornerB,
    required this.cornerC,
    required this.cornerD,
  });

  final double width;
  final double height;
  final Color color;
  final BlobShapeStyle shapeStyle;
  final double cornerA;
  final double cornerB;
  final double cornerC;
  final double cornerD;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _BlobPainter(
          color: color,
          shapeStyle: shapeStyle,
          cornerA: cornerA,
          cornerB: cornerB,
          cornerC: cornerC,
          cornerD: cornerD,
        ),
      ),
    );
  }
}

class _BackdropShape extends StatelessWidget {
  const _BackdropShape({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(120),
        ),
      ),
    );
  }
}

class _EntryBlob extends StatelessWidget {
  const _EntryBlob({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
    required this.shapeStyle,
    required this.face,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final BlobShapeStyle shapeStyle;
  final BlobFaceStyle face;

  @override
  Widget build(BuildContext context) {
    final faceColor = const Color(0xFF2F2927).withValues(alpha: 0.56);
    final strokeWidth = min(width, height) * 0.013;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: CustomPaint(
        painter: _BlobPainter(
          color: color,
          shapeStyle: shapeStyle,
          cornerA: 0.56,
          cornerB: 0.38,
          cornerC: 0.60,
          cornerD: 0.44,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: CustomPaint(
            painter: _FacePainter(
              style: face,
              color: faceColor,
              strokeWidth: strokeWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _NameBadge extends StatelessWidget {
  const _NameBadge({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: const Color(0xFF3B3431).withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: cuteTextStyle(
                  AppLanguage.fromLocale(
                    WidgetsBinding.instance.platformDispatcher.locale,
                  ),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2A29),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.edit_rounded,
                size: 16,
                color: Color(0xFF2D2A29),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  const _MoodTag({required this.strings, required this.mood});

  final AppStrings strings;
  final MoodOption mood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mood.shapeColor.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
      ),
      child: Text(
        strings.moodLabel(mood.key),
        style: theme.textTheme.labelLarge?.copyWith(
          color: const Color(0xFF4C6057),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MovingCloud extends StatelessWidget {
  const _MovingCloud({
    required this.left,
    required this.top,
    required this.width,
    required this.color,
  });

  final double left;
  final double top;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: width * 0.50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(80),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}
