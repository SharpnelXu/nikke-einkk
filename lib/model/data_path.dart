import 'package:path/path.dart' as path;

const appPath = '.';
final localePath = path.join(appPath, 'Locale');

String getStaticDataPath(bool global) {
  final server = global ? 'global' : 'cn';
  return path.join(appPath, 'data', server, 'StaticData.pack');
}

String getExtractDataFolderPath(bool global) {
  final server = global ? 'global' : 'cn';
  return path.join(appPath, 'data', server, 'extract');
}

enum DataDirectory {
  album('Album', 'Album'),
  arcade('Arcade', 'Arcade'),
  archive('Archive', 'Archive'),
  arena('Arena', 'Arena'),
  attractiveCounsel('AttractiveCounsel', 'AttractiveCounsel'),
  attractiveScenario('AttractiveScenario', 'AttractiveCounsel'),
  autoCharge('AutoCharge', 'Event'), // seems to be event key
  balloonDialog('Balloon', 'Event'), // event SD doll dialog
  // banner('Banner', 'Misc'),
  bgm('BGM', 'BGM'),
  bonusReward('BonusReward', 'Event'),
  bundleBox('BundleBox', 'Shop'),
  // bot('Bot', 'Misc'),
  campaign('Campaign', 'Campaign'),
  contents('Contents', 'Contents'),
  cooperation('Cooperation', 'Cooperation'),
  costume('CostumeShop', 'Shop'),
  customPackage('CustomPackage', 'Shop'),
  dispatch('Dispatch', 'Outpost'),
  event('Event', 'Event'),
  fieldPassword('FieldPassword', 'Event'),
  fishing('Fish', 'Event'),
  gacha('Gacha', 'Gacha'),
  infraCore('InfraCore', 'Outpost'),
  islandAdventure('IslandAdventure', 'Event'),
  intercept('Intercept', 'Intercept'),
  jukebox('Jukebox', 'BGM'),
  liberate('Liberate', 'Outpost'),
  outpost('Outpost', 'Outpost'),
  package('Package', 'Shop'),
  pass('Pass', 'Shop'),
  photo('Photo', 'Event'),
  popup('Popup', 'Shop'),
  productOffer('ProductOffer', 'Shop'),
  profile('Profile', 'Cosmetics'),
  scenario('Scenario', 'Scenario'),
  shop('Shop', 'Shop'),
  sideStory('SideStory', 'SideStory'),
  simulationRoom('SimulationRoom', 'SimulationRoom'),
  soloRaid('SoloRaid', 'Raid'),
  stepUp('StepUp', 'Shop'),
  supportCharacter('SupportCharacter', 'Event'),
  tacticAcademy('TacticAcademy', 'Outpost'),
  unionRaid('UnionRaid', 'Raid'),
  user('User', 'Cosmetics'),
  waveData('WaveData', 'WaveData');

  final String prefix;
  final String dir;

  const DataDirectory(this.prefix, this.dir);
}

String getDesignatedDirectory(String outputDir, String fileName) {
  for (final dataDir in DataDirectory.values) {
    if (fileName.startsWith(dataDir.prefix)) {
      return path.join(outputDir, dataDir.dir, fileName);
    }
  }
  return path.join(outputDir, fileName);
}
