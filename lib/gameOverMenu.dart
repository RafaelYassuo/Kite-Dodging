import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class GameOverMenu extends PositionComponent {
  final VoidCallback onRestart;
  final Vector2 gameSize; // Tamanho do jogo para posicionar o botão

  GameOverMenu({required this.onRestart, required this.gameSize});

  @override
  Future<void>? onLoad() async {
    size = gameSize;

    // Adiciona um fundo semi-transparente
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0x80000000),
      ),
    );

    // Cria um botão de "Restart"
    final restartButton = ButtonComponent(
      position: Vector2(gameSize.x / 2 - 75, gameSize.y / 2),
      button: TextComponent(
        text: 'Restart',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'Arial',
          ),
        ),
      ),
      onPressed: onRestart,
    );

    add(restartButton);
    return super.onLoad();
  }
}
