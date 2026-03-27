part of '../../main.dart';

class _BlobPainter extends CustomPainter {
  const _BlobPainter({
    required this.color,
    required this.shapeStyle,
    required this.cornerA,
    required this.cornerB,
    required this.cornerC,
    required this.cornerD,
  });

  final Color color;
  final BlobShapeStyle shapeStyle;
  final double cornerA;
  final double cornerB;
  final double cornerC;
  final double cornerD;

  @override
  void paint(Canvas canvas, Size size) {
    final path = switch (shapeStyle) {
      BlobShapeStyle.softPebble => _buildSoftPebble(size),
      BlobShapeStyle.wideCloud => _buildWideCloud(size),
      BlobShapeStyle.tallDrop => _buildTallDrop(size),
      BlobShapeStyle.bean => _buildBean(size),
      BlobShapeStyle.wonkyHeart => _buildWonkyHeart(size),
      BlobShapeStyle.leanPebble => _buildLeanPebble(size),
    };

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  Path _buildSoftPebble(Size size) {
    return Path()
      ..moveTo(size.width * 0.18, size.height * 0.10)
      ..quadraticBezierTo(
        size.width * (0.55 + (cornerA - 0.5) * 0.22),
        size.height * 0.00,
        size.width * 0.88,
        size.height * 0.16,
      )
      ..quadraticBezierTo(
        size.width,
        size.height * (0.38 + (cornerB - 0.5) * 0.24),
        size.width * 0.90,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * (0.64 + (cornerC - 0.5) * 0.25),
        size.height,
        size.width * 0.18,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        0,
        size.height * (0.58 + (cornerD - 0.5) * 0.22),
        size.width * 0.18,
        size.height * 0.10,
      )
      ..close();
  }

  Path _buildWideCloud(Size size) {
    return Path()
      ..moveTo(size.width * 0.12, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * (0.40 + (cornerA - 0.5) * 0.18),
        size.height * -0.02,
        size.width * 0.74,
        size.height * 0.08,
      )
      ..quadraticBezierTo(
        size.width * 1.02,
        size.height * (0.24 + (cornerB - 0.5) * 0.16),
        size.width * 0.94,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.96,
        size.height * 0.90,
        size.width * 0.62,
        size.height * 0.92,
      )
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 1.04,
        size.width * 0.10,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * -0.02,
        size.height * 0.46,
        size.width * 0.12,
        size.height * 0.22,
      )
      ..close();
  }

  Path _buildTallDrop(Size size) {
    return Path()
      ..moveTo(size.width * 0.28, size.height * 0.06)
      ..quadraticBezierTo(
        size.width * (0.52 + (cornerA - 0.5) * 0.18),
        size.height * -0.02,
        size.width * 0.80,
        size.height * 0.12,
      )
      ..quadraticBezierTo(
        size.width * 1.02,
        size.height * (0.36 + (cornerB - 0.5) * 0.20),
        size.width * 0.88,
        size.height * 0.84,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 1.02,
        size.width * 0.40,
        size.height * 0.95,
      )
      ..quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.80,
        size.width * 0.10,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.14,
        size.height * 0.14,
        size.width * 0.28,
        size.height * 0.06,
      )
      ..close();
  }

  Path _buildBean(Size size) {
    return Path()
      ..moveTo(size.width * 0.22, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.54,
        size.height * 0.00,
        size.width * 0.82,
        size.height * 0.18,
      )
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * (0.40 + (cornerB - 0.5) * 0.16),
        size.width * 0.80,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.64,
        size.height * 0.98,
        size.width * 0.26,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * -0.02,
        size.height * 0.72,
        size.width * 0.08,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.10,
        size.height * 0.24,
        size.width * 0.22,
        size.height * 0.16,
      )
      ..close();
  }

  Path _buildWonkyHeart(Size size) {
    return Path()
      ..moveTo(size.width * 0.20, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.16,
        size.height * 0.02,
        size.width * 0.40,
        size.height * 0.08,
      )
      ..quadraticBezierTo(
        size.width * (0.54 + (cornerA - 0.5) * 0.10),
        size.height * 0.12,
        size.width * 0.58,
        size.height * 0.26,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.02,
        size.width * 0.90,
        size.height * 0.18,
      )
      ..quadraticBezierTo(
        size.width * 1.02,
        size.height * 0.40,
        size.width * 0.82,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.90,
        size.width * 0.54,
        size.height * 0.98,
      )
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.90,
        size.width * 0.16,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.00,
        size.height * 0.50,
        size.width * 0.20,
        size.height * 0.30,
      )
      ..close();
  }

  Path _buildLeanPebble(Size size) {
    return Path()
      ..moveTo(size.width * 0.22, size.height * 0.08)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * -0.02,
        size.width * 0.88,
        size.height * 0.20,
      )
      ..quadraticBezierTo(
        size.width * 1.00,
        size.height * 0.46,
        size.width * 0.90,
        size.height * 0.84,
      )
      ..quadraticBezierTo(
        size.width * 0.70,
        size.height * 1.02,
        size.width * 0.24,
        size.height * 0.92,
      )
      ..quadraticBezierTo(
        size.width * 0.06,
        size.height * 0.74,
        size.width * 0.10,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.12,
        size.height * 0.18,
        size.width * 0.22,
        size.height * 0.08,
      )
      ..close();
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.shapeStyle != shapeStyle ||
        oldDelegate.cornerA != cornerA ||
        oldDelegate.cornerB != cornerB ||
        oldDelegate.cornerC != cornerC ||
        oldDelegate.cornerD != cornerD;
  }
}

