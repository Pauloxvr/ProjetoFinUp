import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'services/auth_service.dart';
import 'services/lancamento_service.dart';
import 'providers/meta_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authService = AuthService();
  // Tenta recuperar sessão salva (Auto-Login) antes de iniciar a interface
  await authService.tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (_) => LancamentoService()),
        ChangeNotifierProvider(create: (_) => MetaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return MaterialApp(
      title: 'FinUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // Se o token for válido e o usuário estiver logado, vai direto para Home
      initialRoute: auth.isLogged ? AppRoutes.home : AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
