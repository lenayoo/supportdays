import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SupportDaysApp());
}

class SupportDaysApp extends StatelessWidget {
  const SupportDaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Support Days',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.notoSerifKrTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF4B0A8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8EA),
      ),
      home: const SupportHomePage(),
    );
  }
}

enum AppStep { entry, mood, loading, result }

enum AppLanguage {
  korean,
  japanese,
  english;

  static AppLanguage fromLocale(ui.Locale locale) {
    switch (locale.languageCode.toLowerCase()) {
      case 'ko':
        return AppLanguage.korean;
      case 'ja':
        return AppLanguage.japanese;
      default:
        return AppLanguage.english;
    }
  }
}

class SupportHomePage extends StatefulWidget {
  const SupportHomePage({super.key});

  @override
  State<SupportHomePage> createState() => _SupportHomePageState();
}

class _SupportHomePageState extends State<SupportHomePage> {
  static const _userNameKey = 'user_name';

  final _nameController = TextEditingController();
  final _random = Random();

  final List<MoodOption> _moods = const [
    MoodOption(
      key: 'tired',
      labelColor: Color(0xFF4B4A47),
      shapeColor: Color(0xFFFFD38C),
      widthFactor: 0.29,
      heightFactor: 0.24,
      initialCenter: Offset(0.23, 0.22),
      initialVelocity: Offset(15, 12),
      cornerA: 0.58,
      cornerB: 0.40,
      cornerC: 0.46,
      cornerD: 0.62,
      face: BlobFaceStyle.smile,
    ),
    MoodOption(
      key: 'love',
      labelColor: Color(0xFF48403E),
      shapeColor: Color(0xFFF3AEC8),
      widthFactor: 0.30,
      heightFactor: 0.25,
      initialCenter: Offset(0.71, 0.18),
      initialVelocity: Offset(-16, 10),
      cornerA: 0.47,
      cornerB: 0.62,
      cornerC: 0.34,
      cornerD: 0.58,
      face: BlobFaceStyle.gentle,
    ),
    MoodOption(
      key: 'healing',
      labelColor: Color(0xFF4D4B48),
      shapeColor: Color(0xFFFFA48E),
      widthFactor: 0.20,
      heightFactor: 0.16,
      initialCenter: Offset(0.12, 0.47),
      initialVelocity: Offset(13, -14),
      cornerA: 0.55,
      cornerB: 0.48,
      cornerC: 0.62,
      cornerD: 0.36,
      face: BlobFaceStyle.smallSmile,
    ),
    MoodOption(
      key: 'gratitude',
      labelColor: Color(0xFF4B4B49),
      shapeColor: Color(0xFFA9BDE8),
      widthFactor: 0.34,
      heightFactor: 0.29,
      initialCenter: Offset(0.50, 0.46),
      initialVelocity: Offset(9, 17),
      cornerA: 0.35,
      cornerB: 0.40,
      cornerC: 0.59,
      cornerD: 0.52,
      face: BlobFaceStyle.smile,
    ),
    MoodOption(
      key: 'motivation',
      labelColor: Color(0xFF4A4945),
      shapeColor: Color(0xFFFF9F58),
      widthFactor: 0.31,
      heightFactor: 0.22,
      initialCenter: Offset(0.24, 0.80),
      initialVelocity: Offset(16, -9),
      cornerA: 0.56,
      cornerB: 0.32,
      cornerC: 0.60,
      cornerD: 0.44,
      face: BlobFaceStyle.excited,
    ),
    MoodOption(
      key: 'growth',
      labelColor: Color(0xFF4C4A49),
      shapeColor: Color(0xFF8F6CCD),
      widthFactor: 0.28,
      heightFactor: 0.25,
      initialCenter: Offset(0.76, 0.76),
      initialVelocity: Offset(-12, -11),
      cornerA: 0.42,
      cornerB: 0.62,
      cornerC: 0.48,
      cornerD: 0.32,
      face: BlobFaceStyle.smallSmile,
    ),
    MoodOption(
      key: 'confused',
      labelColor: Color(0xFF474849),
      shapeColor: Color(0xFFC7D4F3),
      widthFactor: 0.25,
      heightFactor: 0.20,
      initialCenter: Offset(0.82, 0.44),
      initialVelocity: Offset(-10, 15),
      cornerA: 0.38,
      cornerB: 0.58,
      cornerC: 0.54,
      cornerD: 0.46,
      face: BlobFaceStyle.gentle,
    ),
    MoodOption(
      key: 'lonely',
      labelColor: Color(0xFF484347),
      shapeColor: Color(0xFFD8B9E6),
      widthFactor: 0.20,
      heightFactor: 0.17,
      initialCenter: Offset(0.50, 0.72),
      initialVelocity: Offset(11, -13),
      cornerA: 0.50,
      cornerB: 0.34,
      cornerC: 0.58,
      cornerD: 0.54,
      face: BlobFaceStyle.sleepy,
    ),
  ];

