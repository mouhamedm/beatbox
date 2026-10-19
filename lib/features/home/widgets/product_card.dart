import 'package:flutter/material.dart';
import '../../../core/widgets/product_image.dart';
import '../../../data/product.dart';
import '../../product_detail/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isLeft = true,
  });

  final Product product;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    const double cardTopOffset = 24.0;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. The Card Container (top edge starts at 24px so the headband overflows)
          Positioned(
            top: cardTopOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              decoration: BoxDecoration(
                color: const Color(0xFF22040D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price & Star Rating row ($399, $549 without .0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.shortPrice,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFFFB400),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Headphone overflowing 24px above the card top edge with sleek 3D lean
          Positioned(
            top: 0,
            left: 6,
            right: 6,
            bottom: 54,
            child: IgnorePointer(
              child: Center(
                child: Hero(
                  tag: 'product_${product.id}',
                  child: Transform.rotate(
                    angle: -0.10, // Leans to the left like in the target design
                    child: Transform.scale(
                      scale: 1.06, // Perfectly proportioned to match design
                      child: ProductImage(
                        path: product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
