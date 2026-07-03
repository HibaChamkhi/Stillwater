import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Loads an asset image, but falls back to a soft tinted tile when the file
/// isn't present yet — so the UI always renders cleanly.
class SoftImage extends StatelessWidget {
  const SoftImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.radius = 14,
  });

  final String asset;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => _Fallback(
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tan, AppColors.sage],
        ),
      ),
      child: const Center(
        child: Icon(Icons.spa_outlined, color: Colors.white70, size: 22),
      ),
    );
  }
}
