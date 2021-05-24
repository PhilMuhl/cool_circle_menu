import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleMenu extends StatefulWidget {
  final VoidCallback closeCallback;

  CircleMenu(this.closeCallback);

  @override
  _CircleMenuState createState() => _CircleMenuState();
}

class _CircleMenuState extends State<CircleMenu> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _exitButtonSizeAnimation;
  Animation<double> _rotationAnimation;

  final double size = 200;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    _exitButtonSizeAnimation = Tween<double>(
      begin: 0,
      end: 26,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut)));

    _rotationAnimation = Tween<double>(
      begin: math.pi,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOut)));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 38,
      height: size + 38,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: _animationController.value,
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    height: size,
                    width: size),
              ),
              Transform.scale(
                scale: _animationController.value,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    height: size * .35,
                    width: size * .35,
                  ),
                ),
              ),
              Transform.scale(
                scale: _animationController.value,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    //height: size * .25,
                    //width: size * .25,
                    padding: const EdgeInsets.all(2.0),
                    child: IconButton(
                      icon: Icon(Icons.clear_rounded),
                      iconSize: _exitButtonSizeAnimation.value,
                      color: Colors.blue,
                      onPressed: () {
                        close();
                      },
                    ),
                  ),
                ),
              ),
              Transform.rotate(
                angle: _rotationAnimation.value,
                child: Stack(
                  children: [
                    _buildOption(Icons.check_circle, math.pi, Colors.blue),
                    _buildOption(
                        Icons.flash_on, math.pi + 4 * math.pi / 5, Colors.red),
                    _buildOption(Icons.access_time, math.pi - 4 * math.pi / 5,
                        Colors.green),
                    _buildOption(Icons.error_outline, math.pi + 2 * math.pi / 5,
                        Colors.orange),
                    _buildOption(Icons.check_box_rounded,
                        math.pi - 2 * math.pi / 5, Colors.purple),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle, Color color) {
    return Transform.scale(
      scale: _animationController.value,
      child: Transform.rotate(
        angle: angle,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                onPressed: () {
                  //widget.onClick();
                  close();
                },
                icon: Transform.rotate(
                  angle: -angle,
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                iconSize: 26,
                alignment: Alignment.center,
                padding: EdgeInsets.all(0.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void close() async {
    await _animationController.reverse();
    widget.closeCallback();
  }
}
