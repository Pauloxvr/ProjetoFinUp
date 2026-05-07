import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/skeu_button.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _notificacoesAtivas = true;

  @override
  Widget build(BuildContext context) {
    final podeVoltar = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Background decorativo
          _buildBackground(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Header
                  _buildHeader(podeVoltar),

                  const SizedBox(height: 30),

                  /// Card do perfil
                  _buildProfileCard(),

                  const SizedBox(height: 24),

                  /// Configurações
                  _buildSettingsSection(),

                  const SizedBox(height: 24),

                  /// Sobre
                  _buildAboutSection(),

                  const SizedBox(height: 24),

                  /// Botão sair
                  SkeuButton(
                    text: "Sair da conta",
                    icon: Icons.logout_rounded,
                    variant: SkeuButtonVariant.danger,
                    onPressed: () => _confirmarSaida(context),
                  ),

                  const SizedBox(height: 40),
                ],
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
          top: -100,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
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

  Widget _buildHeader(bool podeVoltar) {
    return Row(
      children: [
        if (podeVoltar)
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
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xff475569),
                  size: 20,
                ),
              ),
            ),
          ),
        if (podeVoltar) const SizedBox(width: 16),
        const Expanded(
          child: Text(
            "Meu Perfil",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xff1e293b),
            ),
          ),
        ),
        Container(
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
          child: const Center(
            child: Icon(
              Icons.edit_rounded,
              color: AppTheme.primaryBlue,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
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
            children: [
              /// Avatar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: AppTheme.blueShadow,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.cardLightGradient,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AuthService.iniciais,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Nome
              Text(
                AuthService.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1e293b),
                ),
              ),

              const SizedBox(height: 6),

              /// Email
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.iceBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: AppTheme.primaryBlue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AuthService.email,
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStat("32", "Lançamentos"),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppTheme.silverMist,
                  ),
                  Expanded(
                    child: _buildStat("3", "Metas"),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppTheme.silverMist,
                  ),
                  Expanded(
                    child: _buildStat("85%", "Economia"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String valor, String label) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xff94a3b8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
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
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xfffbbf24),
            title: "Notificações",
            subtitle: "Receber alertas e lembretes",
            trailing: _buildSkeuSwitch(
              value: _notificacoesAtivas,
              onChanged: (v) => setState(() => _notificacoesAtivas = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
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
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.help_outline_rounded,
            iconColor: AppTheme.primaryBlue,
            title: "Ajuda & Suporte",
            subtitle: "FAQ e contato",
            trailing: _buildChevron(),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xff22c55e),
            title: "Privacidade",
            subtitle: "Termos e políticas",
            trailing: _buildChevron(),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xff64748b),
            title: "Sobre",
            subtitle: "Versão 1.0.0",
            trailing: _buildChevron(),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1e293b),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff94a3b8),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: AppTheme.silverMist.withOpacity(0.5),
    );
  }

  Widget _buildChevron() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.iceBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.primaryBlue,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSkeuSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 56,
          height: 32,
          decoration: BoxDecoration(
            gradient: value
                ? AppTheme.primaryGradient
                : const LinearGradient(
                    colors: [Color(0xffe2e8f0), Color(0xffd1d5db)],
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: value
                  ? Colors.white.withOpacity(0.3)
                  : const Color(0xffd1d5db),
              width: 1,
            ),
            boxShadow: value
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
                left: value ? 26 : 4,
                top: 4,
                child: Container(
                  width: 24,
                  height: 24,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.cardLightGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppTheme.dangerGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.dangerRed.withOpacity(0.3),
                      offset: const Offset(0, 6),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sair da conta?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1e293b),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Você precisará fazer login novamente para acessar sua conta.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff64748b),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SkeuButton(
                      text: "Cancelar",
                      variant: SkeuButtonVariant.secondary,
                      height: 48,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SkeuButton(
                      text: "Sair",
                      variant: SkeuButtonVariant.danger,
                      height: 48,
                      onPressed: () {
                        AuthService.logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
