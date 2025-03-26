import 'dart:math';

import 'package:flame/components.dart';

import 'game.dart';
import 'box.dart';

class BoxStack extends PositionComponent with HasGameRef<KiteDodging> {
  final bool isBottom;
  static final random = Random();

  BoxStack({required this.isBottom});

  @override
  Future<void>? onLoad() async {
    // Posiciona o BoxStack no canto direito da tela
    position.x = gameRef.size.x;
    position.y = isBottom ? gameRef.size.y - Box.initialSize.y : 0;

    final gameWidth = gameRef.size.x;
    final boxWidth = Box.initialSize.x;
    final maxStackWidth = (gameWidth / boxWidth).floor() - 2;

    // Gera uma pilha horizontal de pipas
    final stackWidth = random.nextInt(maxStackWidth + 1);
    final boxSpacing = boxWidth * (2 / 3);
    final initialX = 0.0;

    final boxes = List.generate(stackWidth, (index) {
      return Box(
        position: Vector2(initialX + index * boxSpacing, 0),
      );
    });
    addAll(boxes);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move o BoxStack para a esquerda
    position.x -= gameRef.speed * dt;

    // Remove o BoxStack quando ele sai da tela
    if (position.x < -Box.initialSize.x * 2) {
      removeFromParent();
    }
  }
}
