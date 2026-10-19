import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_products.dart';
import '../cart/cart_screen.dart';
import '../explore/explore_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/category_chips.dart';
import 'widgets/hero_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/modern_bottom_nav_bar.dart';
import 'widgets/product_card.dart';
import 'widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openProfile() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, animation, secondaryAnimation) =>
            const ProfileScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(curve),
            child: FadeTransition(opacity: curve, child: child),
          );
        },
      ),
    );
  }

  Animation<double> _fade(double start, double end) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );

  Animation<Offset> _slide(
    double start,
    double end, {
    Offset begin = const Offset(0, 0.2),
  }) => Tween<Offset>(begin: begin, end: Offset.zero).animate(
    CurvedAnimation(
      parent: _animController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ),
  );

  Animation<double> _scale(double start, double end, {double begin = 0.94}) =>
      Tween<double>(begin: begin, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: IndexedStack(
          index: _navIndex,
          children: [
            // Tab 0: Home view
            _buildHomeTab(),

            // Tab 1: Explore view
            const ExploreScreen(),

            // Tab 2: Favorites view
            FavoritesScreen(onExploreTap: () => setState(() => _navIndex = 1)),

            // Tab 3: Cart view
            CartScreen(onExploreTap: () => setState(() => _navIndex = 1)),
          ],
        ),
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fade(0.55, 0.95),
        child: SlideTransition(
          position: _slide(0.55, 0.95, begin: const Offset(0, 0.5)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ModernBottomNavBar(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Avatar with Profile Tap & Notification)
                  FadeTransition(
                    opacity: _fade(0.0, 0.45),
                    child: SlideTransition(
                      position: _slide(0.0, 0.45, begin: const Offset(0, -0.4)),
                      child: HomeHeader(
                        name: 'Alex',
                        onAvatarTap: _openProfile,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  FadeTransition(
                    opacity: _fade(0.15, 0.55),
                    child: ScaleTransition(
                      scale: _scale(0.15, 0.55),
                      child: const HeadphoneSearchBar(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Category chips
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fade(0.25, 0.65),
              child: SlideTransition(
                position: _slide(0.25, 0.65, begin: const Offset(0.2, 0)),
                child: const CategoryChips(),
              ),
            ),
          ),
          // Hero banner
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fade(0.35, 0.75),
                child: ScaleTransition(
                  scale: _scale(0.35, 0.75, begin: 0.92),
                  child: HeroBanner(
                    onExploreTap: () => setState(() => _navIndex = 1),
                  ),
                ),
              ),
            ),
          ),
          // "Featured" title
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fade(0.45, 0.80),
                child: SlideTransition(
                  position: _slide(0.45, 0.80, begin: const Offset(0, 0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _navIndex = 1),
                        child: Text(
                          'See all',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Product cards with staggered cascade
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
            sliver: SliverGrid.builder(
              itemCount: mockProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.77,
              ),
              itemBuilder: (_, i) {
                final startInterval = (0.50 + i * 0.08).clamp(0.0, 0.85);
                final endInterval = (startInterval + 0.35).clamp(0.0, 1.0);
                return FadeTransition(
                  opacity: _fade(startInterval, endInterval),
                  child: SlideTransition(
                    position: _slide(
                      startInterval,
                      endInterval,
                      begin: const Offset(0, 0.25),
                    ),
                    child: ProductCard(
                      product: mockProducts[i],
                      isLeft: i % 2 == 0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
