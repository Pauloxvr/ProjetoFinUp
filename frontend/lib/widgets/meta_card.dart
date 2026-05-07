import 'package:flutter/material.dart';
import '../models/meta_model.dart';
import '../core/app_theme.dart';

class MetaCard extends StatelessWidget {
  final MetaModel meta;
  final VoidCallback? onTap;

  const MetaCard({
    super.key,
    required this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progresso = meta.progresso.clamp(0.0, 1.0);
    final cor = _getCorProgresso(progresso);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: AppTheme.cardLightGradient,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Stack(
            children: [
              // Brilho superior
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 60,
                child: Container(
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
              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Ícone com estilo skeuomorphic
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                cor.withOpacity(0.15),
                                cor.withOpacity(0.25),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cor.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: cor.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              meta.icone,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meta.titulo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1e293b),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "R\$ ${meta.valorAtual.toStringAsFixed(2)} de R\$ ${meta.valorMeta.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xff64748b),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Badge de porcentagem
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cor, cor.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: cor.withOpacity(0.35),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            "${meta.porcentagem}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barra de progresso skeuomorphic
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xffe2e8f0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            spreadRadius: -1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Progresso com gradiente
                          FractionallySizedBox(
                            widthFactor: progresso,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    cor.withOpacity(0.8),
                                    cor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: cor.withOpacity(0.4),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Brilho no topo da barra
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    height: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(10),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Quanto falta
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Faltam R\$ ${(meta.valorMeta - meta.valorAtual).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff94a3b8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: cor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Ver detalhes",
                              style: TextStyle(
                                fontSize: 12,
                                color: cor,
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
            ],
          ),
        ),
      ),
    );
  }

  Color _getCorProgresso(double progresso) {
    if (progresso >= 1.0) return const Color(0xff22c55e);
    if (progresso >= 0.7) return AppTheme.primaryBlue;
    if (progresso >= 0.4) return const Color(0xfffbbf24);
    return const Color(0xffef4444);
  }
}
