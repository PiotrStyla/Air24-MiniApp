import 'package:flutter/material.dart';

/// A simple Google logo widget to use in Google Sign-In buttons
class GoogleLogo extends StatelessWidget {
  final double size;
  
  const GoogleLogo({
    Key? key,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Colors for the Google logo
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = width / 2;
    
    // Draw the Google 'G'
    final path = Path();
    
    // Top red arc
    path.moveTo(centerX, centerY - radius * 0.4);
    path.arcToPoint(
      Offset(centerX + radius * 0.4, centerY),
      radius: Radius.circular(radius * 0.55),
      clockwise: true,
    );
    canvas.drawPath(path, redPaint);
    path.reset();
    
    // Right blue arc
    path.moveTo(centerX + radius * 0.4, centerY);
    path.arcToPoint(
      Offset(centerX, centerY + radius * 0.4),
      radius: Radius.circular(radius * 0.55),
      clockwise: true,
    );
    canvas.drawPath(path, bluePaint);
    path.reset();
    
    // Bottom green arc
    path.moveTo(centerX, centerY + radius * 0.4);
    path.arcToPoint(
      Offset(centerX - radius * 0.4, centerY),
      radius: Radius.circular(radius * 0.55),
      clockwise: true,
    );
    canvas.drawPath(path, greenPaint);
    path.reset();
    
    // Left yellow arc with a straight line to form the 'G'
    path.moveTo(centerX - radius * 0.4, centerY);
    path.arcToPoint(
      Offset(centerX, centerY - radius * 0.4),
      radius: Radius.circular(radius * 0.55),
      clockwise: true,
    );
    canvas.drawPath(path, yellowPaint);
    
    // Draw the straight line to create the 'G' shape
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + radius * 0.3, centerY),
      Paint()
        ..color = bluePaint.color
        ..strokeWidth = radius * 0.15
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