class _FacePainter extends CustomPainter {
  const _FacePainter({
    required this.style,
    required this.color,
    this.strokeWidth,
  });

  final BlobFaceStyle style;
  final Color color;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth ?? max(2.4, size.shortestSide * 0.05)
      ..style = PaintingStyle.stroke;

    final eyePaint = Paint()..color = color;
    final eyeRadius = max(2.6, size.shortestSide * 0.06);
    final leftEye = Offset(size.width * 0.34, size.height * 0.36);
    final rightEye = Offset(size.width * 0.66, size.height * 0.36);

    if (style == BlobFaceStyle.sleepy) {
      canvas.drawLine(
        Offset(size.width * 0.28, size.height * 0.36),
        Offset(size.width * 0.40, size.height * 0.36),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.60, size.height * 0.36),
        Offset(size.width * 0.72, size.height * 0.36),
        paint,
      );
    } else if (style == BlobFaceStyle.excited) {
      canvas.drawLine(
        Offset(size.width * 0.26, size.height * 0.34),
        Offset(size.width * 0.38, size.height * 0.40),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.38, size.height * 0.34),
        Offset(size.width * 0.26, size.height * 0.40),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.62, size.height * 0.34),
        Offset(size.width * 0.74, size.height * 0.40),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.74, size.height * 0.34),
        Offset(size.width * 0.62, size.height * 0.40),
        paint,
      );
    } else {
      canvas.drawCircle(leftEye, eyeRadius, eyePaint);
      canvas.drawCircle(rightEye, eyeRadius, eyePaint);

      if (style == BlobFaceStyle.crying) {
        final tearPaint = Paint()
          ..color = color.withValues(alpha: 0.50)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = paint.strokeWidth * 0.72
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(leftEye.dx, leftEye.dy + eyeRadius * 1.4),
          Offset(leftEye.dx - eyeRadius * 0.4, leftEye.dy + eyeRadius * 3.2),
          tearPaint,
        );
      }
    }

    final mouth = Path();
    switch (style) {
      case BlobFaceStyle.smile:
        mouth.moveTo(size.width * 0.24, size.height * 0.62);
        mouth.quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.78,
          size.width * 0.76,
          size.height * 0.62,
        );
      case BlobFaceStyle.smallSmile:
        mouth.moveTo(size.width * 0.34, size.height * 0.64);
        mouth.quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.74,
          size.width * 0.66,
          size.height * 0.64,
        );
      case BlobFaceStyle.gentle:
        mouth.moveTo(size.width * 0.40, size.height * 0.62);
        mouth.quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.68,
          size.width * 0.60,
          size.height * 0.62,
        );
      case BlobFaceStyle.sleepy:
        mouth.moveTo(size.width * 0.32, size.height * 0.66);
        mouth.quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.76,
          size.width * 0.68,
          size.height * 0.66,
        );
      case BlobFaceStyle.excited:
        final mouthRect = Rect.fromCenter(
          center: Offset(size.width * 0.50, size.height * 0.70),
          width: size.width * 0.18,
          height: size.height * 0.18,
        );
        canvas.drawArc(mouthRect, 0, pi, false, paint);
        final blushPaint = Paint()..color = color.withValues(alpha: 0.55);
        for (var i = 0; i < 3; i++) {
          final dx = size.width * (0.16 + i * 0.05);
          canvas.drawLine(
            Offset(dx, size.height * 0.66),
            Offset(dx + size.width * 0.015, size.height * 0.76),
            blushPaint..strokeWidth = size.shortestSide * 0.028,
          );
        }
        for (var i = 0; i < 3; i++) {
          final dx = size.width * (0.79 + i * 0.05);
          canvas.drawLine(
            Offset(dx, size.height * 0.66),
            Offset(dx + size.width * 0.015, size.height * 0.76),
            blushPaint..strokeWidth = size.shortestSide * 0.028,
          );
        }
        canvas.drawPath(mouth, paint);
        return;
      case BlobFaceStyle.crying:
        mouth.moveTo(size.width * 0.30, size.height * 0.70);
        mouth.quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.58,
          size.width * 0.70,
          size.height * 0.70,
        );
    }

    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _DottedPaperPainter extends CustomPainter {
  const _DottedPaperPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.55);
    const gap = 24.0;
    for (double y = 18; y < size.height; y += gap) {
      for (double x = 18; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedPaperPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter({
    required this.progress,
    required this.particles,
  });

  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final phase = (progress + particle.speed) % 1.0;
      final dx = particle.x * size.width +
          sin((phase * pi * 2) + particle.x * 6) * particle.drift;
      final dy = ((particle.y + phase * particle.speed) % 1.0) * size.height;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: particle.opacity);
      final path = Path()
        ..moveTo(dx, dy - particle.radius * 2.2)
        ..lineTo(dx + particle.radius * 0.8, dy - particle.radius * 0.7)
        ..lineTo(dx + particle.radius * 2.2, dy)
        ..lineTo(dx + particle.radius * 0.8, dy + particle.radius * 0.7)
        ..lineTo(dx, dy + particle.radius * 2.2)
        ..lineTo(dx - particle.radius * 0.8, dy + particle.radius * 0.7)
        ..lineTo(dx - particle.radius * 2.2, dy)
        ..lineTo(dx - particle.radius * 0.8, dy - particle.radius * 0.7)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
