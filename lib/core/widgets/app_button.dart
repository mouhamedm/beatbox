import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.white = false,
    this.height = 54,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool white;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final fg = white ? AppColors.primaryDark : Colors.white;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: compact ? const EdgeInsets.symmetric(horizontal: 20) : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white ? Colors.white : null,
          gradient: white ? null : AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(compact ? 14 : 16),
        ),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && !white) ...[
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
            ],
            Text(label, style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w600)),
            if (icon != null && white) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}
