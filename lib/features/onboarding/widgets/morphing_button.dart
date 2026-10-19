import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MorphingNeonButton extends StatefulWidget {
  const MorphingNeonButton({
    super.key,
    required this.onComplete,
    this.label = 'Get Started',
    this.icon = Icons.chevron_right_rounded,
    this.onValidate,
    this.backgroundColor,
    this.textColor,
    this.height = 54,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onComplete;
  final bool Function()? onValidate;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;

  @override
  State<MorphingNeonButton> createState() => _MorphingNeonButtonState();
}

class _MorphingNeonButtonState extends State<MorphingNeonButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_isLoading) return;

    if (widget.onValidate != null) {
      final isValid = widget.onValidate!();
      if (!isValid) return;
    }

    setState(() => _isLoading = true);
    _spinController.repeat();

    // Smooth spin duration
    await Future.delayed(const Duration(milliseconds: 1100));

    if (!mounted) return;
    widget.onComplete();

    if (mounted) {
      setState(() => _isLoading = false);
      _spinController.stop();
      _spinController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalHeight = widget.height;
    final circleSize = widget.height;

    final bgColor = widget.backgroundColor ?? Colors.white;
    final txtColor = widget.textColor ?? AppColors.primaryDark;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        height: normalHeight,
        width: _isLoading ? circleSize : MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          color: _isLoading ? const Color(0xFF1A030A) : bgColor,
          borderRadius: BorderRadius.circular(normalHeight / 2),
          border: _isLoading
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.7), width: 1.6)
              : null,
          boxShadow: [
            BoxShadow(
              color: _isLoading
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : Colors.black.withValues(alpha: 0.25),
              blurRadius: _isLoading ? 24 : 12,
              spreadRadius: _isLoading ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(normalHeight / 2),
            onTap: _isLoading ? null : _handleTap,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isLoading
                  ? _buildOrbitalSpinner(circleSize)
                  : _buildNormalContent(txtColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContent(Color txtColor) {
    return Row(
      key: const ValueKey('normal'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: txtColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        if (widget.icon != null) ...[
          const SizedBox(width: 8),
          Icon(
            widget.icon,
            color: txtColor,
            size: 20,
          ),
        ],
      ],
    );
  }

  Widget _buildOrbitalSpinner(double size) {
    return AnimatedBuilder(
      key: const ValueKey('spinner'),
      animation: _spinController,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating neon gradient sweep ring
            Transform.rotate(
              angle: _spinController.value * 2 * math.pi,
              child: CustomPaint(
                size: Size(size * 0.72, size * 0.72),
                painter: _NeonSweepPainter(
                  primaryColor: AppColors.primary,
                  accentColor: Colors.white,
                ),
              ),
            ),
            // Pulsing central audio beat core
            Transform.scale(
              scale: 0.85 + 0.15 * math.sin(_spinController.value * 2 * math.pi),
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.85),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Backwards compatibility alias for Onboarding
typedef MorphingGetStartedButton = MorphingNeonButton;

class _NeonSweepPainter extends CustomPainter {
  _NeonSweepPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  final Color primaryColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const strokeWidth = 3.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          primaryColor.withValues(alpha: 0.2),
          primaryColor,
          accentColor,
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0,
      2 * math.pi * 0.82,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
