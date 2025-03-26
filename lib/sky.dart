import 'dart:ui'; // Importação adicionada para a classe Canvas

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Sky extends SpriteComponent {
  final double speed;
  double _scrollOffset = 0;
  late double _imageWidth;

  Sky({this.speed = 100}) : super(priority: -1);

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('sky.png');
    _imageWidth = image.width.toDouble();
    sprite = Sprite(image);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _scrollOffset -= speed * dt;

    // Reseta o deslocamento quando a imagem sai completamente da tela
    if (_scrollOffset <= -_imageWidth) {
      _scrollOffset += _imageWidth;
    }
  }

  @override
  void render(Canvas canvas) {
    // Desenha a imagem repetida para criar o efeito contínuo
    final screenWidth = size.x;
    final imageCount = (screenWidth / _imageWidth).ceil() + 1;

    for (var i = 0; i < imageCount; i++) {
      final position = _scrollOffset + i * _imageWidth;
      sprite?.render(
        canvas,
        position: Vector2(position, 0),
        size: Vector2(_imageWidth, size.y),
      );
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
