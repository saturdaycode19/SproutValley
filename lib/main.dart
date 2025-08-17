import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sproutvalley/sprout_valley.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprout Valley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: GameWidget(
          game: SproutValley()..initWithBuildContext(context)
      ),
    );
  }
}
