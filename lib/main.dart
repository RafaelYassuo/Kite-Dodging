import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  final game = KiteDodging();

  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameOver': (context, game) =>
                (game as KiteDodging).buildGameoverMenu(context),
          },
        ),
      ),
    ),
  );
}
