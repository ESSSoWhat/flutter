// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class StockArrowPainter extends CustomPainter {
  StockArrowPainter({required this.color, required this.percentChange});

  final Color color;
  final double percentChange;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    paint.strokeWidth = 1.0;
    const double padding = 2.0;
    assert(padding > paint.strokeWidth / 2.0); // make sure the circle remains inside the box
    final double r = (size.shortestSide - padding) / 2.0; // radius of the circle
    final double centerX = padding + r;
    final double centerY = padding + r;

    // Draw the arrow.
    const double w = 8.0;
    double h = 5.0;
    double arrowY;
    if (percentChange < 0.0) {
      h = -h;
      arrowY = centerX + 1.0;
    } else {
      arrowY = centerX - 1.0;
    }
    final Path path = Path();
    path.moveTo(centerX, arrowY - h); // top of the arrow
    path.lineTo(centerX + w, arrowY + h);
    path.lineTo(centerX - w, arrowY + h);
    path.close();
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // Draw a circle that circumscribes the arrow.
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), r, paint);
  }

  @override
  bool shouldRepaint(StockArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.percentChange != percentChange;
  }
}

class StockArrow extends StatelessWidget {
  const StockArrow({super.key, required this.percentChange});

  final double percentChange;

  int _colorIndexForPercentChange(double percentChange) {
    const double maxPercent = 10.0;
    final double normalizedPercentChange = math.min(percentChange.abs(), maxPercent) / maxPercent;
    return 100 + (normalizedPercentChange * 8.0).floor() * 100;
  }

  Color _colorForPercentChange(double percentChange, BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int colorIndex = _colorIndexForPercentChange(percentChange);
    
    if (percentChange > 0) {
      // Use primary color for positive changes, with intensity based on percentage
      final Color baseColor = colorScheme.primary;
      // Blend with a green tint to maintain the positive/gain semantic meaning
      final Color greenTint = Colors.green[colorIndex]!;
      return Color.lerp(baseColor, greenTint, 0.5)!;
    }
    // Use error color for negative changes, with intensity based on percentage
    final Color baseColor = colorScheme.error;
    // Blend with a red tint to maintain the negative/loss semantic meaning
    final Color redTint = Colors.red[colorIndex]!;
    return Color.lerp(baseColor, redTint, 0.5)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: CustomPaint(
        painter: StockArrowPainter(
          color: _colorForPercentChange(percentChange, context),
          percentChange: percentChange,
        ),
      ),
    );
  }
}
