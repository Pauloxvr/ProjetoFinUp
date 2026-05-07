import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class GraficoPizza extends StatefulWidget {
  final double receitas;
  final double despesas;

  const GraficoPizza({
    super.key,
    required this.receitas,
    required this.despesas,
  });

  @override
  State<GraficoPizza> createState() => _GraficoPizzaState();
}

class _GraficoPizzaState extends State<GraficoPizza> {
  int _touchedIndex = -1;

  double get _total => widget.receitas + widget.despesas;

  @override
  Widget build(BuildContext context) {
    final semDados = _total == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardLightGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Stack(
        children: [
          // Brilho superior
          Positioned(
            top: -24,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.cardRadius),
                ),
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
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.skyBlue, AppTheme.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pie_chart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Receitas vs Despesas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1e293b),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 200,
                child: semDados
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_rounded,
                              size: 48,
                              color: AppTheme.coolGray,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Sem dados ainda",
                              style: TextStyle(
                                color: Color(0xff94a3b8),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Sombra do gráfico
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 8),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                          ),
                          PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSection == null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex = response
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              sectionsSpace: 4,
                              centerSpaceRadius: 50,
                              sections: _buildSections(),
                            ),
                          ),
                          // Centro com efeito glass
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.7),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xff64748b),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatarValor(_total),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff1e293b),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              // Legendas com estilo skeuomorphic
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Legenda(
                    cor: AppTheme.primaryBlue,
                    texto: "Receitas",
                    valor: widget.receitas,
                    isSelected: _touchedIndex == 0,
                  ),
                  const SizedBox(width: 24),
                  _Legenda(
                    cor: const Color(0xffef4444),
                    texto: "Despesas",
                    valor: widget.despesas,
                    isSelected: _touchedIndex == 1,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatarValor(double valor) {
    if (valor >= 1000) {
      return "R\$ ${(valor / 1000).toStringAsFixed(1)}k";
    }
    return "R\$ ${valor.toStringAsFixed(0)}";
  }

  List<PieChartSectionData> _buildSections() {
    final pctReceitas = widget.receitas / _total * 100;
    final pctDespesas = widget.despesas / _total * 100;

    return [
      PieChartSectionData(
        value: widget.receitas,
        color: AppTheme.primaryBlue,
        radius: _touchedIndex == 0 ? 60 : 52,
        title: "${pctReceitas.toStringAsFixed(0)}%",
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: _touchedIndex == 0 ? 15 : 13,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        badgePositionPercentageOffset: 1.1,
      ),
      PieChartSectionData(
        value: widget.despesas,
        color: const Color(0xffef4444),
        radius: _touchedIndex == 1 ? 60 : 52,
        title: "${pctDespesas.toStringAsFixed(0)}%",
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: _touchedIndex == 1 ? 15 : 13,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ];
  }
}

class _Legenda extends StatelessWidget {
  final Color cor;
  final String texto;
  final double valor;
  final bool isSelected;

  const _Legenda({
    required this.cor,
    required this.texto,
    required this.valor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? cor.withOpacity(0.1) : AppTheme.iceBlue,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? cor.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: cor.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cor.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texto,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? cor : const Color(0xff475569),
                ),
              ),
              Text(
                "R\$ ${valor.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? cor.withOpacity(0.8) : const Color(0xff94a3b8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
