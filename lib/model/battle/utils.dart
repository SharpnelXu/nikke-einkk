class BattleUtils {
  BattleUtils._();

  static double toModifier(int ratio) {
    return ratio / 10000;
  }

  // for display
  static int frameToTimeData(int frame, int fps) {
    return (frame * 100 / fps).round();
  }

  // 230 = 2.3 seconds
  static int timeDataToFrame(int timeData, int fps) {
    return (timeData * fps / 100).round();
  }
}
