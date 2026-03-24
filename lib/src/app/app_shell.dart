part of supportdays_app;

class SupportDaysApp extends StatelessWidget {
  const SupportDaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cuteTextTheme = GoogleFonts.gaeguTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Support Days',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: cuteTextTheme,
        fontFamilyFallback: [
          GoogleFonts.notoSansKr().fontFamily!,
          GoogleFonts.mPlusRounded1c().fontFamily!,
        ],
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
      shapeStyle: BlobShapeStyle.softPebble,
      widthFactor: 0.29,
      heightFactor: 0.24,
      initialCenter: Offset(0.23, 0.22),
      initialVelocity: Offset(15, 12),
      cornerA: 0.58,
      cornerB: 0.40,
      cornerC: 0.46,
      cornerD: 0.62,
      face: BlobFaceStyle.crying,
    ),
    MoodOption(
      key: 'love',
      labelColor: Color(0xFF48403E),
      shapeColor: Color(0xFFF3AEC8),
      shapeStyle: BlobShapeStyle.wideCloud,
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
      shapeStyle: BlobShapeStyle.bean,
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
      shapeStyle: BlobShapeStyle.tallDrop,
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
      shapeStyle: BlobShapeStyle.wonkyHeart,
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
      shapeStyle: BlobShapeStyle.leanPebble,
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
      shapeStyle: BlobShapeStyle.wideCloud,
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
      shapeStyle: BlobShapeStyle.bean,
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
