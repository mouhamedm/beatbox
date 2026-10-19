import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/product_image.dart';
import '../../data/app_state.dart';
import '../../data/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _colorIndex = 0;
  int _qty = 1;

  static const _colorNames = [
    'Space Black',
    'Silver White',
    'Sky Blue',
    'Sunset Coral',
  ];

  static const _features = [
    (Icons.battery_charging_full_rounded, '30H Battery'),
    (Icons.graphic_eq_rounded, 'Adaptive ANC'),
    (Icons.bluetooth_rounded, 'Bluetooth 5.3'),
    (Icons.volume_up_rounded, 'Hi-Res Audio'),
  ];

  @override
  void initState() {
    super.initState();
    // Default to the color matching the product's primary image
    if (widget.product.image.contains('white')) {
      _colorIndex = 1;
    } else {
      _colorIndex = 0;
    }
  }

  Widget _buildHeadphoneImage(Product p) {
    String imagePath;
    ColorFilter? filter;

    switch (_colorIndex) {
      case 0: // Space Black
        imagePath = 'assets/images/headphone_black.png';
        break;
      case 1: // Silver White
        imagePath = 'assets/images/headphone_white.png';
        break;
      case 2: // Sky Blue
        imagePath = 'assets/images/headphone_white.png';
        filter = const ColorFilter.matrix(<double>[
          0.55, 0.0, 0.0, 0.0, 0,
          0.0, 0.72, 0.0, 0.0, 15,
          0.0, 0.0, 1.35, 0.0, 50,
          0.0, 0.0, 0.0, 1.0, 0,
        ]);
        break;
      case 3: // Sunset Coral
        imagePath = 'assets/images/headphone_white.png';
        filter = const ColorFilter.matrix(<double>[
          1.38, 0.0, 0.0, 0.0, 35,
          0.0, 0.62, 0.0, 0.0, 0,
          0.0, 0.0, 0.62, 0.0, 0,
          0.0, 0.0, 0.0, 1.0, 0,
        ]);
        break;
      default:
        imagePath = p.image;
    }

    Widget img = ProductImage(path: imagePath);
    if (filter != null) {
      img = ColorFiltered(colorFilter: filter, child: img);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: KeyedSubtree(
        key: ValueKey('color_${p.id}_$_colorIndex'),
        child: img,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final total = '\$${(p.price * _qty).toStringAsFixed(2)}';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.45),
            radius: 0.9,
            colors: [Color(0xFFB0102E), Color(0xFF5A0814), Color(0xFF14030A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _circleButton(Icons.chevron_left_rounded, () => Navigator.of(context).pop()),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: AppState.instance,
                      builder: (context, _) {
                        final isFav = AppState.instance.isFavorite(p.id);
                        return _circleButton(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          () => AppState.instance.toggleFavorite(p),
                          color: isFav ? AppColors.primary : Colors.white,
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _circleButton(Icons.share_outlined, () {}),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'product_${p.id}',
                      child: Transform.rotate(
                        angle: -0.10, // Same dynamic tilt as in Featured
                        child: _buildHeadphoneImage(p),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    Text(p.priceLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                        const SizedBox(width: 4),
                        Text('${p.rating} (${p.reviewsLabel} Reviews)', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Text('Free Shipping', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text('Choose Color', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _colorNames[_colorIndex],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (var i = 0; i < p.colors.length; i++) ...[
                      GestureDetector(
                        onTap: () => setState(() => _colorIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: i == _colorIndex ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: i == _colorIndex
                                ? [
                                    BoxShadow(
                                      color: p.colors[i].withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: p.colors[i],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    const Spacer(),
                    _qtyButton(Icons.remove, () => setState(() => _qty = _qty > 1 ? _qty - 1 : 1)),
                    SizedBox(
                      width: 36,
                      child: Text('$_qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                    ),
                    _qtyButton(Icons.add, () => setState(() => _qty++)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (var i = 0; i < _features.length; i++) ...[
                      Expanded(
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0x66B0102E),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border, width: 0.6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_features[i].$1, size: 18, color: Colors.white),
                              const SizedBox(height: 6),
                              Text(_features[i].$2, style: const TextStyle(fontSize: 9, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                      if (i < _features.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  radius: 18,
                  padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(total, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          Text('Total Price', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                        ],
                      ),
                      const Spacer(),
                      AppButton(
                        label: 'Add to Cart',
                        icon: Icons.shopping_bag_outlined,
                        compact: true,
                        height: 44,
                        onPressed: () {
                          final selectedColor = _colorNames[_colorIndex];
                          AppState.instance.addToCart(p, colorName: selectedColor, quantity: _qty);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF2E0512),
                              behavior: SnackBarBehavior.floating,
                              content: Text('${p.name} ($selectedColor · x$_qty) added to cart!'),
                              duration: const Duration(milliseconds: 1400),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color color = Colors.white}) => GlassContainer(
        width: 40,
        height: 40,
        padding: EdgeInsets.zero,
        shape: BoxShape.circle,
        onTap: onTap,
        child: Icon(icon, size: 20, color: color),
      );

  Widget _qtyButton(IconData icon, VoidCallback onTap) => GlassContainer(
        width: 28,
        height: 28,
        padding: EdgeInsets.zero,
        radius: 8,
        onTap: onTap,
        child: Icon(icon, size: 16, color: Colors.white),
      );
}
