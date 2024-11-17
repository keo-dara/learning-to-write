import 'package:drawing/cores/game_store.dart';
import 'package:drawing/data_loader.dart';
import 'package:drawing/widget/button.dart';
import 'package:drawing/widget/level_cell.dart';
import 'package:flame/components.dart';

class LevelScreen extends PositionComponent {
  static const int gridRows = 8;
  static const int gridColumns = 3;
  final double cellPadding = 10.0;
  late List<LevelCell> gridCells;
  final Function(int, bool) onTapAt;
  List<String>? keys;
  int page = 0;
  late final List<String> allKeys; // Store all keys
  static const int itemsPerPage = 24;

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
    await gameStore.load();
    allKeys = data.keys.toList(); // Store all keys
    updateCurrentPageKeys(); // Initialize keys for current page

    await buildGrid();
    await addNavigationButtons();
  }

  @override
  void update(double dt) async {
    if (gameStore.wantToUnlocked != null) {
      updateCurrentPageKeys();
      removeAll(gridCells);
      await buildGrid();
      gameStore.wantToUnlocked = null;
    }
    super.update(dt);
  }

  void updateCurrentPageKeys() {
    final startIndex = page * itemsPerPage;
    keys = allKeys.skip(startIndex).take(itemsPerPage).toList();
  }

  Future<void> addNavigationButtons() async {
    final game = findGame()!;

    // Previous button
    final buttonPrev = PlayButton(
      icon: "svg/less.svg",
      action: () async {
        if (page > 0) {
          page--;
          updateCurrentPageKeys();
          removeAll(gridCells);
          await buildGrid();
        }
      },
    );

    final btnY = game.size.y - 110;

    // Next button
    final buttonNext = PlayButton(
      icon: "svg/more.svg",
      action: () async {
        if ((page + 1) * itemsPerPage < allKeys.length) {
          page++;
          updateCurrentPageKeys();
          removeAll(gridCells);
          await buildGrid();
        }
      },
    );

    // Position buttons at the bottom of the screen
    buttonPrev.position = Vector2(
      game.size.x * 0.25, // 25% from left
      btnY,
    );

    buttonNext.position = Vector2(
      game.size.x * 0.55, // 75% from left
      btnY,
    );
    buttonNext.size = Vector2(100, 80);
    buttonPrev.size = buttonNext.size;

    add(buttonPrev);
    add(buttonNext);
  }

  Future<void> buildGrid() async {
    final game = findGame()!;

    // Calculate grid dimensions
    final availableWidth = game.size.x * 1;
    final availableHeight = game.size.y * 0.80;

    final cellWidth =
        (availableWidth - (cellPadding * (gridColumns + 1))) / gridColumns;
    final cellHeight =
        (availableHeight - (cellPadding * (gridRows + 1))) / gridRows;

    // Create grid cells
    gridCells = [];
    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridColumns; col++) {
        final cellIndex = row * gridColumns + col;
        final data = keys!.elementAtOrNull(cellIndex);
        final locked = !gameStore.unlocked.contains(data);

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
            action: () {
              onTapAt(cellIndex + (itemsPerPage * page), locked);
            },
            locked: locked,
          );
          gridCells.add(cell);
        }
      }
    }

    addAll(gridCells);
  }
}
