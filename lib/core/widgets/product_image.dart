import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Affiche l'image du produit, ou une icône si l'asset est absent.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path, this.fit = BoxFit.contain});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.headphones_rounded, size: 72, color: AppColors.textSecondary),
      ),
    );
  }
}
