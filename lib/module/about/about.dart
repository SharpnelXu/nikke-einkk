import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final commentStyle = TextStyle(fontSize: 16);
    final List<Widget> children = [
      Image.asset('res/Einkk.png', width: 250),
      Text('Einkk\'s Simulation Room', style: TextStyle(fontSize: 20)),
      Text('Version ${packageInfo.version}+${packageInfo.buildNumber}'),
      Divider(),
      Text('About', style: TextStyle(fontSize: 20)),
      Text('This app is developed by Yome (https://github.com/SharpnelXu).', style: commentStyle),
      Text(
        'The intention is to be able to simulate actual comps to test damage,'
        ' but that will not happen in near future.',
        style: commentStyle,
      ),
      Text('I am not very familiar with front end stuff, so the UI designs will be lacking.', style: commentStyle),
      Divider(),
      Text('Disclaimer', style: TextStyle(fontSize: 20)),
      Text('All data is gathered from web, I do not own any of it.', style: commentStyle),
      Text(
        'I do not intend to use this project for profit nor expect it to result in any sort of financial gain.'
        ' This is a project solely driven by my interest in Nikke as a game.',
        style: commentStyle,
      ),
      Text('Also I just realized I cannot own the app icon and may need to swap it later.', style: commentStyle),
      Divider(),
      Text('Special Thanks', style: TextStyle(fontSize: 20)),
      Text('WindChaser, Lim, YaRou, Hiro, Misha, Narumi, Pro, Kira', style: commentStyle),
      Text('For testing and data unpacking.', style: commentStyle),
      Text('Contact yome1561 at Discord if you have questions or concerns.', style: commentStyle),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('About Einkk App')),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Align(
            alignment: Alignment.center,
            child: Padding(padding: const EdgeInsets.all(3.0), child: children[index]),
          );
        },
      ),
    );
  }
}
