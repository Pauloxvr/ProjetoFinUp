import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'lancamentos_screen.dart';
import 'metas_screen.dart';
import 'historico_screen.dart';
import 'perfil_screen.dart';
import '../models/lancamento_model.dart';
import '../core/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LancamentosScreen(tipo: TipoLancamento.receita),
    LancamentosScreen(tipo: TipoLancamento.despesa),
    MetasScreen(),
    HistoricoScreen(),
    PerfilScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: "Home"),
    _NavItem(icon: Icons.arrow_downward_rounded, label: "Entrada"),
    _NavItem(icon: Icons.arrow_upward_rounded, label: "Despesa"),
    _NavItem(icon: Icons.flag_rounded, label: "Metas"),
    _NavItem(icon: Icons.history_rounded, label: "Histórico"),
    _NavItem(icon: Icons.person_rounded, label: "Perfil"),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppTheme.silverMist.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final isSelected = index == _selectedIndex;
              return _buildNavItem(
                item: _navItems[index],
                isSelected: isSelected,
                onTap: () => _onItemTapped(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required _NavItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color getIconColor() {
      if (!isSelected) return AppTheme.coolGray;
      if (item.label == "Entrada") return AppTheme.primaryBlue;
      if (item.label == "Despesa") return AppTheme.dangerRed;
      return AppTheme.primaryBlue;
    }

    final iconColor = getIconColor();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    iconColor.withOpacity(0.12),
                    iconColor.withOpacity(0.04),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: iconColor.withOpacity(0.15),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Ícone
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: item.label == "Despesa"
                            ? [
                                const Color(0xFFFF6B6B),
                                AppTheme.dangerRed,
                              ]
                            : [
                                AppTheme.lightBlue,
                                AppTheme.primaryBlue,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withOpacity(0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : BoxDecoration(
                      color: AppTheme.softWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.silverMist.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
              child: Icon(
                item.icon,
                size: 18,
                color: isSelected ? Colors.white : AppTheme.coolGray,
              ),
            ),

            const SizedBox(height: 3),

            /// Label
            Text(
              item.label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? iconColor : AppTheme.coolGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
