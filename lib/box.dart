import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Box extends SpriteComponent {
  static Vector2 initialSize = Vector2.all(150);
  Box({super.position}) : super(size: initialSize);

  @override
  Future<void>? onLoad() async {
    final image = await Flame.images.load('boxes/pipa.png');

    sprite = Sprite(image);

    // Define os pontos do polígono de colisão
    final hitboxPoints = [
      Vector2(75, 0), // Topo (mantido)
      Vector2(150, 75), // Lado direito (mantido)
      Vector2(130, 100), // Rabiola direita (mantido)
      Vector2(90, 100), // Ponto médio
      Vector2(60, 40), // Rabiola esquerda
      Vector2(20, 50), // Lado esquerdo
    ];

    // Adiciona o PolygonHitbox ao componente
    add(PolygonHitbox(hitboxPoints));
  }
}
