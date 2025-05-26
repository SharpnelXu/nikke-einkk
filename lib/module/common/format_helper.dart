String coreString(int coreLevel) {
  if (coreLevel < 1 || coreLevel > 11) return '$coreLevel';
  final gradeLevel = coreLevel > 4 ? 4 : coreLevel;
  String result = '';
  for (int count = 1; count < gradeLevel; count += 1) {
    result += '★';
  }
  for (int count = 3; count >= gradeLevel; count -= 1) {
    result += '☆';
  }

  if (coreLevel == 11) {
    result += ' MAX';
  } else if (coreLevel > 4) {
    result += ' C${coreLevel - 4}';
  }

  return result;
}
