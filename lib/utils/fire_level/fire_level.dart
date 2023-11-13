class FireLevel {
  static String convertLevelToGraphicPath({
    required int level,
    required String category,
  }) {
    String graphicPath = '';

    if (level <= 1) {
      graphicPath = 'asset/graphic/small.json';
    } else if (2 <= level && level <= 10) {
      graphicPath = 'asset/graphic/small2.json';
    } else if (11 <= level && level <= 25) {
      graphicPath = 'asset/graphic/medium.json';
    } else if (26 <= level && level <= 45) {
      graphicPath = 'asset/graphic/big.json';
    } else if (46 <= level) {
      graphicPath = convertCategoryToMaxLevelGraphicPath(
        category: category,
      );
    }

    return graphicPath;
  }

  static String convertCategoryToMaxLevelGraphicPath({
    required String category,
  }) {
    String graphicPath;

    switch (category) {
      case 'SPORTS':
        graphicPath = 'asset/graphic/big-exercise.json';
        break;
      case 'HABIT':
        graphicPath = 'asset/graphic/big-life.json';
        break;
      case 'TEST':
        graphicPath = 'asset/graphic/big-test.json';
        break;
      case 'STUDY':
        graphicPath = 'asset/graphic/big-study.json';
        break;
      case 'READING':
        graphicPath = 'asset/graphic/big-book.json';
        break;
      default:
        graphicPath = 'asset/graphic/big-etc.json';
        break;
    }

    return graphicPath;
  }

  static String convertLevelToName({
    required int level,
  }) {
    String name = '';

    if (level <= 1) {
      name = '태어난 불';
    } else if (2 <= level && level <= 10) {
      name = '작은 불';
    } else if (11 <= level && level <= 25) {
      name = '중간 불';
    } else if (26 <= level && level <= 45) {
      name = '큰 불';
    } else if (46 <= level) {
      name = '특수 불';
    }

    return name;
  }

  static String convertLevelToMessage({
    required int level,
    required String category,
  }) {
    String message = '';

    if (level <= 1) {
      message = '새로 태어났어요!';
    } else if (2 <= level && level <= 10) {
      message = '저 좀 커졌나요?';
    } else if (11 <= level && level <= 25) {
      message = '우리 모임 따뜻해요';
    } else if (26 <= level && level <= 45) {
      message = '최고에요! 활활!';
    } else if (46 <= level) {
      message = convertLevelToMaxLevelMessage(
        category: category,
      );
    }

    return message;
  }

  static String convertLevelToMaxLevelMessage({
    required String category,
  }) {
    String message = '';

    switch (category) {
      case 'SPORTS':
        message = '운동왕 모닥모닥불 모임이네요!';
        break;
      case 'HABIT':
        message = '생활왕 모닥모닥불 모임이네요!';
        break;
      case 'TEST':
        message = '시험왕 모닥모닥불 모임이네요!';
        break;
      case 'STUDY':
        message = '공부왕 모닥모닥불 모임이네요!';
        break;
      case 'READING':
        message = '다독왕 모닥모닥불 모임이네요!';
        break;
      default:
        message = '목표왕 모닥모닥불 모임이네요!';
        break;
    }

    return message;
  }
}