  AppStep _step = AppStep.entry;
  AppLanguage _language = AppLanguage.english;
  List<SupportMessage> _messages = const [];
  SupportMessage? _selectedMessage;
  MoodOption? _selectedMood;
  String _userName = '';
  bool _isInitializing = true;
  bool _namePromptHandled = false;

  AppStrings get _strings => AppStrings(_language);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final language = AppLanguage.fromLocale(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_userNameKey)?.trim() ?? '';
    final jsonString = await rootBundle.loadString(_assetPathForLanguage(language));
    final decoded = json.decode(jsonString) as List<dynamic>;
    final messages = decoded
        .map((item) => SupportMessage.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    if (!mounted) {
      return;
    }

    _nameController.text = savedName;
    setState(() {
      _language = language;
      _messages = messages;
      _userName = savedName;
      _isInitializing = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureNameIfNeeded();
    });
  }

  String _assetPathForLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.korean:
        return 'assets/support_msg.json';
      case AppLanguage.japanese:
        return 'assets/support_msg_ja.json';
      case AppLanguage.english:
        return 'assets/support_msg_en.json';
    }
  }

  Future<void> _ensureNameIfNeeded() async {
    if (!mounted || _namePromptHandled || _userName.isNotEmpty) {
      return;
    }

    _namePromptHandled = true;
    await _showNameDialog(canDismiss: false);
  }

  Future<void> _showNameDialog({required bool canDismiss}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: canDismiss,
      builder: (dialogContext) {
        return PopScope(
          canPop: canDismiss,
          child: AlertDialog(
            backgroundColor: const Color(0xFFFFF8F0),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: Text(
              _strings.nameDialogTitle,
              style: GoogleFonts.gaegu(
                color: const Color(0xFF3E4C44),
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _strings.nameDialogBody,
                  style: const TextStyle(
                    color: Color(0xFF647069),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitNameFromDialog(dialogContext),
                  decoration: InputDecoration(
                    hintText: _strings.nameHint,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _submitNameFromDialog(dialogContext),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB07C),
                    foregroundColor: const Color(0xFF3C322F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(_strings.startButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editName() async {
    _nameController.text = _userName;
    _nameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _nameController.text.length,
    );
    await _showNameDialog(canDismiss: true);
  }

  Future<void> _submitNameFromDialog(BuildContext dialogContext) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    FocusScope.of(dialogContext).unfocus();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);

    if (!mounted) {
      return;
    }

    setState(() {
      _userName = name;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _enterMain() {
    setState(() {
      _step = AppStep.mood;
    });
  }

  Future<void> _pickMood(MoodOption mood) async {
    final candidates =
        _messages.where((message) => message.moods.contains(mood.key)).toList();
    if (candidates.isEmpty) {
      return;
    }

    setState(() {
      _selectedMood = mood;
      _step = AppStep.loading;
    });

    await Future<void>.delayed(const Duration(seconds: 3));

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedMessage = candidates[_random.nextInt(candidates.length)];
      _step = AppStep.result;
    });
  }

  void _chooseAgain() {
    setState(() {
      _selectedMessage = null;
      _selectedMood = null;
      _step = AppStep.mood;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundDecoration = _step == AppStep.mood
        ? const BoxDecoration(color: Color(0xFFFFF5E6))
        : const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8E8),
                Color(0xFFFFF1DC),
                Color(0xFFF8E9D7),
              ],
            ),
          );

    return Scaffold(
      backgroundColor:
          _step == AppStep.mood ? const Color(0xFFFFF5E6) : null,
      body: DecoratedBox(
        decoration: backgroundDecoration,
        child: SafeArea(
          child: _isInitializing
              ? const Center(child: CircularProgressIndicator())
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 650),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _buildStepContent(),
                ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case AppStep.entry:
        return _EntryStep(
          key: const ValueKey('entry-step'),
          strings: _strings,
          name: _userName,
          onStart: _enterMain,
          onEditName: _editName,
        );
      case AppStep.mood:
        return _MoodStep(
          key: const ValueKey('mood-step'),
          strings: _strings,
          name: _userName,
          moods: _moods,
          onSelect: _pickMood,
        );
      case AppStep.loading:
        return _LoadingStep(
          key: const ValueKey('loading-step'),
          strings: _strings,
          name: _userName,
          mood: _selectedMood!,
        );
      case AppStep.result:
        return _ResultStep(
          key: const ValueKey('result-step'),
          strings: _strings,
          name: _userName,
          mood: _selectedMood!,
          message: _selectedMessage!,
          onChooseAgain: _chooseAgain,
        );
    }
  }
}

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
        final t = _controller.value * pi * 2;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

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
                  left: -width * 0.08 + sin(t) * 12,
                  top: height * 0.02 + cos(t * 0.8) * 10,
                  width: width * 0.54,
                  height: height * 0.34,
                  color: const Color(0xFFFFD38C),
                  face: BlobFaceStyle.smile,
                ),
                _EntryBlob(
                  left: width * 0.46 + cos(t * 0.7) * 10,
                  top: -height * 0.01 + sin(t * 0.9) * 12,
                  width: width * 0.54,
                  height: height * 0.32,
                  color: const Color(0xFFF3AEC8),
                  face: BlobFaceStyle.gentle,
                ),
                _EntryBlob(
                  left: width * 0.20 + sin(t * 1.1) * 8,
                  top: height * 0.22 + cos(t * 0.6) * 14,
                  width: width * 0.48,
                  height: height * 0.30,
                  color: const Color(0xFFA9BDE8),
                  face: BlobFaceStyle.sleepy,
                ),
                _EntryBlob(
                  left: -width * 0.10 + cos(t * 0.85) * 11,
                  top: height * 0.33 + sin(t * 0.7) * 10,
                  width: width * 0.34,
                  height: height * 0.20,
                  color: const Color(0xFFFFA48E),
                  face: BlobFaceStyle.smallSmile,
                ),
                _EntryBlob(
                  left: -width * 0.03 + sin(t * 0.75) * 10,
                  top: height * 0.72 + cos(t * 0.95) * 12,
                  width: width * 0.52,
                  height: height * 0.24,
                  color: const Color(0xFFFF9F58),
                  face: BlobFaceStyle.excited,
                ),
                _EntryBlob(
                  left: width * 0.48 + cos(t * 0.8) * 10,
                  top: height * 0.60 + sin(t * 0.92) * 14,
                  width: width * 0.48,
                  height: height * 0.30,
                  color: const Color(0xFF8F6CCD),
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
                            text: widget.name.isEmpty
                                ? widget.strings.entryHeader
                                : widget.strings.entryHeaderWithName(widget.name),
                            onTap: widget.onEditName,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.strings.entryHeadline,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.gaegu(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1A18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: widget.onStart,
                          borderRadius: BorderRadius.circular(999),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.72),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFF3B3431),
                                width: 1.3,
                              ),
                            ),
                            child: Text(
                              widget.strings.entryButton,
                              style: GoogleFonts.gaegu(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2C2421),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
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
                      style: GoogleFonts.gaegu(
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
  )..repeat(
      min: 0,
      max: 1,
      period: const Duration(seconds: 1),
    );

  final Random _random = Random();
  final List<_BlobState> _blobs = [];

  Size _size = Size.zero;
  Duration? _lastElapsed;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_tick);
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
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
    var dt = (elapsed - lastElapsed).inMicroseconds / Duration.microsecondsPerSecond;
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
        final minDistance = a.collisionRadiusFor(_size) + b.collisionRadiusFor(_size);
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
        final sizeDelta = Offset(
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
    required this.label,
    required this.onTap,
  });

  final _BlobState blob;
  final Size size;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = blob.widthFor(size);
    final height = blob.heightFor(size);
    final t = DateTime.now().millisecondsSinceEpoch / 1000;
    final wobble = sin(t * 0.8 + blob.wobbleSeed) * 6;
    final tilt = sin(t * 0.55 + blob.tiltSeed) * 0.05;

    return Positioned(
      left: blob.center.dx - width / 2 + wobble,
      top: blob.center.dy - height / 2 + cos(t * 0.7 + blob.wobbleSeed) * 5,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: tilt,
          child: CustomPaint(
            painter: _BlobPainter(
              color: blob.mood.shapeColor,
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
                      style: GoogleFonts.gaegu(
                        fontSize: min(width, height) * 0.15,
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
            style: GoogleFonts.gaegu(
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
    final theme = Theme.of(context);

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
                      Text(
                        name.isEmpty
                            ? strings.resultTitle
                            : strings.resultTitleWithName(name),
                        style: GoogleFonts.gaegu(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2F2A27),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCF6).withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.56),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 28,
                              offset: Offset(0, 14),
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
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      color: const Color(0xFF2D312F),
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    message.flowReading,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFF45413E),
                                          fontWeight: FontWeight.w600,
                                          height: 1.45,
                                        ),
                                  ),
                                  const SizedBox(height: 24),
                                  _InfoSection(
                                    title: strings.actionTipLabel,
                                    text: message.actionTip,
                                  ),
                                  const SizedBox(height: 16),
                                  _InfoSection(
                                    title: strings.summaryLabel,
                                    text: message.summary,
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
    required this.face,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final BlobFaceStyle face;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: CustomPaint(
        painter: _BlobPainter(
          color: color,
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
              color: const Color(0xFF2F2927),
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
                style: GoogleFonts.gaegu(
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
          style: theme.textTheme.labelLarge?.copyWith(
            color: const Color(0xFF7A897F),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF5B6962),
            height: 1.5,
            fontWeight: FontWeight.w500,
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

class MoodOption {
  const MoodOption({
    required this.key,
    required this.labelColor,
    required this.shapeColor,
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

enum BlobFaceStyle { smile, smallSmile, gentle, sleepy, excited }

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

  double widthFor(Size size) => size.width * mood.widthFactor;

  double heightFor(Size size) => size.height * mood.heightFactor;

  double collisionRadiusFor(Size size) {
    return max(widthFor(size), heightFor(size)) * 0.34;
  }
}

class _BlobPainter extends CustomPainter {
  const _BlobPainter({
    required this.color,
    required this.cornerA,
    required this.cornerB,
    required this.cornerC,
    required this.cornerD,
  });

  final Color color;
  final double cornerA;
  final double cornerB;
  final double cornerC;
  final double cornerD;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
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

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.color != color ||
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
  });

  final BlobFaceStyle style;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = max(2.4, size.shortestSide * 0.05)
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
    }

    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) {
    return oldDelegate.style != style || oldDelegate.color != color;
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

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  String get nameDialogTitle {
    switch (language) {
      case AppLanguage.korean:
        return '이름이 뭐야?';
      case AppLanguage.japanese:
        return '名前は？';
      case AppLanguage.english:
        return 'What is your name?';
    }
  }

  String get nameDialogBody {
    switch (language) {
      case AppLanguage.korean:
        return '한 번만 알려주면 로컬 기기에 저장해둘게.';
      case AppLanguage.japanese:
        return '一度だけ教えてくれたら、この端末に保存しておくね。';
      case AppLanguage.english:
        return 'Tell me once and I will save it on this device.';
    }
  }

  String get nameHint {
    switch (language) {
      case AppLanguage.korean:
        return '여기에 이름을 적어줘';
      case AppLanguage.japanese:
        return 'ここに名前を書いてね';
      case AppLanguage.english:
        return 'Type your name here';
    }
  }

  String get startButton {
    switch (language) {
      case AppLanguage.korean:
        return '시작하기';
      case AppLanguage.japanese:
        return 'はじめる';
      case AppLanguage.english:
        return 'Start';
    }
  }

  String get entryHeadline {
    switch (language) {
      case AppLanguage.korean:
        return '너의 오늘을 응원해';
      case AppLanguage.japanese:
        return '今日のあなたを応援するよ';
      case AppLanguage.english:
        return 'Cheering for your today';
    }
  }

  String get entryButton {
    switch (language) {
      case AppLanguage.korean:
        return '너의 오늘을 응원해';
      case AppLanguage.japanese:
        return '今日のあなたを応援して';
      case AppLanguage.english:
        return 'Cheer My Day';
    }
  }

  String get entryHeader {
    switch (language) {
      case AppLanguage.korean:
        return 'entry display';
      case AppLanguage.japanese:
        return 'entry display';
      case AppLanguage.english:
        return 'entry display';
    }
  }

  String entryHeaderWithName(String name) {
    switch (language) {
      case AppLanguage.korean:
        return '$name의 display';
      case AppLanguage.japanese:
        return '$name の display';
      case AppLanguage.english:
        return '$name display';
    }
  }

  String get moodPrompt {
    switch (language) {
      case AppLanguage.korean:
        return '지금 마음에 닿는 감정을 골라줘';
      case AppLanguage.japanese:
        return '今の気持ちに近いものを選んで';
      case AppLanguage.english:
        return 'Pick the feeling that fits right now';
    }
  }

  String moodPromptWithName(String name) {
    switch (language) {
      case AppLanguage.korean:
        return '$name, 지금 마음에 닿는 감정을 골라줘';
      case AppLanguage.japanese:
        return '$name、今の気持ちに近いものを選んで';
      case AppLanguage.english:
        return '$name, pick the feeling that fits right now';
    }
  }

  String get moodDescription {
    switch (language) {
      case AppLanguage.korean:
        return '도형을 톡 누르면 그 감정에 맞는 오늘의 문장을 골라서 보여줄게.';
      case AppLanguage.japanese:
        return '形をタップすると、その気分に合う今日のメッセージを選んで届けるよ。';
      case AppLanguage.english:
        return 'Tap a floating shape and I will pick a message that matches it.';
    }
  }

  String get loadingTitle {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 조언을 고르고 있어';
      case AppLanguage.japanese:
        return '今日のメッセージを選んでいるよ';
      case AppLanguage.english:
        return 'Choosing today\'s message';
    }
  }

  String loadingTitleWithName(String name) {
    switch (language) {
      case AppLanguage.korean:
        return '$name의 오늘의 조언을 고르고 있어';
      case AppLanguage.japanese:
        return '$name の今日のメッセージを選んでいるよ';
      case AppLanguage.english:
        return 'Choosing today\'s message for $name';
    }
  }

  String loadingBody(String mood) {
    switch (language) {
      case AppLanguage.korean:
        return '$mood 감정에 맞는 문장을 천천히 건져 올리는 중이야.';
      case AppLanguage.japanese:
        return '$mood に合う言葉をゆっくりすくい上げているところ。';
      case AppLanguage.english:
        return 'Slowly lifting up a message that matches $mood.';
    }
  }

  String get resultTitle {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 조언이 도착했어';
      case AppLanguage.japanese:
        return '今日のメッセージが届いたよ';
      case AppLanguage.english:
        return 'Your message for today';
    }
  }

  String resultTitleWithName(String name) {
    switch (language) {
      case AppLanguage.korean:
        return '$name, 오늘의 조언이 도착했어';
      case AppLanguage.japanese:
        return '$name への今日のメッセージが届いたよ';
      case AppLanguage.english:
        return '$name, your message for today';
    }
  }

  String get chooseAgainButton {
    switch (language) {
      case AppLanguage.korean:
        return '다시 고르기';
      case AppLanguage.japanese:
        return 'もう一度選ぶ';
      case AppLanguage.english:
        return 'Choose again';
    }
  }

  String get actionTipLabel {
    switch (language) {
      case AppLanguage.korean:
        return '실천 팁';
      case AppLanguage.japanese:
        return '行動のヒント';
      case AppLanguage.english:
        return 'Action Tip';
    }
  }

  String get summaryLabel {
    switch (language) {
      case AppLanguage.korean:
        return '한 줄 요약';
      case AppLanguage.japanese:
        return 'ひとこと要約';
      case AppLanguage.english:
        return 'Summary';
    }
  }

  String moodLabel(String key) {
    switch (key) {
      case 'tired':
        return 'Tired';
      case 'love':
        return 'Love';
      case 'healing':
        return 'Support';
      case 'gratitude':
        return 'Like';
      case 'motivation':
        return 'Inspiration';
      case 'growth':
        return 'Growth';
      case 'confused':
        return 'Confused';
      case 'lonely':
        return 'Lonely';
      default:
        return key;
    }
  }
}
