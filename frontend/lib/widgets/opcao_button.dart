import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class OpcaoButton extends StatefulWidget {
  final IconData icon;
  final String texto;
  final VoidCallback onTap;
  final Color? iconColor;

  const OpcaoButton({
    super.key,
    required this.icon,
    required this.texto,
    required this.onTap,
    this.iconColor,
  });

  @override
  State<OpcaoButton> createState() => _OpcaoButtonState();
}

class _OpcaoButtonState extends State<OpcaoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 2.0 : 0.0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: _isPressed
              ? const LinearGradient(
                  colors: [Color(0xfff0f4f8), Color(0xffe8ecf5)],
                )
              : AppTheme.cardLightGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(_isPressed ? 0.5 : 0.8),
            width: 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Brilho no topo
            if (!_isPressed)
              Positioned(
                top: -18,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (widget.iconColor ?? AppTheme.primaryBlue)
                            .withOpacity(0.15),
                        (widget.iconColor ?? AppTheme.primaryBlue)
                            .withOpacity(0.25),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: (widget.iconColor ?? AppTheme.primaryBlue)
                          .withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor ?? AppTheme.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.texto,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff334155),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.iceBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
