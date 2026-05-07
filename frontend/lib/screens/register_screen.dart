import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import '../services/lancamento_service.dart';
import '../services/api_service.dart';
import '../widgets/skeu_input.dart';
import '../widgets/skeu_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Fundo decorativo
          _buildBackground(),

          /// Botão voltar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: _buildBackButton(),
          ),

          /// Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    /// Título
                    _buildHeader(),

                    const SizedBox(height: 40),

                    /// Card de cadastro
                    _buildRegisterCard(),

                    const SizedBox(height: 30),

                    /// Link para login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Já tem uma conta? ",
                          style: TextStyle(
                            color: Color(0xff64748b),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Entrar",
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.lightBlue.withOpacity(0.3),
                  AppTheme.lightBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 280,
            height: 280,
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

  Widget _buildBackButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppTheme.successGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.successGreen.withOpacity(0.4),
                offset: const Offset(0, 10),
                blurRadius: 25,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 30,
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
              const Center(
                child: Icon(
                  Icons.person_add_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Criar Conta",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xff1e293b),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Preencha os dados abaixo para começar",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff64748b),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.all(28),
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
          Positioned(
            top: -28,
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
              /// Nome
              SkeuInput(
                label: "Nome Completo",
                hint: "João Silva",
                controller: _nomeController,
                prefixIcon: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
              ),
              const SizedBox(height: 20),

              /// Email
              SkeuInput(
                label: "Email",
                hint: "seu@email.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
              ),
              const SizedBox(height: 20),

              /// Senha
              SkeuInput(
                label: "Senha",
                hint: "Mínimo 6 caracteres",
                controller: _senhaController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
              ),
              const SizedBox(height: 20),

              /// Termos
              Row(
                children: [
                  _buildSkeuCheckbox(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xff64748b),
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(text: "Concordo com os "),
                          TextSpan(
                            text: "Termos de Uso",
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: " e "),
                          TextSpan(
                            text: "Política de Privacidade",
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Botão cadastrar
              SkeuButton(
                text: "Criar Conta",
                icon: Icons.check_rounded,
                variant: SkeuButtonVariant.success,
                onPressed: _fazerCadastro,
              ),

              const SizedBox(height: 28),

              /// Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppTheme.silverMist,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ou cadastre-se com",
                      style: TextStyle(
                        color: Color(0xff94a3b8),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppTheme.silverMist,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.g_mobiledata, const Color(0xffea4335)),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.apple, const Color(0xff1e293b)),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.facebook, const Color(0xff1877f2)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeuCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _agreeTerms = !_agreeTerms),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          gradient: _agreeTerms
              ? AppTheme.successGradient
              : const LinearGradient(
                  colors: [Color(0xfff1f5f9), Color(0xffe2e8f0)],
                ),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: _agreeTerms
                ? Colors.white.withOpacity(0.3)
                : const Color(0xffe2e8f0),
            width: 1.5,
          ),
          boxShadow: _agreeTerms
              ? [
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: _agreeTerms
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppTheme.cardLightGradient,
        borderRadius: BorderRadius.circular(16),
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
            height: 24,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
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
          Center(
            child: Icon(icon, color: color, size: 28),
          ),
        ],
      ),
    );
  }

  void _fazerCadastro() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _showSnackbar("Preencha todos os campos");
      return;
    }

    if (!_agreeTerms) {
      _showSnackbar("Aceite os termos para continuar");
      return;
    }

    try {
      await AuthService.register(nome: nome, email: email, password: senha);
      await LancamentoService.carregarLancamentos();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } on ApiException catch (e) {
      _showSnackbar(e.message);
    } catch (_) {
      _showSnackbar("Erro ao cadastrar");
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
