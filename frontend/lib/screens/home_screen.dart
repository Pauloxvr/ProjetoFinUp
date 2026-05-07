import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/lancamento_service.dart';
import '../services/auth_service.dart';
import '../widgets/saldo_card.dart';
import '../widgets/resumo_card.dart';
import '../widgets/opcao_button.dart';
import '../widgets/grafico_pizza.dart';
import '../widgets/grafico_barras.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _loading = true);
    await LancamentoService.carregarLancamentos();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xfff8fafc),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double saldo = LancamentoService.saldo;
    final double entradaMes = LancamentoService.totalReceitas;
    final double saidaMes = LancamentoService.totalDespesas;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregarDados,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header skeuomorphic
                _buildHeader(context),

                const SizedBox(height: 28),

                /// Saudação
                Text(
                  "Olá, ${AuthService.nome}!",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1e293b),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Acompanhe suas finanças",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff64748b),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                /// Card de Saldo
                SaldoCard(saldo: saldo),

                const SizedBox(height: 20),

                /// Entrada / Saída
                Row(
                  children: [
                    Expanded(
                      child: ResumoCard(
                        titulo: "Entrada no mês",
                        valor: entradaMes,
                        cor: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ResumoCard(
                        titulo: "Saída no mês",
                        valor: saidaMes,
                        cor: AppTheme.dangerRed,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                /// Seção de ações rápidas
                const Text(
                  "Ações Rápidas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1e293b),
                  ),
                ),
                const SizedBox(height: 16),

                OpcaoButton(
                  icon: Icons.add_circle_outline_rounded,
                  texto: "Nova Receita",
                  iconColor: const Color(0xff22c55e),
                  onTap: () async {
                    await Navigator.pushNamed(context, AppRoutes.novaReceita);
                    _carregarDados();
                  },
                ),
                const SizedBox(height: 12),

                OpcaoButton(
                  icon: Icons.remove_circle_outline_rounded,
                  texto: "Nova Despesa",
                  iconColor: const Color(0xffef4444),
                  onTap: () async {
                    await Navigator.pushNamed(context, AppRoutes.novaDespesa);
                    _carregarDados();
                  },
                ),
                const SizedBox(height: 12),

                OpcaoButton(
                  icon: Icons.flag_rounded,
                  texto: "Minhas Metas",
                  iconColor: AppTheme.primaryBlue,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.metas),
                ),

                const SizedBox(height: 32),

                /// Seção de análises
                const Text(
                  "Análises",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1e293b),
                  ),
                ),

                const SizedBox(height: 8),

                /// Gráfico pizza — receitas vs despesas
                GraficoPizza(
                  receitas: entradaMes,
                  despesas: saidaMes,
                ),

                /// Gráfico barras — despesas por categoria
                GraficoBarras(
                  titulo: "Despesas por categoria",
                  lancamentos: LancamentoService.getDespesas(),
                  corBarra: const Color(0xffef4444),
                ),

                /// Gráfico barras — receitas por categoria
                GraficoBarras(
                  titulo: "Receitas por categoria",
                  lancamentos: LancamentoService.getReceitas(),
                  corBarra: AppTheme.primaryBlue,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo/Título com ícone
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: AppTheme.cardLightGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1,
            ),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1e293b),
                ),
              ),
            ],
          ),
        ),
        // Avatar do usuário
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: AppTheme.blueShadow,
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.cardLightGradient,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  AuthService.iniciais,
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
