import 'package:flutter/material.dart';

class BrickTile extends StatefulWidget {
  final Size size;
  final Color brickColor;
  final Color mortarColor;

  BrickTile({
    super.key,
    required this.size,
    this.brickColor = Colors.red,
    this.mortarColor = Colors.grey,
  });

  @override
  _BrickTileState createState() => _BrickTileState();
}

class _BrickTileState extends State<BrickTile> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: BrickPainter(
        brickColor: widget.brickColor,
        mortarColor: widget.mortarColor,
      ),
    );
  }
}

class BrickPainter extends CustomPainter {
  final Color brickColor;
  final Color mortarColor;

  BrickPainter({
    this.brickColor = Colors.red,
    this.mortarColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double brickWidth = size.width / 6;
    final double brickHeight = size.height / 3;

    final Paint mortarPaint = Paint()
      ..color = mortarColor
      ..strokeWidth = 2.0;

    // Draw horizontal mortar lines
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, i * brickHeight),
        Offset(size.width, i * brickHeight),
        mortarPaint,
      );
    }

    // Draw vertical mortar lines
    for (int i = 0; i < 7; i++) {
      canvas.drawLine(
        Offset(i * brickWidth, 0),
        Offset(i * brickWidth, size.width),
        mortarPaint,
      );
    }

    final Paint brickPaint = Paint()..color = brickColor;

    // Draw the bricks
    for (int i = 0; i < 14; i++) {
      final int row = i ~/ 2;
      final int col = i % 7;

      if (row % 2 == 0 && col % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(
            col * brickWidth,
            row * brickHeight,
            brickWidth,
            brickHeight,
          ),
          brickPaint,
        );
      } else if (row % 2 == 1 && col % 2 == 1) {
        canvas.drawRect(
          Rect.fromLTWH(
            col * brickWidth,
            row * brickHeight,
            brickWidth,
            brickHeight,
          ),
          brickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BrickPainter oldDelegate) => false;
}
