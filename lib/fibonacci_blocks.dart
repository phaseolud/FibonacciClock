import 'package:flutter/material.dart';

class FibonacciBlock extends StatelessWidget {
  final Offset position;
  final double width;
  final double height;
  final Color color;
  const FibonacciBlock(
      {@required this.color,
      @required this.position,
      @required this.width,
      @required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: CustomPaint(
      painter: _BlockPainter(
          color: color, width: width, height: height, position: position),
    ));
  }
}

class MinuteCircle extends StatelessWidget {
  final Offset position;
  final Color color;
  const MinuteCircle({@required this.color, @required this.position});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _MinuteCirclePainter(color: color, position: position),
      ),
    );
  }
}

class FibonacciLines extends StatelessWidget {
  final double height;
  final double width;
  final Offset position;
  const FibonacciLines({this.width, this.height, this.position});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: CustomPaint(
      painter: _LinePainter(width, height, position),
    ));
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter(this.width, this.height, this.position);
  final double width;
  final double height;
  final Offset position;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.grey[800];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;

    canvas.drawRect(
        Rect.fromCenter(center: position, height: height, width: width), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _BlockPainter extends CustomPainter {
  const _BlockPainter({this.color, this.position, this.width, this.height});

  final Color color;
  final Offset position;
  final double width, height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromCenter(center: position, height: height, width: width), paint);
  }

  @override
  bool shouldRepaint(_BlockPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MinuteCirclePainter extends CustomPainter {
  const _MinuteCirclePainter({this.color, this.position});
  final Color color;
  final Offset position;
  final double radius = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(_MinuteCirclePainter oldDelegate) {
    return true;
  }
}
