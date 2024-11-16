import 'dart:async';
import 'package:drawing/cores/game_sound.dart';
import 'package:drawing/data_loader.dart';
import 'package:drawing/main.dart';
import 'package:drawing/widget/draw_line.dart';
import 'package:drawing/widget/letter.dart';
import 'package:flame/components.dart';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class DrawingTracingGame extends PositionComponent
    with DragCallbacks, HasGameReference<RouterGame> {
  SpriteComponent? monkey;
  List<SpriteComponent>? bananas;
  Letter? letter;
  final List<DrawingLine> lines = [];
  List<Vector2> currentLine = [];
  bool isDrawing = false;
  int currentStep = 0;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await loadTracing();
  }

  Future<void> loadTracing() async {
    if (letter != null) {
      remove(letter!);
    }

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
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    isDrawing = true;
    currentLine = [event.localPosition];
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!isDrawing) return;
    currentLine.add(event.canvasStartPosition);
    final newLine = DrawingLine(List.from(currentLine), Colors.red);
    add(newLine);

    if (lines.isNotEmpty) {
      remove(lines.last);
    }
    lines.add(newLine);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    isDrawing = false;
    checkCollisions();
  }

  void checkCollisions() async {
    if (currentLine.isEmpty) return;

    // Simple collision detection - check if line endpoints are near objects
    final start = currentLine.first;

    bool startsNearMonkey = monkey!.containsPoint(start);

    SpriteComponent? collidedBanana;
    var containLines = <Vector2>{};

    for (final banana in bananas!) {
      for (var line in currentLine) {
        if (banana.containsPoint(line)) {
          containLines.add(line);
          break;
        }
      }
    }

    // If line connects monkey to banana, consider it a success
    if (startsNearMonkey && bananas!.length == containLines.length) {
      collidedBanana?.scale = Vector2.all(1.2);

      Future.delayed(const Duration(milliseconds: 300), () async {
        if (!isRemoved) {
          collidedBanana?.scale = Vector2.all(1.0);
          monkey = null;

          if (isended()) {
            game.router.pushNamed('pause');
          } else {
            currentStep += 1;
            loadTracing();
          }
          await Vibration.vibrate();
          GameSound.playWinSound();
        }
      });
    }
  }

  bool isended() {
    return dataLoader.position!.data[currentStep] ==
        dataLoader.position!.data.last;
  }

  void clearDrawing() {
    for (final line in lines) {
      remove(line);
    }
    lines.clear();
    currentLine.clear();
  }

  @override
  void onRemove() {
    removeFromParent();
  }
}
