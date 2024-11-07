import 'package:drawing/data_loader.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide BackButton;

class LevelScreen extends PositionComponent {
  static const int gridRows = 8;
  static const int gridColumns = 3;
  final double cellPadding = 10.0;
  late List<LevelCell> gridCells;
  final Function(String) onTapAt;
  late final List<String> keys;

  LevelScreen({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    required this.onTapAt,
  });

  @override
  Future<void> onLoad() async {
    final data = await JsonReader.readJson('assets/data/position.json');
    keys = data.keys.toList();

    await buildGrid();
  }

  Future<void> buildGrid() async {
    final game = findGame()!;

    // Calculate grid dimensions
    final availableWidth = game.size.x * 1;
    final availableHeight = game.size.y * 0.9;

    final cellWidth =
        (availableWidth - (cellPadding * (gridColumns + 1))) / gridColumns;
    final cellHeight =
        (availableHeight - (cellPadding * (gridRows + 1))) / gridRows;

    // Create grid cells
    gridCells = [];
    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridColumns; col++) {
        final cellIndex = row * gridColumns + col;
        final data = keys.elementAtOrNull(cellIndex);

        if (data != null) {
          final cell = LevelCell(
            data,
            Vector2(
              cellPadding + col * (cellWidth + cellPadding),
              game.size.y * 0.07 +
                  cellPadding +
                  row * (cellHeight + cellPadding),
            ),
            Vector2(cellWidth, cellHeight),
            action: () => onTapAt(data),
          );
          gridCells.add(cell);
        }
      }
    }

    addAll(gridCells);
  }
}

class LevelCell extends PositionComponent with TapCallbacks {
  final String levelNumber;
  late TextComponent levelText;
  late RectangleComponent background;
  final void Function() action;

  LevelCell(this.levelNumber, Vector2 position, Vector2 size,
      {required this.action})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Add cell background
    background = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF4A1B7A),
    );
    add(background);

    // Add level number text
    levelText = TextComponent(
      text: levelNumber.toString(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    levelText.position = Vector2(
      (size.x - levelText.size.x) / 2,
      (size.y - levelText.size.y) / 2,
    );

    add(levelText);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    action();
    scale = Vector2.all(1.0);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
