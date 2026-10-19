import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class HeadphoneSearchBar extends StatelessWidget {
  const HeadphoneSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassContainer(
      radius: 28,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search headphones...',
                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.mic_none_rounded, size: 20, color: Colors.white70),
        ],
      ),
    );
  }
}
