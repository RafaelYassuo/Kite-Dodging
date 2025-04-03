import 'dart:math';
import 'package:flame/components.dart';
import 'game.dart';
import 'box.dart';

class BoxStack extends PositionComponent with HasGameRef<KiteDodging> {
  static final random = Random();
  late final double boxWidth;
  late final double boxHeight;
  bool _isBottom = false;
  double _groupWidth = 0;

  BoxStack();

  @override
  Future<void> onLoad() async {
    boxWidth = Box.initialSize.x;
    boxHeight = Box.initialSize.y;

    // Determina se é versão bottom baseado na orientação e tamanho
    final isPortrait = gameRef.size.y > gameRef.size.x;
    _isBottom = gameRef.size.x <= 1000 || isPortrait;

    if (gameRef.size.x > 1000 && !isPortrait) {
      await _loadWideLandscapeVersion(3);
    } else {
      await _loadWideLandscapeVersion(1);
    }
  }

  Future<void> _loadWideLandscapeVersion(int maxBoxes) async {
    // const maxBoxes = 3;
    final numberOfBoxes = random.nextInt(maxBoxes) + 1;
    final List<Vector2> _occupiedPositions = [];

    position.x = gameRef.size.x;

    for (var i = 0; i < numberOfBoxes; i++) {
      Vector2 newPos;
      bool positionValid;
      int attempts = 0;

      do {
        final posX = i * (boxWidth * 1.5);
        final posY = random.nextDouble() * (gameRef.size.y - boxHeight);
        newPos = Vector2(posX, posY);

        positionValid = !_isPositionOccupied(newPos, _occupiedPositions);
        attempts++;
      } while (!positionValid && attempts < 10);

      if (positionValid) {
        _occupiedPositions.add(newPos);
        add(Box(position: newPos));
        _groupWidth = max(_groupWidth, newPos.x + boxWidth);
      }
    }
  }

  // Future<void> _loadPortraitOrNarrowVersion() async {
  //   position.x = gameRef.size.x;
  //   position.y = _isBottom ? gameRef.size.y - boxHeight : 0;

  //   final gameWidth = gameRef.size.x;
  //   final maxStackWidth = (gameWidth / boxWidth).floor() - 2;
  //   final stackWidth = random.nextInt(maxStackWidth + 1);
  //   final boxSpacing = boxWidth * (2 / 3);

  //   final boxes = List.generate(stackWidth, (index) {
  //     return Box(
  //       position: Vector2(index * boxSpacing, 0),
  //     );
  //   });

  //   addAll(boxes);
  //   _groupWidth = stackWidth * boxSpacing;
  // }

  bool _isPositionOccupied(Vector2 position, List<Vector2> occupiedPositions) {
    for (final pos in occupiedPositions) {
      if ((position - pos).length < boxWidth) {
        return true;
      }
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.speed * dt;

    if (position.x < -_groupWidth) {
      removeFromParent();
    }
  }
}
