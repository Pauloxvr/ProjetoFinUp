import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Botão skeuomorphic com efeito 3D e gradientes
class SkeuButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final SkeuButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const SkeuButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = SkeuButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
  });

  @override
  State<SkeuButton> createState() => _SkeuButtonState();
}

class _SkeuButtonState extends State<SkeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width ?? double.infinity,
        height: widget.height,
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 2.0 : 0.0),
        decoration: _getDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          child: Stack(
            children: [
              // Brilho superior
              if (!_isPressed)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: widget.height * 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.buttonRadius),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              // Conteúdo
              Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            _getTextColor(),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: _getTextColor(),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _getTextColor(),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (widget.variant) {
      case SkeuButtonVariant.primary:
        return BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          border: Border.all(
            color: Colors.white.withOpacity(_isPressed ? 0.1 : 0.3),
            width: 1,
          ),
          boxShadow: _isPressed ? AppTheme.pressedShadow : AppTheme.blueShadow,
        );
      case SkeuButtonVariant.secondary:
        return BoxDecoration(
          gradient: AppTheme.metallicGradient,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          border: Border.all(
            color: AppTheme.silverMist,
            width: 1,
          ),
          boxShadow: _isPressed ? AppTheme.pressedShadow : AppTheme.softShadow,
        );
      case SkeuButtonVariant.success:
        return BoxDecoration(
          gradient: AppTheme.successGradient,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          border: Border.all(
            color: Colors.white.withOpacity(_isPressed ? 0.1 : 0.3),
            width: 1,
          ),
          boxShadow: _isPressed
              ? AppTheme.pressedShadow
              : [
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                  ),
                ],
        );
      case SkeuButtonVariant.danger:
        return BoxDecoration(
          gradient: AppTheme.dangerGradient,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          border: Border.all(
            color: Colors.white.withOpacity(_isPressed ? 0.1 : 0.3),
            width: 1,
          ),
          boxShadow: _isPressed
              ? AppTheme.pressedShadow
              : [
                  BoxShadow(
                    color: AppTheme.dangerRed.withOpacity(0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                  ),
                ],
        );
      case SkeuButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed ? AppTheme.iceBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            width: 1.5,
          ),
        );
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case SkeuButtonVariant.primary:
      case SkeuButtonVariant.success:
      case SkeuButtonVariant.danger:
        return Colors.white;
      case SkeuButtonVariant.secondary:
        return AppTheme.deepBlue;
      case SkeuButtonVariant.ghost:
        return AppTheme.primaryBlue;
    }
  }
}

enum SkeuButtonVariant {
  primary,
  secondary,
  success,
  danger,
  ghost,
}
