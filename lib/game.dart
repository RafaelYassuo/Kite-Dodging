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

class KiteDodging extends FlameGame
    with TapDetector, HasCollisionDetection, HasGameRef<KiteDodging> {
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

  bool get canSpawnNewBoxes {
    // Se não há pipas na tela, pode spawnar novas
    if (children.whereType<BoxStack>().isEmpty) return true;

    // Verifica se todas as pipas existentes já percorreram pelo menos metade da tela
    for (final boxStack in children.whereType<BoxStack>()) {
      if (boxStack.position.x > size.x / 2) {
        // Alterado gameRef.size.x para size.x
        return false;
      }
    }
    return true;
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
    speed = 300;
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
    gameRef.size.x <= 500 ? speed * 0.6 : speed += 10 * dt;

    _timeSinceBox += dt;

    if (_timeSinceBox > _boxInterval && canSpawnNewBoxes) {
      add(BoxStack());
      _timeSinceBox = 0;
    }

    for (final boxStack in children.whereType<BoxStack>()) {
      if (!_passedBoxStacks.contains(boxStack) &&
          player.position.x > boxStack.position.x + boxStack.width) {
        _passedBoxStacks.add(boxStack);
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
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                overlays.remove('GameOver');
                restartGame();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
