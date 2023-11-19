import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ws2/home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  double _lampOpacity = 0;
  double _lightOpacity = 0;
  double _textScale = 0.2;
  double _mapSize = 100;

  late AnimationController _animationController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _lampOpacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _lightOpacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _textScale = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _mapSize = 400;
      });
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _arrowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            final dy = details.primaryDelta;

            if (dy! < -20) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => Home(),
                ),
              );
            }
          },
          child: Container(
            color: Colors.pink,
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  child: AnimatedOpacity(
                    opacity: _lightOpacity,
                    duration: const Duration(milliseconds: 1000),
                    child: ClipPath(
                      clipper: TrapeziumClipper(),
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            AnimatedScale(
                              scale: _textScale,
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                'Master Skills\nChange the World',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              child: Icon(
                                Icons.map,
                                size: _mapSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: MediaQuery.sizeOf(context).width / 2 - 32 / 2,
                      bottom: _arrowAnimation.value + 50,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 32,
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: _lampOpacity,
                    duration: const Duration(milliseconds: 500),
                    child: const Icon(
                      Icons.light,
                      size: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width / 2 - 50, 0.0);
    path.lineTo(size.width / 2 + 50, 0.0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
