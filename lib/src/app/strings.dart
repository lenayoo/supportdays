part of supportdays_app;

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
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  switch (language) {
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
        return '今日のあなたを応援します';
      case AppLanguage.english:
        return 'Cheering for your today';
    }
  }

  String get entryButton {
    switch (language) {
      case AppLanguage.korean:
        return '너의 오늘을 응원해';
      case AppLanguage.japanese:
        return '今日のあなたに、エールを';
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
        return '$nameのdisplay';
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
    switch (language) {
      case AppLanguage.korean:
        return '$name의 오늘의 응원을 고르고 있어';
      case AppLanguage.japanese:
        return '$nameの今日の応援を選んでいるよ';
      case AppLanguage.english:
        return 'Choosing today\'s message for $name';
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
    switch (language) {
      case AppLanguage.korean:
        return '$name, 오늘의 응원이 도착했어';
      case AppLanguage.japanese:
        return '$nameへの今日の応援が届いたよ';
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
