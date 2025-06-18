import 'package:nikke_einkk/model/db.dart';
import 'package:path/path.dart' as path;

const appPath = '.';
final localePath = path.join(appPath, 'data', 'Locale');
final userDataPath = path.join(appPath, 'userData');

String getStaticDataPath(bool global) {
  final server = global ? 'global' : 'cn';
  return path.join(appPath, 'data', server, 'StaticData.pack');
}

String getExtractDataFolderPath(bool global) {
  final server = global ? 'global' : 'cn';
  return path.join(appPath, 'data', server, 'extract');
}

String getDesignatedDirectory(String outputDir, String fileName) {
  for (final prefix in userDb.customizeDirectory.keys) {
    if (fileName.startsWith(prefix)) {
      return path.join(outputDir, userDb.customizeDirectory[prefix]!, fileName);
    }
  }
  return path.join(outputDir, fileName);
}
