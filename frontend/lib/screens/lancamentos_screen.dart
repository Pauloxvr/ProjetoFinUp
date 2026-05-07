import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';
import '../widgets/grafico_barras.dart';

class LancamentosScreen extends StatelessWidget {
  final TipoLancamento tipo;

  const LancamentosScreen({super.key, required this.tipo});

  bool get _isReceita => tipo == TipoLancamento.receita;

  String get _titulo => _isReceita ? "Entradas" : "Despesas";

  String get _grafTitulo =>
      _isReceita ? "Entradas do mês" : "Despesas do mês";

  List<LancamentoModel> get _lancamentos => _isReceita
      ? LancamentoService.getReceitas()
      : LancamentoService.getDespesas();

  Color get _corTema =>
      _isReceita ? AppTheme.primaryBlue : const Color(0xffef4444);

  @override
  Widget build(BuildContext context) {
    final lancamentos = _lancamentos;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Background decorativo
          _buildBackground(),

          SafeArea(
            child: Column(
              children: [
                /// Header
                _buildHeader(context),

                /// Conteúdo
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Column(
                      children: [
                        /// Resumo
                        _buildResumo(lancamentos),

                        const SizedBox(height: 20),

                        /// Lista de lançamentos
                        _buildLancamentosList(lancamentos),

                        /// Gráfico de barras
                        GraficoBarras(
                          titulo: _grafTitulo,
                          lancamentos: lancamentos,
                          corBarra: _corTema,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// FAB
          Positioned(
            bottom: 30,
            right: 20,
            child: _buildFab(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      top: -80,
      right: -60,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              _corTema.withOpacity(0.15),
              _corTema.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: _isReceita
                  ? AppTheme.primaryGradient
                  : AppTheme.dangerGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _corTema.withOpacity(0.35),
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Icon(
              _isReceita
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titulo,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1e293b),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  _isReceita ? "Suas receitas" : "Seus gastos",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff64748b),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumo(List<LancamentoModel> lancamentos) {
    final total = lancamentos.fold<double>(0, (sum, l) => sum + l.valor);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _isReceita
            ? AppTheme.primaryGradient
            : AppTheme.dangerGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _corTema.withOpacity(0.35),
            offset: const Offset(0, 10),
            blurRadius: 25,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decoração
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Brilho
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isReceita ? "Total de Entradas" : "Total de Saídas",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "R\$ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isReceita
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${lancamentos.length} itens",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLancamentosList(List<LancamentoModel> lancamentos) {
    return Container(
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
              height: 50,
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
            lancamentos.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            _isReceita
                                ? Icons.add_circle_outline_rounded
                                : Icons.remove_circle_outline_rounded,
                            size: 48,
                            color: AppTheme.coolGray,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Nenhum lançamento ainda",
                            style: TextStyle(
                              color: Color(0xff94a3b8),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (int i = 0; i < lancamentos.length; i++) ...[
                        _LancamentoItem(
                          lancamento: lancamentos[i],
                          corTema: _corTema,
                        ),
                        if (i < lancamentos.length - 1)
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: AppTheme.silverMist.withOpacity(0.5),
                          ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          _isReceita ? AppRoutes.novaReceita : AppRoutes.novaDespesa,
        );
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: _isReceita
              ? AppTheme.primaryGradient
              : AppTheme.dangerGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _corTema.withOpacity(0.4),
              offset: const Offset(0, 8),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Brilho
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 26,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(19),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            const Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LancamentoItem extends StatelessWidget {
  final LancamentoModel lancamento;
  final Color corTema;

  const _LancamentoItem({
    required this.lancamento,
    required this.corTema,
  });

  @override
  Widget build(BuildContext context) {
    final isReceita = lancamento.isReceita;
    final dataFormatada =
        "${lancamento.data.day.toString().padLeft(2, '0')}/"
        "${lancamento.data.month.toString().padLeft(2, '0')}/"
        "${lancamento.data.year}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Ícone com categoria
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  corTema.withOpacity(0.15),
                  corTema.withOpacity(0.25),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: corTema.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                isReceita
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: corTema,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lancamento.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1e293b),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (lancamento.categoria != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.iceBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lancamento.categoria!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      dataFormatada,
                      style: const TextStyle(
                        color: Color(0xff94a3b8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "${isReceita ? "+" : "-"} R\$ ${lancamento.valor.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: corTema,
            ),
          ),
        ],
      ),
    );
  }
}
