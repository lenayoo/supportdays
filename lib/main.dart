import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7FA98F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
      ),
      home: const SupportHomePage(),
    );
  }
}

enum AppStep {
  mood,
  loading,
  result,
}

class SupportHomePage extends StatefulWidget {
  const SupportHomePage({super.key});

  @override
  State<SupportHomePage> createState() => _SupportHomePageState();
}

class _SupportHomePageState extends State<SupportHomePage> {
  static const _userNameKey = 'user_name';
  static const _resultBackgrounds = [
    'assets/imgs/support_1.webp',
    'assets/imgs/support_2.webp',
    'assets/imgs/support_3.webp',
  ];

  final _nameController = TextEditingController();
  final _random = Random();

  final List<MoodOption> _moods = const [
    MoodOption('tired', 'Tired', '지친 날', Color(0xFFD9C4A1), Icons.bedtime_rounded),
    MoodOption('love', 'Love', '사랑', Color(0xFFE6A6A1), Icons.favorite_rounded),
    MoodOption('growth', 'Growth', '성장', Color(0xFFA5C88F), Icons.spa_rounded),
    MoodOption('confused', 'Confused', '복잡함', Color(0xFF9DB6D9), Icons.blur_on_rounded),
    MoodOption('healing', 'Healing', '회복', Color(0xFF9FCBB7), Icons.air_rounded),
    MoodOption('motivation', 'Motivation', '동기', Color(0xFFF0B26E), Icons.wb_sunny_rounded),
    MoodOption('lonely', 'Lonely', '외로움', Color(0xFFB3A4C7), Icons.nights_stay_rounded),
    MoodOption('gratitude', 'Gratitude', '감사', Color(0xFFF3CE76), Icons.auto_awesome_rounded),
  ];

