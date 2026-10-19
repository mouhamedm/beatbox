import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/mock_products.dart';
import '../home/home_screen.dart';
import '../onboarding/widgets/morphing_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hasEmailError = false;
  bool _hasNameError = false;
  bool _hasPasswordError = false;

  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    bool hasError = false;

    if (email.isEmpty) {
      _hasEmailError = true;
      hasError = true;
    } else {
      _hasEmailError = false;
    }

    if (_isSignUp && name.isEmpty) {
      _hasNameError = true;
      hasError = true;
    } else {
      _hasNameError = false;
    }

    if (password.isEmpty) {
      _hasPasswordError = true;
      hasError = true;
    } else {
      _hasPasswordError = false;
    }

    if (hasError) {
      setState(() {});
      _shakeController.forward(from: 0.0);
      return false;
    }

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 750),
        pageBuilder: (_, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140207),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Section: Image of the man with headphones
              SizedBox(
                height: 270,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      onboardingImage,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.35),
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF4A0612),
                        child: const Icon(Icons.headphones_rounded, size: 80, color: Colors.white24),
                      ),
                    ),
                    // Gradient overlay to blend image into the dark card
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                            const Color(0xFF140207).withValues(alpha: 0.75),
                            const Color(0xFF140207),
                          ],
                          stops: const [0.0, 0.35, 0.8, 1.0],
                        ),
                      ),
                    ),
                    // Top buttons: Back & Skip
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlassContainer(
                              padding: const EdgeInsets.all(10),
                              radius: 20,
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: _navigateToHome,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. The Form Card (overlaps the gradient seamlessly)
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A030A),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 24,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drag handle pill
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Segmented control: Sign In / Sign Up
                      Container(
                        height: 46,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 0.6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSignUp = false;
                                    _hasNameError = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    gradient: !_isSignUp ? AppColors.buttonGradient : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: !_isSignUp ? Colors.white : Colors.white60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isSignUp = true),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    gradient: _isSignUp ? AppColors.buttonGradient : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _isSignUp ? Colors.white : Colors.white60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _isSignUp ? 'Create your account' : 'Welcome to Beatbox',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isSignUp
                            ? 'Sign up to discover the ultimate sound experience'
                            : 'Enter your credentials to continue listening',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // Animated Shake wrapper for inputs
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          final offset = math.sin(_shakeController.value * math.pi * 6) * 8;
                          return Transform.translate(
                            offset: Offset(offset, 0),
                            child: child,
                          );
                        },
                        child: Column(
                          children: [
                            // Name field (in Sign Up mode)
                            if (_isSignUp) ...[
                              _inputField(
                                controller: _nameController,
                                icon: Icons.person_outline_rounded,
                                hint: 'Full Name',
                                hasError: _hasNameError,
                                onChanged: (val) {
                                  if (_hasNameError && val.trim().isNotEmpty) {
                                    setState(() => _hasNameError = false);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Email field
                            _inputField(
                              controller: _emailController,
                              icon: Icons.alternate_email_rounded,
                              hint: 'Email address',
                              keyboardType: TextInputType.emailAddress,
                              hasError: _hasEmailError,
                              onChanged: (val) {
                                if (_hasEmailError && val.trim().isNotEmpty) {
                                  setState(() => _hasEmailError = false);
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Password field
                            _inputField(
                              controller: _passwordController,
                              icon: Icons.lock_outline_rounded,
                              hint: 'Password',
                              obscureText: _obscurePassword,
                              hasError: _hasPasswordError,
                              onChanged: (val) {
                                if (_hasPasswordError && val.trim().isNotEmpty) {
                                  setState(() => _hasPasswordError = false);
                                }
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white60,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Remember me / Forgot password
                      if (!_isSignUp)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _rememberMe = !_rememberMe),
                              child: Row(
                                children: [
                                  Icon(
                                    _rememberMe
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 18,
                                    color: _rememberMe ? AppColors.primary : Colors.white38,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Remember me',
                                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(fontSize: 12, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 22),

                      // Morphing Neon Continue Button
                      MorphingNeonButton(
                        label: 'Continue',
                        icon: Icons.arrow_forward_rounded,
                        onValidate: _validateForm,
                        onComplete: _navigateToHome,
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.white12)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: Colors.white12)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.g_mobiledata_rounded, 'Google', _navigateToHome),
                          const SizedBox(width: 14),
                          _socialButton(Icons.apple_rounded, 'Apple', _navigateToHome),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _navigateToHome,
                        child: const Text(
                          'Continue as Guest',
                          style: TextStyle(fontSize: 13, color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool hasError,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError ? const Color(0xFFFF2A55) : AppColors.border,
          width: hasError ? 1.6 : 0.6,
        ),
        boxShadow: hasError
            ? [
                BoxShadow(
                  color: const Color(0xFFFF2A55).withValues(alpha: 0.35),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: hasError ? const Color(0xFFFF2A55) : Colors.white60,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(
            color: hasError
                ? const Color(0xFFFF7A95)
                : Colors.white.withValues(alpha: 0.38),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, VoidCallback onTap) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      radius: 14,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
