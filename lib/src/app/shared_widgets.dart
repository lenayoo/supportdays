part of supportdays_app;

class _ResultBackdrop extends StatelessWidget {
  const _ResultBackdrop({
    required this.mood,
  });

  final MoodOption mood;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8EA),
            Color(0xFFFFF1DE),
            Color(0xFFFCEAD8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: -30,
            child: _BackdropShape(
              width: 240,
              height: 200,
              color: const Color(0xFFFFD38C),
            ),
          ),
          Positioned(
            right: -70,
            top: 40,
            child: _BackdropShape(
              width: 250,
              height: 210,
              color: const Color(0xFFF3AEC8),
            ),
          ),
          Positioned(
            left: 36,
            top: 220,
            child: _BackdropShape(
              width: 128,
              height: 106,
              color: const Color(0xFFFFB39D),
            ),
          ),
          Positioned(
            left: 80,
            right: 70,
            top: 150,
            child: _BackdropShape(
              width: 0,
              height: 0,
              expand: true,
              color: mood.shapeColor.withValues(alpha: 0.92),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -12,
            child: _BackdropShape(
              width: 220,
              height: 160,
              color: const Color(0xFFFF9F58),
            ),
          ),
          Positioned(
            right: -26,
            bottom: -26,
            child: _BackdropShape(
              width: 210,
              height: 200,
              color: const Color(0xFF8F6CCD),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropShape extends StatelessWidget {
  const _BackdropShape({
    required this.width,
    required this.height,
    required this.color,
    this.expand = false,
  });

  final double width;
  final double height;
  final Color color;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(120),
      ),
    );

    if (expand) {
      return AspectRatio(
        aspectRatio: 0.78,
        child: child,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: child,
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
  const _NameBadge({
    required this.text,
    required this.onTap,
  });

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

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: cuteTextStyle(
            AppLanguage.fromLocale(
              WidgetsBinding.instance.platformDispatcher.locale,
            ),
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9B847A),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: cuteTextStyle(
            AppLanguage.fromLocale(
              WidgetsBinding.instance.platformDispatcher.locale,
            ),
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7A6A63),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _MoodTag extends StatelessWidget {
  const _MoodTag({
    required this.strings,
    required this.mood,
  });

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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
        ),
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
