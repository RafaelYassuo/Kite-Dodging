import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

class Clouds extends PositionComponent {
  final List<String> cloudImages = ['cloud.png'];
  final int maxClouds;
  final double speed;
  final Random _random = Random();
  final List<SpriteComponent> _clouds = [];

  Clouds({
    this.maxClouds = 3,
    this.speed = 120,
  });

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll(cloudImages);
    _spawnInitialClouds();
  }

  void _spawnInitialClouds() {
    for (int i = 0; i < maxClouds; i++) {
      _spawnCloud(delay: i * 2.0); // Espaça o aparecimento das nuvens
    }
  }

  void _spawnCloud({double delay = 0}) async {
    if (delay > 0) {
      await Future.delayed(Duration(seconds: delay.toInt()));
    }

    final imagePath = cloudImages[_random.nextInt(cloudImages.length)];
    final image = Flame.images.fromCache(imagePath);

    // Tamanho aleatório entre 50 e 150 pixels de largura
    final cloudWidth = 50.0 + _random.nextDouble() * 100;
    final aspectRatio = image.width / image.height;
    final cloudHeight = cloudWidth / aspectRatio;

    final cloud = SpriteComponent.fromImage(
      image,
      size: Vector2(cloudWidth, cloudHeight),
      position: Vector2(
        size.x + cloudWidth, // Começa fora da tela à direita
        _random.nextDouble() * (size.y - cloudHeight), // Posição Y aleatória
      ),
    );

    _clouds.add(cloud);
    add(cloud);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move as nuvens e verifica se saíram da tela
    _clouds.removeWhere((cloud) {
      cloud.position.x -= speed * dt;

      if (cloud.position.x + cloud.width < 0) {
        remove(cloud);
        return true; // Remove a nuvem da lista
      }
      return false;
    });

    // Respawn de nuvens quando necessário
    if (_clouds.length < maxClouds && _random.nextDouble() < 0.02) {
      _spawnCloud();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
