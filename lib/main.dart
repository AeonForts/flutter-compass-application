import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

void main() => runApp(const CompassApp());

class CompassApp extends StatelessWidget {
  const CompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CompassScreen(),
    );
  }
}

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  String getDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'North';
    if (heading >= 22.5 && heading < 67.5) return 'North East';
    if (heading >= 67.5 && heading < 112.5) return 'East';
    if (heading >= 112.5 && heading < 157.5) return 'South East';
    if (heading >= 157.5 && heading < 202.5) return 'South';
    if (heading >= 202.5 && heading < 247.5) return 'South West';
    if (heading >= 247.5 && heading < 292.5) return 'West';
    if (heading >= 292.5 && heading < 337.5) return 'North West';
    return 'North';
  }

  Color getDirectionColor(double heading) {
    if (heading >= 337.5 || heading < 22.5) return Colors.red;
    return Colors.cyan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.cyan),
                    SizedBox(height: 20),
                    Text(
                      'Initializing Compass...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            double? rawHeading = snapshot.data!.heading;
            
            if (rawHeading == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 20),
                    Text(
                      'Compass Not Available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Your device does not support compass functionality',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              );
            }

            double heading = rawHeading;

            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'DIGITAL COMPASS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Compass Visual
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),

                          // Rotating compass ring
                          Transform.rotate(
                            angle: -heading * math.pi / 180,
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.cyan.withOpacity(0.6),
                                  width: 2,
                                ),
                              ),
                              child: CustomPaint(
                                painter: CompassTicksPainter(),
                                child: Stack(
                                  children: [
                                    // North label (Red)
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          'N',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[400],
                                            shadows: [
                                              Shadow(
                                                color: Colors.red.withOpacity(0.5),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // South
                                    const Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          'S',
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // East
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Text(
                                          'E',
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // West
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                          'W',
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Center dot
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),

                          // North indicator needle (static)
                          CustomPaint(
                            size: const Size(60, 60),
                            painter: NeedlePainter(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Direction info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: getDirectionColor(heading).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            getDirection(heading),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: getDirectionColor(heading),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${heading.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Calibration tip
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.cyan,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Move your phone in a figure-8 pattern to calibrate',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for compass ticks
class CompassTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 360; i += 6) {
      final angle = i * math.pi / 180;
      final isMainTick = i % 30 == 0;
      final tickLength = isMainTick ? 15.0 : 8.0;
      
      if (isMainTick) {
        paint.strokeWidth = 2;
        paint.color = Colors.white54;
      } else {
        paint.strokeWidth = 1;
        paint.color = Colors.white24;
      }

      final startPoint = Offset(
        center.dx + (radius - tickLength) * math.cos(angle - math.pi / 2),
        center.dy + (radius - tickLength) * math.sin(angle - math.pi / 2),
      );

      final endPoint = Offset(
        center.dx + radius * math.cos(angle - math.pi / 2),
        center.dy + radius * math.sin(angle - math.pi / 2),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the needle
class NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // North part (red)
    final northPath = Path()
      ..moveTo(center.dx, center.dy - 40)
      ..lineTo(center.dx - 8, center.dy + 5)
      ..lineTo(center.dx, center.dy)
      ..lineTo(center.dx + 8, center.dy + 5)
      ..close();

    paint.color = Colors.red[400]!;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.red[300]!, Colors.red[600]!],
    ).createShader(Rect.fromCircle(center: center, radius: 40));
    
    canvas.drawPath(northPath, paint);
    canvas.drawShadow(northPath, Colors.red, 8, true);

    // South part (white)
    final southPath = Path()
      ..moveTo(center.dx, center.dy + 40)
      ..lineTo(center.dx - 8, center.dy - 5)
      ..lineTo(center.dx, center.dy)
      ..lineTo(center.dx + 8, center.dy - 5)
      ..close();

    paint.color = Colors.white70;
    paint.shader = null;
    canvas.drawPath(southPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}