  AppStep _step = AppStep.mood;
  List<SupportMessage> _messages = const [];
  SupportMessage? _selectedMessage;
  MoodOption? _selectedMood;
  String _userName = '';
  String? _selectedBackground;
  bool _isInitializing = true;
  bool _namePromptHandled = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_userNameKey)?.trim() ?? '';
    final jsonString = await rootBundle.loadString('assets/support_msg.json');
    final decoded = json.decode(jsonString) as List<dynamic>;
    final messages = decoded
        .map((item) => SupportMessage.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    if (!mounted) {
      return;
    }

    _nameController.text = savedName;
    setState(() {
      _messages = messages;
      _userName = savedName;
      _isInitializing = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureNameIfNeeded();
    });
  }

  Future<void> _ensureNameIfNeeded() async {
    if (!mounted || _namePromptHandled || _userName.isNotEmpty) {
      return;
    }

    _namePromptHandled = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: const Color(0xFFF9F5EE),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Text(
            '이름이 뭐야?',
            style: TextStyle(
              color: Color(0xFF3E4C44),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '한 번만 알려주면 로컬 기기에 저장해둘게.',
                style: TextStyle(
                  color: Color(0xFF647069),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitNameFromDialog(context),
                decoration: InputDecoration(
                  hintText: '여기에 이름을 적어줘',
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
                onPressed: () => _submitNameFromDialog(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6F8F78),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('시작하기'),
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> _pickMood(MoodOption mood) async {
    final candidates =
        _messages.where((message) => message.moods.contains(mood.key)).toList();
    if (candidates.isEmpty) {
      return;
    }

    setState(() {
      _selectedMood = mood;
      _selectedBackground =
          _resultBackgrounds[_random.nextInt(_resultBackgrounds.length)];
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
      _selectedBackground = null;
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F1E7),
              Color(0xFFECE4D5),
              Color(0xFFDDE7DF),
            ],
          ),
        ),
        child: SafeArea(
          child: _isInitializing
              ? const Center(child: CircularProgressIndicator())
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
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
      case AppStep.mood:
        return _MoodStep(
          key: const ValueKey('mood-step'),
          name: _userName,
          moods: _moods,
          onSelect: _pickMood,
        );
      case AppStep.loading:
        return _LoadingStep(
          key: const ValueKey('loading-step'),
          name: _userName,
          mood: _selectedMood!,
        );
      case AppStep.result:
        return _ResultStep(
          key: const ValueKey('result-step'),
          name: _userName,
          mood: _selectedMood!,
          message: _selectedMessage!,
          backgroundAsset: _selectedBackground!,
          onChooseAgain: _chooseAgain,
        );
    }
  }
}

class _MoodStep extends StatelessWidget {
  const _MoodStep({
    super.key,
    required this.name,
    required this.moods,
    required this.onSelect,
  });

  final String name;
  final List<MoodOption> moods;
  final ValueChanged<MoodOption> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline = name.isEmpty ? '오늘의 기분을 골라줘' : '$name, 오늘의 기분을 골라줘';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopCloudRow(),
          const SizedBox(height: 24),
          Text(
            headline,
            style: theme.textTheme.displaySmall?.copyWith(
              color: const Color(0xFF3E4C44),
              fontWeight: FontWeight.w700,
              height: 1.16,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '지금 가장 가까운 감정 하나를 눌러줘. 그 기분에 맞는 조언을 랜덤으로 골라서 보여줄게.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF61716A),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: moods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, index) {
              final mood = moods[index];
              return _MoodCard(
                mood: mood,
                onTap: () => onSelect(mood),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LoadingStep extends StatefulWidget {
  const _LoadingStep({
    super.key,
    required this.name,
    required this.mood,
  });

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
            height: 240,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value * pi * 2;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _MovingCloud(
                      left: 40 + sin(t) * 46,
                      top: 30 + cos(t * 0.9) * 18,
                      width: 130,
                      color: const Color(0xFFFFFFFF),
                    ),
                    _MovingCloud(
                      left: 160 + sin(t + 1.8) * 52,
                      top: 120 + cos(t * 1.1 + 0.8) * 20,
                      width: 104,
                      color: const Color(0xFFF2F6FB),
                    ),
                    _MovingCloud(
                      left: 95 + sin(t + 3.1) * 58,
                      top: 72 + cos(t + 0.2) * 28,
                      width: 150,
                      color: const Color(0xFFEEF4F0),
                    ),
                    Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        color: widget.mood.color.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.mood.icon,
                        size: 42,
                        color: const Color(0xFF4F645A),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '${widget.name.isEmpty ? '오늘의' : '${widget.name}의'} 조언을 알아보고 있어요',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF3F4D45),
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.mood.label}에 맞는 문장을 구름 사이에서 천천히 고르는 중이에요.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64736B),
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
    required this.name,
    required this.mood,
    required this.message,
    required this.backgroundAsset,
    required this.onChooseAgain,
  });

  final String name;
  final MoodOption mood;
  final SupportMessage message;
  final String backgroundAsset;
  final VoidCallback onChooseAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundAsset),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color(0xFF1E261F).withValues(alpha: 0.30),
            ),
          ),
        ),
        const Positioned.fill(
          child: _ParticleBackground(),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  const Color(0xFFF3EEE5).withValues(alpha: 0.18),
                  const Color(0xFFF3EEE5).withValues(alpha: 0.50),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name.isEmpty ? '오늘의 조언이에요' : '$name, 오늘의 조언이에요',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onChooseAgain,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('다시 고르기'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F4EC).withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.40),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 32,
                        offset: Offset(0, 18),
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
                                color: const Color(0xFF314038),
                                fontWeight: FontWeight.w800,
                                height: 1.18,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              message.flowReading,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF3D4B44),
                                fontWeight: FontWeight.w700,
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _InfoSection(
                              title: 'Action Tip',
                              text: message.actionTip,
                            ),
                            const SizedBox(height: 16),
                            _InfoSection(
                              title: 'Summary',
                              text: message.summary,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: _MoodTag(mood: mood),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    18,
    (index) => _Particle(
      x: (index * 0.13 + 0.07) % 1,
      y: (index * 0.19 + 0.11) % 1,
      radius: 1.6 + (index % 4) * 0.75,
      drift: 12 + (index % 5) * 5,
      speed: 0.15 + (index % 6) * 0.05,
      opacity: 0.10 + (index % 4) * 0.04,
      type: ParticleType.values[index % ParticleType.values.length],
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
          ),
        ),
      ],
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.mood,
    required this.onTap,
  });

  final MoodOption mood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withValues(alpha: 0.78),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: mood.color.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    mood.icon,
                    color: const Color(0xFF476056),
                  ),
                ),
                const Spacer(),
                Text(
                  mood.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF3D4B44),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  mood.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6A776F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  const _MoodTag({
    required this.mood,
  });

  final MoodOption mood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mood.color.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(mood.icon, size: 18, color: const Color(0xFF4C6057)),
          const SizedBox(width: 8),
          Text(
            mood.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFF4C6057),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCloudRow extends StatelessWidget {
  const _TopCloudRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _CloudBadge(width: 72, color: Color(0xFFFFFFFF)),
        SizedBox(width: 10),
        _CloudBadge(width: 52, color: Color(0xFFF2F5FA)),
        Spacer(),
        _CloudBadge(width: 92, color: Color(0xFFEEF3EE)),
      ],
    );
  }
}

class _CloudBadge extends StatelessWidget {
  const _CloudBadge({
    required this.width,
    required this.color,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
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
        height: width * 0.42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(40),
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
  const MoodOption(
    this.key,
    this.label,
    this.subtitle,
    this.color,
    this.icon,
  );

  final String key;
  final String label;
  final String subtitle;
  final Color color;
  final IconData icon;
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

enum ParticleType {
  dot,
  star,
  snow,
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.drift,
    required this.speed,
    required this.opacity,
    required this.type,
  });

  final double x;
  final double y;
  final double radius;
  final double drift;
  final double speed;
  final double opacity;
  final ParticleType type;
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

      switch (particle.type) {
        case ParticleType.dot:
          canvas.drawCircle(Offset(dx, dy), particle.radius, paint);
        case ParticleType.star:
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
        case ParticleType.snow:
          final center = Offset(dx, dy);
          canvas.drawCircle(center, particle.radius * 0.8, paint);
          canvas.drawLine(
            Offset(dx - particle.radius * 2, dy),
            Offset(dx + particle.radius * 2, dy),
            paint..strokeWidth = 0.8,
          );
          canvas.drawLine(
            Offset(dx, dy - particle.radius * 2),
            Offset(dx, dy + particle.radius * 2),
            paint..strokeWidth = 0.8,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
