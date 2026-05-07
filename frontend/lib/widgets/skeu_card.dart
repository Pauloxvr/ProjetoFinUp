import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Card skeuomorphic com múltiplas variantes
class SkeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final SkeuCardVariant variant;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const SkeuCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.variant = SkeuCardVariant.elevated,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: _getDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Stack(
            children: [
              // Conteúdo principal
              Padding(
                padding: padding ?? const EdgeInsets.all(20),
                child: child,
              ),
              // Brilho no topo (efeito de luz)
              if (variant != SkeuCardVariant.flat)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppTheme.cardRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (variant) {
      case SkeuCardVariant.elevated:
        return BoxDecoration(
          gradient: AppTheme.cardLightGradient,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: AppTheme.elevatedShadow,
        );
      case SkeuCardVariant.blue:
        return BoxDecoration(
          gradient: AppTheme.cardLightGradient,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: AppTheme.paleBlue,
            width: 1.5,
          ),
          boxShadow: AppTheme.blueShadow,
        );
      case SkeuCardVariant.glass:
        return BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: AppTheme.softShadow,
        );
      case SkeuCardVariant.flat:
        return BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: AppTheme.silverMist,
            width: 1,
          ),
        );
      case SkeuCardVariant.premium:
        return BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: AppTheme.blueShadow,
        );
    }
  }
}

enum SkeuCardVariant {
  elevated,
  blue,
  glass,
  flat,
  premium,
}
