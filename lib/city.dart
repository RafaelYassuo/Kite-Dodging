import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

class City extends PositionComponent {
  final List<String> cityImagePaths = [
    'ed.png',
    "ed2.png",
    'ed3.png',
    'ed4.png',
    'ed5.png'
  ];
  final double speed;
  final double yOffset;
  final double spacing;
  late List<SpriteComponent> _citySprites;
  double _totalWidth = 0;

  City({
    this.speed = 100,
    this.yOffset = 20,
    this.spacing = -40,
  });

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll(cityImagePaths);

    _citySprites = cityImagePaths.map((path) {
      final image = Flame.images.fromCache(path);
      return SpriteComponent.fromImage(
        image,
        size: Vector2(size.x, size.y),
        position: Vector2(0, yOffset),
      );
    }).toList();

    _positionSprites();
    addAll(_citySprites);
  }

  void _positionSprites() {
    double offsetX = 0;
    for (final sprite in _citySprites) {
      sprite.position = Vector2(offsetX, yOffset);
      offsetX += sprite.width + spacing; // Aplica o espaçamento aqui
    }
    _totalWidth = offsetX - spacing; // Ajusta o cálculo do comprimento total
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final sprite in _citySprites) {
      sprite.position.x -= speed * dt;

      if (sprite.position.x + sprite.width < 0) {
        final lastSprite =
            _citySprites.reduce((a, b) => a.position.x > b.position.x ? a : b);
        sprite.position.x = lastSprite.position.x + lastSprite.width + spacing;
        sprite.position.y = yOffset;
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;

    for (final sprite in _citySprites) {
      sprite.size = Vector2(size.x, size.y);
      sprite.position.y = yOffset;
    }

    _positionSprites();
  }
}
