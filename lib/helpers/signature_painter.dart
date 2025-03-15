import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SignaturePainter extends CustomPainter {
  SignaturePainter({required this.paintingPoints});

  final List<PaintingPoint?> paintingPoints;
  late List<Offset> offsets = List.empty(growable: true);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < paintingPoints.length - 1; i++) {
      if (paintingPoints[i] != null && paintingPoints[i + 1] != null) {
        canvas.drawLine(paintingPoints[i]!.offset,
            paintingPoints[i + 1]!.offset, paintingPoints[i]!.paint);
      } else if (paintingPoints[i] != null && paintingPoints[i + 1] == null) {
        offsets.clear();
        offsets.add(paintingPoints[i]!.offset);

        canvas.drawPoints(
            ui.PointMode.points, offsets, paintingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PaintingPoint {
  PaintingPoint({required this.offset, required this.paint});

  final Offset offset;
  final Paint paint;
}
