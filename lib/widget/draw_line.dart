import 'dart:ui';

import 'package:flame/components.dart';

class DrawingLine extends Component {
  final List<Vector2> points;
  final Paint paint;

  DrawingLine(this.points, Color color)
      : paint = Paint()
          ..color = color
          ..strokeWidth = 15
          ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.x, points.first.y);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    canvas.drawPath(path, paint);
  }
}
