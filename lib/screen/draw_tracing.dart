import 'dart:async';
import 'package:drawing/data_loader.dart';
import 'package:drawing/widget/draw_line.dart';
import 'package:drawing/widget/letter.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DrawingTracingGame extends FlameGame with PanDetector {
  SpriteComponent? monkey;
  List<SpriteComponent>? bananas;
  Letter? letter;
  final List<DrawingLine> lines = [];
  List<Vector2> currentLine = [];
  bool isDrawing = false;
  late final DataLoader dataLoader;
  int currentStep = 0;

  @override
  Color backgroundColor() => const Color(0xFF333333);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    dataLoader = DataLoader();
    await dataLoader.loadData();
    await loadTracing();
  }

  Future<void> loadTracing() async {
    letter = Letter(pos: dataLoader.position!.data[currentStep]);
    letter!.position = size / 2;

    add(letter!);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (letter?.isLoaded == true && monkey == null) {
      monkey = letter!.monkeys[0];
      bananas = letter!.bananas;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    isDrawing = true;
    currentLine = [info.eventPosition.widget];
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isDrawing) return;
    currentLine.add(info.eventPosition.widget);
    final newLine = DrawingLine(List.from(currentLine), Colors.red);
    add(newLine);

    // Remove the previous line to avoid duplicates
    if (lines.isNotEmpty) {
      remove(lines.last);
    }
    lines.add(newLine);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    isDrawing = false;
    checkCollisions();
  }

  void checkCollisions() {
    if (currentLine.isEmpty) return;

    // Simple collision detection - check if line endpoints are near objects
    final start = currentLine.first;
    final end = currentLine.last;

    bool startsNearMonkey = monkey!.containsPoint(start);
    bool endsNearBanana = false;
    SpriteComponent? collidedBanana;

    for (final banana in bananas!) {
      if (banana.containsPoint(end)) {
        endsNearBanana = true;
        collidedBanana = banana;
        break;
      }
    }

    // If line connects monkey to banana, consider it a success
    if (startsNearMonkey && endsNearBanana && collidedBanana != null) {
      print('Success! Connected monkey to banana!');
      // Add visual feedback
      collidedBanana.scale =
          Vector2.all(1.2); // Temporarily scale up the banana
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isRemoved) {
          // Check if the game is still active
          collidedBanana?.scale = Vector2.all(1.0);
          // clearDrawing();
          currentStep = 1;
          loadTracing();
          monkey = null;
        }
      });
    }
  }

  void clearDrawing() {
    for (final line in lines) {
      remove(line);
    }
    lines.clear();
    currentLine.clear();
  }
}
