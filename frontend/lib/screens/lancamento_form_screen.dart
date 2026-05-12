import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';
import '../services/categoria_service.dart';
import '../services/api_service.dart';
import '../widgets/skeu_input.dart';
import '../widgets/skeu_button.dart';

class LancamentoFormScreen extends StatefulWidget {
  final String titulo;
  final String textoBotao;
  final TipoLancamento tipo;

  const LancamentoFormScreen({
    super.key,
    required this.titulo,
    required this.textoBotao,
    required this.tipo,
  });

  @override
  State<LancamentoFormScreen> createState() => _LancamentoFormScreenState();
}

class _LancamentoFormScreenState extends State<LancamentoFormScreen> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  Categoria? _categoriaSelecionada;
  LancamentoModel? _lancamentoEditando;
  bool _parcelado = false;
  bool _loading = true;
  bool _initializedArgs = false;

  bool get _isReceita => widget.tipo == TipoLancamento.receita;
  bool get _isEditing => _lancamentoEditando != null;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializedArgs) return;
    _initializedArgs = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LancamentoModel) {
      _lancamentoEditando = args;
      _valorController.text = args.valor.toStringAsFixed(2);
      _descricaoController.text = args.titulo;
      _dataSelecionada = args.data;
      _parcelado = args.parcelado;
    }
  }

  Future<void> _carregarCategorias() async {
    try {
      await CategoriaService.carregarCategorias();
    } on ApiException catch (e) {
      _showSnackbar(e.message);
    } catch (_) {
      _showSnackbar("Erro ao carregar categorias");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),

                /// Conteúdo scrollável
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        /// Card do formulário
                        _buildFormCard(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              (_isReceita ? AppTheme.primaryBlue : AppTheme.dangerRed)
                  .withOpacity(0.15),
              (_isReceita ? AppTheme.primaryBlue : AppTheme.dangerRed)
                  .withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppTheme.cardLightGradient,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 1,
                ),
                boxShadow: AppTheme.softShadow,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(13),
                        ),
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
                  const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xff475569),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _isEditing ? "Editar lançamento" : widget.titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xff1e293b),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categorias = _isReceita
        ? CategoriaService.getCategoriasReceita()
        : CategoriaService.getCategoriasDespesa();
    if (_categoriaSelecionada == null && _lancamentoEditando?.categoriaId != null) {
      for (final categoria in categorias) {
        if (categoria.id == _lancamentoEditando!.categoriaId) {
          _categoriaSelecionada = categoria;
          break;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardLightGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
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
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Ícone do tipo
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: _isReceita
                        ? AppTheme.primaryGradient
                        : AppTheme.dangerGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (_isReceita
                                ? AppTheme.primaryBlue
                                : AppTheme.dangerRed)
                            .withOpacity(0.35),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 28,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
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
                      Center(
                        child: Icon(
                          _isReceita
                              ? Icons.add_circle_rounded
                              : Icons.remove_circle_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// Valor
              SkeuInput(
                label: "Valor",
                hint: "R\$ 0,00",
                controller: _valorController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  Icons.attach_money_rounded,
                  color: Color(0xff94a3b8),
                  size: 22,
                ),
              ),

              const SizedBox(height: 20),

              /// Descrição
              SkeuInput(
                label: "Descrição",
                hint: "Ex: Supermercado, Conta de Luz...",
                controller: _descricaoController,
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
              ),

              const SizedBox(height: 20),

              /// Categoria
              SkeuDropdown<Categoria>(
                label: "Categoria",
                hint: "Selecionar categoria",
                value: _categoriaSelecionada,
                items: categorias
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _categoriaSelecionada = value);
                },
              ),

              const SizedBox(height: 20),

              /// Data
              _buildDatePicker(),

              const SizedBox(height: 24),

              /// Parcelado
              _buildParceladoSwitch(),

              const SizedBox(height: 32),

              /// Botão salvar
              SkeuButton(
                text: _isEditing ? "Salvar Alterações" : widget.textoBotao,
                icon: Icons.check_rounded,
                variant: _isReceita
                    ? SkeuButtonVariant.primary
                    : SkeuButtonVariant.danger,
                onPressed: _salvar,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _selecionarData,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xfff1f5f9),
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              border: Border.all(
                color: const Color(0xffe2e8f0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  "${_dataSelecionada.day.toString().padLeft(2, '0')}/"
                  "${_dataSelecionada.month.toString().padLeft(2, '0')}/"
                  "${_dataSelecionada.year}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1e293b),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.iceBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_calendar_rounded,
                    color: AppTheme.primaryBlue,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParceladoSwitch() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _parcelado ? AppTheme.iceBlue : const Color(0xfff8fafc),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _parcelado
              ? AppTheme.primaryBlue.withOpacity(0.3)
              : const Color(0xffe2e8f0),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: _parcelado
                      ? AppTheme.primaryGradient
                      : const LinearGradient(
                          colors: [Color(0xffe2e8f0), Color(0xffd1d5db)],
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Parcelado?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff334155),
                    ),
                  ),
                  Text(
                    _parcelado ? "Sim, é parcelado" : "Não, à vista",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff94a3b8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildSkeuSwitch(),
        ],
      ),
    );
  }

  Widget _buildSkeuSwitch() {
    return GestureDetector(
      onTap: () => setState(() => _parcelado = !_parcelado),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 34,
        decoration: BoxDecoration(
          gradient: _parcelado
              ? AppTheme.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xffe2e8f0), Color(0xffd1d5db)],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _parcelado
                ? Colors.white.withOpacity(0.3)
                : const Color(0xffd1d5db),
            width: 1,
          ),
          boxShadow: _parcelado
              ? AppTheme.blueShadow
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              left: _parcelado ? 28 : 4,
              top: 4,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 2,
                      left: 2,
                      right: 2,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(13),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.8),
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
    );
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _isReceita ? AppTheme.primaryBlue : AppTheme.dangerRed,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dataSelecionada = picked);
    }
  }

  void _salvar() async {
    final valorTexto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto);

    if (valor == null || valor <= 0) {
      _showSnackbar("Informe um valor válido");
      return;
    }

    if (_categoriaSelecionada == null) {
      _showSnackbar("Selecione uma categoria");
      return;
    }

    final lancamento = LancamentoModel(
      id: _lancamentoEditando?.id ?? 0,
      titulo: _descricaoController.text.isNotEmpty
          ? _descricaoController.text
          : _categoriaSelecionada!.name,
      valor: valor,
      data: _dataSelecionada,
      tipo: widget.tipo,
      categoriaId: _categoriaSelecionada!.id,
      categoriaNome: _categoriaSelecionada!.name,
    );

    try {
      if (widget.tipo == TipoLancamento.receita) {
        if (_isEditing) {
          await context.read<LancamentoService>().atualizarReceita(lancamento);
        } else {
          await context.read<LancamentoService>().adicionarReceita(lancamento);
        }
      } else {
        if (_isEditing) {
          await context.read<LancamentoService>().atualizarDespesa(lancamento);
        } else {
          await context.read<LancamentoService>().adicionarDespesa(lancamento);
        }
      }
      if (!mounted) return;
      Navigator.pop(context);
    } on ApiException catch (e) {
      _showSnackbar(e.message);
    } catch (_) {
      _showSnackbar("Erro ao salvar");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xff1e293b),
      ),
    );
  }
}

