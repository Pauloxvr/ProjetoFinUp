import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import '../services/lancamento_service.dart';
import '../services/api_service.dart';
import '../widgets/skeu_input.dart';
import '../widgets/skeu_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Fundo decorativo com gradiente e círculos
          _buildBackground(),

          /// Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    /// Logo/Ícone do app
                    _buildLogo(),

                    const SizedBox(height: 50),

                    /// Card de login skeuomorphic
                    _buildLoginCard(),

                    const SizedBox(height: 30),

                    /// Link para registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Não tem uma conta? ",
                          style: TextStyle(
                            color: Color(0xff64748b),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.register,
                          ),
                          child: const Text(
                            "Cadastre-se",
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
        // Gradiente principal
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.skyBlue.withOpacity(0.4),
                  AppTheme.skyBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.2),
                  AppTheme.primaryBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.4),
                offset: const Offset(0, 12),
                blurRadius: 30,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Brilho superior
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(26),
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
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Financeiro",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xff1e293b),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Gerencie suas finanças com facilidade",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff64748b),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
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
          // Brilho superior
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
              const Center(
                child: Text(
                  "Bem-vindo de volta!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Entre na sua conta para continuar",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff64748b),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o email';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Senha
              SkeuInput(
                label: "Senha",
                hint: "••••••••",
                controller: _senhaController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xff94a3b8),
                  size: 20,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a senha';
                  if (value.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _buildSkeuCheckbox(),
                  const SizedBox(width: 8),
                  const Text(
                    "Lembrar-me",
                    style: TextStyle(
                      color: Color(0xff64748b),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Botão login
              SkeuButton(
                text: "Entrar",
                icon: Icons.login_rounded,
                isLoading: authProvider.loading,
                onPressed: authProvider.loading ? null : _fazerLogin,
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeuCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _rememberMe = !_rememberMe),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          gradient: _rememberMe
              ? AppTheme.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xfff1f5f9), Color(0xffe2e8f0)],
                ),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: _rememberMe
                ? Colors.white.withOpacity(0.3)
                : const Color(0xffe2e8f0),
            width: 1.5,
          ),
          boxShadow: _rememberMe
              ? AppTheme.blueShadow
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: _rememberMe
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  void _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final authProvider = context.read<AuthService>();
    final lancamentoProvider = context.read<LancamentoService>();

    try {
      await authProvider.login(email: email, password: senha);
      await lancamentoProvider.carregarLancamentos();
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on ApiException catch (e) {
      _showSnackbar(e.message);
    } catch (_) {
      _showSnackbar("Erro ao fazer login");
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

