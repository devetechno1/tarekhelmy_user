import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  final Color color;
  const RPSCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {

  Paint paint0Fill = Paint()..style=PaintingStyle.fill;
  paint0Fill.color = color.withOpacity(0.05);
  canvas.drawCircle(Offset(size.width*0.58,size.height*0.12),size.width*0.58,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
  return true;
  }
}