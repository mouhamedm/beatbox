import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 16,
    this.onTap,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final isCircle = shape == BoxShape.circle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.glass,
          shape: shape,
          borderRadius: isCircle ? null : BorderRadius.circular(radius),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: child,
      ),
    );
  }
}
