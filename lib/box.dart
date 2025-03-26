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
      Vector2(75, 0), // Topo da pipa (centro superior)
      Vector2(150, 75), // Lado direito da pipa
      Vector2(130, 140), // Início da rabiola (lado direito)
      Vector2(100, 200), // Ponto médio da rabiola
      Vector2(20, 140), // Início da rabiola (lado esquerdo)
      Vector2(0, 55), // Lado esquerdo da pipa
    ];

    // Adiciona o PolygonHitbox ao componente
    add(PolygonHitbox(hitboxPoints));
  }
}
