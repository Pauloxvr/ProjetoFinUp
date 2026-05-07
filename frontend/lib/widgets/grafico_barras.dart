import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';

class GraficoBarras extends StatefulWidget {
  final String titulo;
  final List<LancamentoModel> lancamentos;
  final Color corBarra;

  const GraficoBarras({
    super.key,
    required this.titulo,
    required this.lancamentos,
    this.corBarra = AppTheme.primaryBlue,
  });

  @override
  State<GraficoBarras> createState() => _GraficoBarrasState();
}

class _GraficoBarrasState extends State<GraficoBarras> {
  int _touchedIndex = -1;

  Map<String, double> get _dadosPorCategoria {
    final mapa = <String, double>{};
    for (final l in widget.lancamentos) {
      final cat = l.categoria ?? "Outros";
      mapa[cat] = (mapa[cat] ?? 0) + l.valor;
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    final dados = _dadosPorCategoria;
    final categorias = dados.keys.toList();
    final valores = dados.values.toList();
    final maxValor =
        valores.isEmpty ? 100.0 : valores.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.corBarra.withOpacity(0.8),
                          widget.corBarra,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: widget.corBarra.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1e293b),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 220,
                child: categorias.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
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
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxValor * 1.25,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.spot == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex =
                                    response.spot!.touchedBarGroupIndex;
                              });
                            },
                            touchTooltipData: BarTouchTooltipData(
                              tooltipRoundedRadius: 12,
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              tooltipMargin: 8,
                              getTooltipColor: (group) =>
                                  const Color(0xff1e293b),
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  "${categorias[groupIndex]}\n",
                                  const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "R\$ ${rod.toY.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 55,
                                getTitlesWidget: (value, meta) {
                                  if (value == 0) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      _formatarValor(value),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xff94a3b8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 42,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= categorias.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final label = categorias[idx].length > 7
                                      ? "${categorias[idx].substring(0, 7)}."
                                      : categorias[idx];
                                  final isSelected = _touchedIndex == idx;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected
                                            ? widget.corBarra
                                            : const Color(0xff94a3b8),
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxValor / 4,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: const Color(0xffe2e8f0),
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(categorias.length, (i) {
                            final isSelected = _touchedIndex == i;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: valores[i],
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      widget.corBarra,
                                      widget.corBarra.withOpacity(0.7),
                                    ],
                                  ),
                                  width: isSelected
                                      ? 26
                                      : (categorias.length <= 3 ? 24 : 18),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: maxValor * 1.25,
                                    color: const Color(0xfff1f5f9),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
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
}
