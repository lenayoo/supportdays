part of '../../main.dart';

TextTheme cuteTextThemeForLanguage(AppLanguage language) {
  switch (language) {
    case AppLanguage.japanese:
      return GoogleFonts.zenMaruGothicTextTheme();
    case AppLanguage.korean:
    case AppLanguage.english:
      return GoogleFonts.gaeguTextTheme();
  }
}

TextStyle cuteTextStyle(
  AppLanguage language, {
  String? text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  final resolvedLanguage = _fontLanguageForText(language, text);

  switch (resolvedLanguage) {
    case AppLanguage.japanese:
      return GoogleFonts.zenMaruGothic(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    case AppLanguage.korean:
    case AppLanguage.english:
      return GoogleFonts.gaegu(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
  }
}

AppLanguage _fontLanguageForText(AppLanguage language, String? text) {
  if (text == null || text.isEmpty) {
    return language;
  }

  final hasJapanese = RegExp(r'[\u3040-\u30FF\u4E00-\u9FFF]').hasMatch(text);
  if (hasJapanese) {
    return AppLanguage.japanese;
  }

  final hasHangul = RegExp(
    r'[\u1100-\u11FF\u3130-\u318F\uAC00-\uD7AF]',
  ).hasMatch(text);
  if (hasHangul) {
    return AppLanguage.korean;
  }

  switch (language) {
    case AppLanguage.japanese:
    case AppLanguage.korean:
    case AppLanguage.english:
      return AppLanguage.english;
  }
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  String _displayNameWithHeart(String name) {
    final trimmedName = name.trim();
    return trimmedName.isEmpty ? '🤍' : '$trimmedName♥️';
  }

  String get nameDialogTitle {
    switch (language) {
      case AppLanguage.korean:
        return '이름을 알려줘';
      case AppLanguage.japanese:
        return '名前を教えて';
      case AppLanguage.english:
        return 'Tell me your name';
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
        return '너의 오늘을 응원해!';
      case AppLanguage.japanese:
        return '今日のあなたを応援します!';
      case AppLanguage.english:
        return 'Cheering for your today!';
    }
  }

  String get entryButton {
    switch (language) {
      case AppLanguage.korean:
        return '너의 오늘을 응원해!';
      case AppLanguage.japanese:
        return '今日のあなたに、エールを!';
      case AppLanguage.english:
        return 'Cheer My Day!';
    }
  }

  String get entryHeader {
    switch (language) {
      case AppLanguage.korean:
        return 'name';
      case AppLanguage.japanese:
        return 'name';
      case AppLanguage.english:
        return 'name';
    }
  }

  String entryHeaderWithName(String name) {
    return _displayNameWithHeart(name);
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
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return moodPrompt;
    }

    switch (language) {
      case AppLanguage.korean:
        return '${_displayNameWithHeart(trimmedName)}, 지금 마음에 닿는 감정을 골라줘';
      case AppLanguage.japanese:
        return '${_displayNameWithHeart(trimmedName)}、今の気持ちに近いものを選んで';
      case AppLanguage.english:
        return '${_displayNameWithHeart(trimmedName)}, pick the feeling that fits right now';
    }
  }

  String get moodDescription {
    switch (language) {
      case AppLanguage.korean:
        return '도형을 톡 누르면 그 감정에 맞는 오늘의 응원을 골라서 보여줄게.';
      case AppLanguage.japanese:
        return '形をタップすると、その気分に合う今日の応援を選んで届けるよ。';
      case AppLanguage.english:
        return 'Tap a floating shape and I will pick a message that matches it.';
    }
  }

  String get loadingTitle {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 응원을 고르고 있어';
      case AppLanguage.japanese:
        return '今日の応援を選んでいるよ';
      case AppLanguage.english:
        return 'Choosing today\'s message';
    }
  }

  String loadingTitleWithName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return loadingTitle;
    }

    switch (language) {
      case AppLanguage.korean:
        return '${_displayNameWithHeart(trimmedName)}의 오늘의 응원을 고르고 있어';
      case AppLanguage.japanese:
        return '${_displayNameWithHeart(trimmedName)}の今日の応援を選んでいるよ';
      case AppLanguage.english:
        return 'Choosing today\'s message for ${_displayNameWithHeart(trimmedName)}';
    }
  }

  String loadingBody(String mood) {
    switch (language) {
      case AppLanguage.korean:
        return '$mood 감정에 맞는 응원을 천천히 건져 올리는 중이야.';
      case AppLanguage.japanese:
        return '$moodに合う応援をゆっくりすくい上げているところ。';
      case AppLanguage.english:
        return 'Slowly lifting up message that matches $mood.';
    }
  }

  String get resultTitle {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 응원이 도착했어';
      case AppLanguage.japanese:
        return '今日の応援が届いたよ';
      case AppLanguage.english:
        return 'Your message for today';
    }
  }

  String resultTitleWithName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return resultTitle;
    }

    switch (language) {
      case AppLanguage.korean:
        return '${_displayNameWithHeart(trimmedName)}, 오늘의 응원이 도착했어';
      case AppLanguage.japanese:
        return '${_displayNameWithHeart(trimmedName)}への今日の応援が届いたよ';
      case AppLanguage.english:
        return '${_displayNameWithHeart(trimmedName)}, your message for today';
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

  String get viewMyRecordsButton {
    switch (language) {
      case AppLanguage.korean:
        return '나의 기록보기';
      case AppLanguage.japanese:
        return '記録を見る';
      case AppLanguage.english:
        return 'View My Records';
    }
  }

  String get recordButton {
    switch (language) {
      case AppLanguage.korean:
        return '기록하기';
      case AppLanguage.japanese:
        return '記録する';
      case AppLanguage.english:
        return 'Save Record';
    }
  }

  String get emotionRecordTitle {
    switch (language) {
      case AppLanguage.korean:
        return '감정 기록';
      case AppLanguage.japanese:
        return '感情記録';
      case AppLanguage.english:
        return 'Emotion Record';
    }
  }

  String get todayDateLabel {
    switch (language) {
      case AppLanguage.korean:
        return '날짜';
      case AppLanguage.japanese:
        return '日付';
      case AppLanguage.english:
        return 'Date';
    }
  }

  String get reasonPrompt {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 감정을 고른 이유는?';
      case AppLanguage.japanese:
        return '今日の気持ちを選んだ理由は？';
      case AppLanguage.english:
        return 'Why did you choose this feeling today?';
    }
  }

  String get recordReasonLabel {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 기분';
      case AppLanguage.japanese:
        return '今日の気分';
      case AppLanguage.english:
        return 'Today\'s Note';
    }
  }

  String get reasonHint {
    switch (language) {
      case AppLanguage.korean:
        return '50자 이내로 적어줘';
      case AppLanguage.japanese:
        return '50文字以内で書いてね';
      case AppLanguage.english:
        return 'Write within 50 characters';
    }
  }

  String get adviceLabel {
    switch (language) {
      case AppLanguage.korean:
        return '조언';
      case AppLanguage.japanese:
        return 'メッセージ';
      case AppLanguage.english:
        return 'Advice';
    }
  }

  String get recordSavedTitle {
    switch (language) {
      case AppLanguage.korean:
        return '기록 상세';
      case AppLanguage.japanese:
        return '記録詳細';
      case AppLanguage.english:
        return 'Record Detail';
    }
  }

  String get selectedEmotionLabel {
    switch (language) {
      case AppLanguage.korean:
        return '오늘의 감정';
      case AppLanguage.japanese:
        return '今日の気持ち';
      case AppLanguage.english:
        return 'Today\'s Emotion';
    }
  }

  String get returnHomeButton {
    switch (language) {
      case AppLanguage.korean:
        return '홈으로 돌아가기';
      case AppLanguage.japanese:
        return 'ホームへ戻る';
      case AppLanguage.english:
        return 'Back To Home';
    }
  }

  String get returnToRecordsButton {
    switch (language) {
      case AppLanguage.korean:
        return '기록으로 돌아가기';
      case AppLanguage.japanese:
        return '記録へ戻る';
      case AppLanguage.english:
        return 'Back To Records';
    }
  }

  String get monthlyTitle {
    switch (language) {
      case AppLanguage.korean:
        return '월간 기록';
      case AppLanguage.japanese:
        return '月間記録';
      case AppLanguage.english:
        return 'Monthly Records';
    }
  }

  String get noRecordMessage {
    switch (language) {
      case AppLanguage.korean:
        return '아직 저장된 기록이 없어.';
      case AppLanguage.japanese:
        return 'まだ保存した記録がないよ。';
      case AppLanguage.english:
        return 'There are no saved records yet.';
    }
  }

  String get recordGuideMessage {
    switch (language) {
      case AppLanguage.korean:
        return '점이 있는 날짜를 누르면 기록을 볼 수 있어.';
      case AppLanguage.japanese:
        return '点のある日を押すと記録が見られるよ。';
      case AppLanguage.english:
        return 'Tap a date with a dot to open the record.';
    }
  }

  String get saveRecordValidation {
    switch (language) {
      case AppLanguage.korean:
        return '이유를 적어줘.';
      case AppLanguage.japanese:
        return '理由を書いてね。';
      case AppLanguage.english:
        return 'Please write the reason.';
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
