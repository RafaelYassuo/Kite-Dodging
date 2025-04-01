import 'dart:math';
import 'package:flame/components.dart';
import 'game.dart';
import 'box.dart';

class BoxStack extends PositionComponent with HasGameRef<KiteDodging> {
  static final random = Random();
  late final double boxWidth;
  late final double boxHeight;
  late bool _isBottom; // Removido do construtor
  double _groupWidth = 0;

  BoxStack(); // Construtor vazio agora

  @override
  Future<void>? onLoad() async {
    // Definindo _isBottom aqui, quando gameRef está disponível
    _isBottom = gameRef.size.x <= 1000 ? true : false;

    boxWidth = Box.initialSize.x;
    boxHeight = Box.initialSize.y;

    if (gameRef.size.x > 1000) {
      await _loadWideScreenVersion();
    } else {
      await _loadNarrowScreenVersion();
    }
  }

  // Restante do código permanece igual...
  Future<void> _loadWideScreenVersion() async {
    const maxBoxes = 3;
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

  Future<void> _loadNarrowScreenVersion() async {
    position.x = gameRef.size.x;
    position.y = _isBottom ? gameRef.size.y - boxHeight : 0;

    final gameWidth = gameRef.size.x;
    final maxStackWidth = (gameWidth / boxWidth).floor() - 2;
    final stackWidth = random.nextInt(maxStackWidth + 1);
    final boxSpacing = boxWidth * (2 / 3);

    final boxes = List.generate(stackWidth, (index) {
      return Box(
        position: Vector2(index * boxSpacing, 0),
      );
    });

    addAll(boxes);
    _groupWidth = stackWidth * boxSpacing;
  }

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
