import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.name = 'Alex',
    this.onAvatarTap,
    this.onNotificationTap,
  });

  final String name;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Vector Avatar on the left with glowing border
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0245E), Color(0xFF7A0A22)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),

        // Notifications on the right
        GestureDetector(
          onTap: onNotificationTap,
          child: Stack(
            children: [
              const GlassContainer(
                width: 42,
                height: 42,
                padding: EdgeInsets.zero,
                shape: BoxShape.circle,
                child: Icon(Icons.notifications_none_rounded, size: 21, color: Colors.white),
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
