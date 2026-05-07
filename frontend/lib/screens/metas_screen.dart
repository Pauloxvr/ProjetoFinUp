import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/meta_model.dart';
import '../services/meta_service.dart';
import '../widgets/meta_card.dart';
import '../widgets/skeu_button.dart';

class MetasScreen extends StatefulWidget {
  const MetasScreen({super.key});

  @override
  State<MetasScreen> createState() => _MetasScreenState();
}

class _MetasScreenState extends State<MetasScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarMetas();
  }

  Future<void> _carregarMetas() async {
    setState(() => _loading = true);
    await MetaService.carregarMetas();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final metas = MetaService.metas;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Background decorativo
          _buildBackground(),

          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      /// Header
                      _buildHeader(),

                      /// Resumo de metas
                      _buildResumo(metas),

                      /// Lista de metas
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _carregarMetas,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: metas.length,
                            itemBuilder: (context, index) => MetaCard(
                              meta: metas[index],
                              onTap: () => _editarMeta(metas[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          /// FAB
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildAddButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.skyBlue.withOpacity(0.25),
                  AppTheme.skyBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.15),
                  AppTheme.primaryBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.blueShadow,
            ),
            child: const Icon(
              Icons.flag_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minhas Metas",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1e293b),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Acompanhe seus objetivos",
                  style: TextStyle(
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

  Widget _buildResumo(List<MetaModel> metas) {
    final totalMetas = metas.fold<double>(0, (sum, m) => sum + m.valorMeta);
    final totalAtual = metas.fold<double>(0, (sum, m) => sum + m.valorAtual);
    final progressoGeral = totalMetas > 0 ? totalAtual / totalMetas : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Progresso Geral",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${(progressoGeral * 100).toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
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
                        const Icon(
                          Icons.flag_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${metas.length} metas",
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
              const SizedBox(height: 18),
              // Barra de progresso
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: progressoGeral.clamp(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: const Offset(0, 0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "R\$ ${totalAtual.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "de R\$ ${totalMetas.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: SkeuButton(
        text: "Nova Meta",
        icon: Icons.add_rounded,
        onPressed: () => _criarMeta(context),
      ),
    );
  }

  Future<void> _criarMeta(BuildContext context) async {
    final tituloController = TextEditingController();
    final valorController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor Meta'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final titulo = tituloController.text;
              final valor = double.tryParse(valorController.text);
              if (titulo.isNotEmpty && valor != null && valor > 0) {
                await MetaService.criarMeta(titulo, valor);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editarMeta(MetaModel meta) async {
    final tituloController = TextEditingController(text: meta.titulo);
    final valorMetaController = TextEditingController(
      text: meta.valorMeta.toString(),
    );
    final valorAtualController = TextEditingController(
      text: meta.valorAtual.toString(),
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: valorMetaController,
              decoration: const InputDecoration(labelText: 'Valor Meta'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: valorAtualController,
              decoration: const InputDecoration(labelText: 'Valor Atual'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final titulo = tituloController.text;
              final valorMeta = double.tryParse(valorMetaController.text);
              final valorAtual = double.tryParse(valorAtualController.text);
              if (titulo.isNotEmpty && valorMeta != null && valorMeta > 0) {
                await MetaService.atualizarMeta(
                  meta.id,
                  titulo: titulo,
                  valorMeta: valorMeta,
                  valorAtual: valorAtual ?? meta.valorAtual,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
