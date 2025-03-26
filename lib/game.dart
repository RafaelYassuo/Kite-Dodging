import 'dart:math';
import 'package:kite_dodging/city.dart';
import 'package:kite_dodging/clouds.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:kite_dodging/player.dart';
import 'package:flame_audio/flame_audio.dart';
import 'sky.dart';
import 'boxstack.dart';

class KiteDodging extends FlameGame with TapDetector, HasCollisionDetection {
  late final Player player;
  int score = 0;
  late TextComponent scoreText;
  double speed = 300;
  final random = Random();
  final Set<BoxStack> _passedBoxStacks = {};

  late final City city;

  @override
  void onLoad() async {
    player = Player();
    add(Sky());
    add(City());
    add(Clouds());
    add(ScreenHitbox());
    add(player);

    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Arial',
        ),
      ),
    );

    scoreText.priority = 100;

    add(scoreText);
    return;
  }

  void gameover() {
    FlameAudio.bgm.stop();
    pauseEngine();

    overlays.add('GameOver');
  }

  void updateScore() {
    score += 1;
    scoreText.text = 'Score: $score';
  }

  void restartGame() {
    speed = 500;
    score = 0;
    scoreText.text = 'Score: $score';

    player.reset();

    children.whereType<BoxStack>().forEach((boxStack) {
      boxStack.removeFromParent();
    });

    _passedBoxStacks.clear();

    resumeEngine();
  }

  double _timeSinceBox = 0;
  final double _boxInterval = 1;
  @override
  void update(double dt) {
    super.update(dt);
    speed += 10 * dt;
    _timeSinceBox += dt;

    if (_timeSinceBox > _boxInterval) {
      add(BoxStack(isBottom: random.nextBool()));
      _timeSinceBox = 0;
    }

    for (final boxStack in children.whereType<BoxStack>()) {
      if (!_passedBoxStacks.contains(boxStack) &&
          player.position.x > boxStack.position.x + boxStack.width) {
        // O jogador passou pelo BoxStack
        _passedBoxStacks.add(boxStack); // Marca o BoxStack como contabilizado
        updateScore();
      }
    }
  }

  @override
  void onTap() {
    super.onTap();
    player.fly();
  }

  Widget buildGameoverMenu(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                overlays.remove('GameOver');
                restartGame();
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
