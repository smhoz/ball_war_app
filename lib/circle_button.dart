import 'package:ball_war_app/context_extension.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  const CircleButton({Key? key, this.onTap, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: context.paddingLow,
          decoration:
              const BoxDecoration(color: Color(0xFF5FC6FF), shape: BoxShape.circle),
          child: Icon(
            icon,
            size: context.height * 0.05,
            color: Colors.white,
          ),
        ));
  }
}
