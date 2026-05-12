import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';
import '../widgets/skeu_card.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  int _filtroSelecionado = 0;
  final List<String> _filtros = ["Este mês", "3 meses", "6 meses", "Tudo"];

  @override
  Widget build(BuildContext context) {
    final lancamentoService = context.watch<LancamentoService>();
    final lancamentos = [
      ...lancamentoService.receitas,
      ...lancamentoService.despesas,
    ];
    lancamentos.sort((a, b) => b.data.compareTo(a.data));
    final lancamentosFiltrados = _filtrarLancamentos(lancamentos);
    
    final totalReceitas = lancamentosFiltrados
        .where((l) => l.isReceita)
        .fold<double>(0, (sum, l) => sum + l.valor);
    final totalDespesas = lancamentosFiltrados
        .where((l) => !l.isReceita)
        .fold<double>(0, (sum, l) => sum + l.valor);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              _buildHeader(),

              const SizedBox(height: 24),

              /// Resumo do período
              _buildResumoCard(totalReceitas, totalDespesas),

              const SizedBox(height: 20),

              /// Filtros
              _buildFiltros(),

              const SizedBox(height: 20),

              /// Lista de lançamentos
              Expanded(
                child: _buildListaLancamentos(lancamentosFiltrados),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        /// Ícone do histórico
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppTheme.blueShadow,
          ),
          child: const Icon(
            Icons.history_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Histórico",
              style: AppTheme.headingMedium,
            ),
            Text(
              "Todos os lançamentos",
              style: AppTheme.caption,
            ),
          ],
        ),
        const Spacer(),

        /// Botão de configurações
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.softWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.softShadow,
            border: Border.all(
              color: AppTheme.silverMist.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppTheme.coolGray,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildResumoCard(double receitas, double despesas) {
    final saldo = receitas - despesas;
    final isPositivo = saldo >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.pureWhite,
            AppTheme.iceBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.elevatedShadow,
        border: Border.all(
          color: AppTheme.paleBlue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          /// Título
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Resumo do período",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.coolGray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Valores
          Row(
            children: [
              /// Entradas
              Expanded(
                child: _buildResumoItem(
                  "Entradas",
                  receitas,
                  AppTheme.primaryBlue,
                  Icons.arrow_downward_rounded,
                ),
              ),

              /// Divider
              Container(
                width: 1,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.silverMist.withOpacity(0),
                      AppTheme.silverMist,
                      AppTheme.silverMist.withOpacity(0),
                    ],
                  ),
                ),
              ),

              /// Saídas
              Expanded(
                child: _buildResumoItem(
                  "Saídas",
                  despesas,
                  AppTheme.dangerRed,
                  Icons.arrow_upward_rounded,
                ),
              ),

              /// Divider
              Container(
                width: 1,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.silverMist.withOpacity(0),
                      AppTheme.silverMist,
                      AppTheme.silverMist.withOpacity(0),
                    ],
                  ),
                ),
              ),

              /// Saldo
              Expanded(
                child: _buildResumoItem(
                  "Saldo",
                  saldo.abs(),
                  isPositivo ? AppTheme.successGreen : AppTheme.dangerRed,
                  isPositivo ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  prefixo: isPositivo ? "+" : "-",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(
    String label,
    double valor,
    Color cor,
    IconData icon, {
    String prefixo = "",
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: cor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: cor, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.coolGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$prefixo R\$ ${valor.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltros() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filtros.length,
        itemBuilder: (context, index) {
          final isSelected = index == _filtroSelecionado;
          return GestureDetector(
            onTap: () => setState(() => _filtroSelecionado = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : AppTheme.softWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    isSelected ? AppTheme.blueShadow : AppTheme.softShadow,
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppTheme.silverMist.withOpacity(0.5),
                        width: 1,
                      ),
              ),
              child: Center(
                child: Text(
                  _filtros[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.coolGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaLancamentos(List<LancamentoModel> lancamentos) {
    if (lancamentos.isEmpty) {
      return SkeuCard(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.iceBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppTheme.lightBlue,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Nenhum lançamento",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.coolGray,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Seus lançamentos aparecerão aqui",
                style: AppTheme.caption,
              ),
            ],
          ),
        ),
      );
    }

    /// Agrupar por data
    final agrupados = _agruparPorData(lancamentos);

    return SkeuCard(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: agrupados.length,
        itemBuilder: (context, index) {
          final grupo = agrupados.entries.elementAt(index);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 20),

              /// Header da data
              _buildDataHeader(grupo.key),

              const SizedBox(height: 12),

              /// Lançamentos do dia
              ...grupo.value.map(
                (l) => _HistoricoItem(
                  lancamento: l,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      l.isReceita
                          ? AppRoutes.novaReceita
                          : AppRoutes.novaDespesa,
                      arguments: l,
                    );
                    await context
                        .read<LancamentoService>()
                        .carregarLancamentos();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<LancamentoModel>> _agruparPorData(
    List<LancamentoModel> lancamentos,
  ) {
    final mapa = <String, List<LancamentoModel>>{};
    for (final l in lancamentos) {
      final chave = _formatarDataGrupo(l.data);
      mapa.putIfAbsent(chave, () => []).add(l);
    }
    return mapa;
  }

  List<LancamentoModel> _filtrarLancamentos(List<LancamentoModel> lancamentos) {
    if (_filtroSelecionado == 3) return lancamentos;

    final now = DateTime.now();
    final start = switch (_filtroSelecionado) {
      0 => DateTime(now.year, now.month, 1),
      1 => DateTime(now.year, now.month - 2, 1),
      2 => DateTime(now.year, now.month - 5, 1),
      _ => DateTime(1900),
    };

    return lancamentos.where((l) {
      final data = DateTime(l.data.year, l.data.month, l.data.day);
      return !data.isBefore(start);
    }).toList();
  }

  String _formatarDataGrupo(DateTime data) {
    final hoje = DateTime.now();
    final ontem = hoje.subtract(const Duration(days: 1));

    if (_mesmaData(data, hoje)) return "Hoje";
    if (_mesmaData(data, ontem)) return "Ontem";

    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  bool _mesmaData(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDataHeader(String data) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTheme.lightBlue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          data,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.paleBlue,
                  AppTheme.paleBlue.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget de item do histórico
class _HistoricoItem extends StatelessWidget {
  final LancamentoModel lancamento;
  final VoidCallback? onTap;

  const _HistoricoItem({required this.lancamento, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isReceita = lancamento.isReceita;
    final cor = isReceita ? AppTheme.primaryBlue : AppTheme.dangerRed;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.softWhite,
            isReceita
                ? AppTheme.iceBlue.withOpacity(0.3)
                : const Color(0xFFFFF5F5),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isReceita
              ? AppTheme.paleBlue.withOpacity(0.5)
              : const Color(0xFFFFE0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
        child: Row(
        children: [
          /// Ícone
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cor.withOpacity(0.15),
                  cor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              isReceita
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: cor,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          /// Título e categoria
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lancamento.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlue,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lancamento.categoria ?? "Outros",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: cor,
                        ),
                      ),
                    ),
                    if (lancamento.parcelado) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warningAmber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 10,
                              color: AppTheme.warningAmber,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Parcelado",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.warningAmber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          /// Valor
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isReceita
                      ? [AppTheme.primaryBlue, AppTheme.lightBlue]
                      : [AppTheme.dangerRed, const Color(0xFFFF6B6B)],
                ).createShader(bounds),
                child: Text(
                  "${isReceita ? '+' : '-'} R\$ ${lancamento.valor.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatarHora(lancamento.data),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.coolGray,
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  String _formatarHora(DateTime data) {
    return "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
  }
}

