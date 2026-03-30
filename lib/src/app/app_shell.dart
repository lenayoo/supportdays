part of '../../main.dart';

class SupportDaysApp extends StatelessWidget {
  const SupportDaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromLocale(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
    final cuteTextTheme = cuteTextThemeForLanguage(language);

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

enum AppStep { entry, mood, loading, result, recordForm, monthly, recordDetail }

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
  static const _emotionRecordsKey = 'emotion_records';

  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();
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
      widthFactor: 0.4,
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
  Map<String, EmotionRecord> _emotionRecords = const {};
  EmotionRecord? _selectedRecord;
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
    final savedRecordString = prefs.getString(_emotionRecordsKey);
    final jsonString = await rootBundle.loadString(
      _assetPathForLanguage(language),
    );
    final decoded = json.decode(jsonString) as List<dynamic>;
    final messages = decoded
        .map((item) => SupportMessage.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    final emotionRecords = _decodeEmotionRecords(savedRecordString);

    if (!mounted) {
      return;
    }

    _nameController.text = savedName;
    setState(() {
      _language = language;
      _messages = messages;
      _userName = savedName;
      _emotionRecords = emotionRecords;
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

  Map<String, EmotionRecord> _decodeEmotionRecords(String? raw) {
    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = json.decode(raw);
    if (decoded is! List<dynamic>) {
      return {};
    }

    final records = <String, EmotionRecord>{};
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final record = EmotionRecord.fromJson(item);
      records[record.dateKey] = record;
    }
    return records;
  }

  Future<void> _persistEmotionRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final records =
        _emotionRecords.values.map((record) => record.toJson()).toList();
    await prefs.setString(_emotionRecordsKey, json.encode(records));
  }

  String _dateKey(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    switch (_language) {
      case AppLanguage.korean:
        return '${local.year}년 ${local.month}월 ${local.day}일';
      case AppLanguage.japanese:
        return '${local.year}年${local.month}月${local.day}日';
      case AppLanguage.english:
        return '${local.month}/${local.day}/${local.year}';
    }
  }

  void _openMonthly() {
    setState(() {
      _step = AppStep.monthly;
    });
  }

  Future<void> _showNameDialog({required bool canDismiss}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: canDismiss,
      builder: (dialogContext) {
        final isTablet = _isTabletLayout(dialogContext);

        return PopScope(
          canPop: canDismiss,
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 120 : 40,
              vertical: isTablet ? 48 : 24,
            ),
            backgroundColor: const Color(0xFFFFF8F0),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 42 : 28),
            ),
            title: Text(
              _strings.nameDialogTitle,
              style: cuteTextStyle(
                _language,
                color: const Color(0xFF3E4C44),
                fontWeight: FontWeight.w700,
                fontSize: isTablet ? 56 : 28,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _strings.nameDialogBody,
                  style: TextStyle(
                    color: const Color(0xFF647069),
                    height: 1.5,
                    fontSize: isTablet ? 28 : null,
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitNameFromDialog(dialogContext),
                  style: TextStyle(fontSize: isTablet ? 28 : null),
                  decoration: InputDecoration(
                    hintText: _strings.nameHint,
                    hintStyle: TextStyle(fontSize: isTablet ? 28 : null),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 28 : 18,
                      vertical: isTablet ? 24 : 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 26 : 18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actionsPadding: EdgeInsets.fromLTRB(
              isTablet ? 36 : 24,
              0,
              isTablet ? 36 : 24,
              isTablet ? 28 : 20,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _submitNameFromDialog(dialogContext),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB07C),
                    foregroundColor: const Color(0xFF3C322F),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 26 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 26 : 18),
                    ),
                  ),
                  child: Text(
                    _strings.startButton,
                    style: TextStyle(fontSize: isTablet ? 28 : null),
                  ),
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
      _reasonController.clear();
      _step = AppStep.mood;
    });
  }

  void _openRecordForm() {
    _reasonController.clear();
    setState(() {
      _step = AppStep.recordForm;
    });
  }

  Future<void> _saveEmotionRecord() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_strings.saveRecordValidation)),
      );
      return;
    }

    final today = DateTime.now();
    final record = EmotionRecord(
      dateKey: _dateKey(today),
      reason: reason,
      moodKey: _selectedMood!.key,
      messageTitle: _selectedMessage!.title,
      moodColorValue: _selectedMood!.shapeColor.toARGB32(),
    );

    setState(() {
      _emotionRecords = {..._emotionRecords, record.dateKey: record};
      _selectedRecord = record;
      _step = AppStep.monthly;
    });

    await _persistEmotionRecords();
  }

  void _openRecordDetail(EmotionRecord record) {
    setState(() {
      _selectedRecord = record;
      _step = AppStep.recordDetail;
    });
  }

  void _returnToResult() {
    setState(() {
      _step = AppStep.result;
    });
  }

  void _returnToRecords() {
    setState(() {
      _step = AppStep.monthly;
    });
  }

  void _returnHome() {
    setState(() {
      _selectedMessage = null;
      _selectedMood = null;
      _selectedRecord = null;
      _reasonController.clear();
      _step = AppStep.mood;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundDecoration =
        switch (_step) {
          AppStep.mood => const BoxDecoration(color: Color(0xFFFFF5E6)),
          AppStep.recordForm ||
          AppStep.monthly ||
          AppStep.recordDetail => const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4FBFF), Color(0xFFE7F6FF), Color(0xFFDCEFFF)],
            ),
          ),
          _ => const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8E8),
                Color(0xFFFFF1DC),
                Color(0xFFF8E9D7),
              ],
            ),
          ),
        };

    return Scaffold(
      backgroundColor:
          switch (_step) {
            AppStep.mood => const Color(0xFFFFF5E6),
            AppStep.recordForm ||
            AppStep.monthly ||
            AppStep.recordDetail => const Color(0xFFE7F6FF),
            _ => null,
          },
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: backgroundDecoration),
          ),
          const Positioned.fill(
            child: IgnorePointer(child: _ParticleBackground()),
          ),
          SafeArea(
            child:
                _isInitializing
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 650),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _buildStepContent(),
                    ),
          ),
        ],
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
          onViewRecords: _openMonthly,
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
          onRecord: _openRecordForm,
        );
      case AppStep.recordForm:
        return _RecordFormStep(
          key: const ValueKey('record-form-step'),
          strings: _strings,
          dateLabel: _formatDate(DateTime.now()),
          mood: _selectedMood!,
          message: _selectedMessage!,
          reasonController: _reasonController,
          onSave: _saveEmotionRecord,
          onBack: _returnToResult,
        );
      case AppStep.monthly:
        return _MonthlyRecordsStep(
          key: const ValueKey('monthly-step'),
          strings: _strings,
          records: _emotionRecords,
          initiallySelectedDateKey: _selectedRecord?.dateKey,
          onOpenRecord: _openRecordDetail,
          onBackHome: _returnHome,
        );
      case AppStep.recordDetail:
        return _RecordDetailStep(
          key: const ValueKey('record-detail-step'),
          strings: _strings,
          dateLabel: _formatDate(
            DateTime.parse('${_selectedRecord!.dateKey}T00:00:00'),
          ),
          record: _selectedRecord!,
          onBackHome: _returnHome,
          onBackToRecords: _returnToRecords,
        );
    }
  }
}
