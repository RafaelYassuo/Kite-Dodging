import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<KiteDodging> {
  Player() : super(size: Vector2(60, 60), position: Vector2(60, 60));

  late Sprite idleSprite;
  late Sprite flySprite;

  @override
  Future<void>? onLoad() async {
    add(CircleHitbox());

    idleSprite = await Sprite.load('bird.png');
    flySprite = await Sprite.load('bird_fly.png');

    sprite = idleSprite;

    // final frame1 = await Flame.images.load('ember_idle.png');
    // final frame2 = await Flame.images.load('ember_fly.png');

    // animation = SpriteAnimation.spriteList(
    //   [
    //     Sprite(frame1),
    //     Sprite(frame2),
    //   ],
    //   stepTime: 0.30,
    // );

    // final image = await Flame.images.load('ember.png');
    // animation = SpriteAnimation.fromFrameData(
    //   image,
    //   SpriteAnimationData.sequenced(
    //     amount: 4,
    //     stepTime: 0.10,
    //     textureSize: Vector2.all(16),
    //   ),
    // );
  }

  @override
  void onCollisionStart(_, __) {
    super.onCollisionStart(_, __);
    gameRef.gameover();
  }

  void reset() {
    position = Vector2(60, 60);
    sprite = idleSprite;
    removeWhere((component) => component is MoveByEffect);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += 200 * dt;
  }

  void fly() {
    sprite = flySprite;

    final effect = MoveByEffect(
      Vector2(0, -100),
      EffectController(
        duration: 0.5,
        curve: Curves.decelerate,
      ),
    );

    add(effect);

    Future.delayed(const Duration(milliseconds: 100), () {
      sprite = idleSprite;
    });
  }
}
