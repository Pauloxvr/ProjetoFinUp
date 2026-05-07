import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ResumoCard extends StatelessWidget {
  final String titulo;
  final double valor;
  final Color cor;

  const ResumoCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.cor,
  });

  bool get _isReceita => cor == Colors.blue || cor == AppTheme.primaryBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.cardLightGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isReceita
              ? AppTheme.paleBlue.withOpacity(0.6)
              : Colors.red.shade100.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isReceita ? AppTheme.primaryBlue : Colors.red)
                .withOpacity(0.12),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Brilho superior
          Positioned(
            top: -18,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: _isReceita
                          ? const LinearGradient(
                              colors: [
                                Color(0xff60a5fa),
                                Color(0xff3b82f6),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xfffca5a5),
                                Color(0xffef4444),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: (_isReceita ? Colors.blue : Colors.red)
                              .withOpacity(0.3),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isReceita
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff64748b),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: _isReceita
                      ? [const Color(0xff1e40af), const Color(0xff3b82f6)]
                      : [const Color(0xffb91c1c), const Color(0xffef4444)],
                ).createShader(bounds),
                child: Text(
                  "R\$ ${valor.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
