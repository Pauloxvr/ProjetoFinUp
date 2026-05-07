import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'services/auth_service.dart';
import 'providers/lancamento_provider.dart';
import 'providers/meta_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinanceiroApp());
}

class FinanceiroApp extends StatefulWidget {
  const FinanceiroApp({super.key});

  @override
  State<FinanceiroApp> createState() => _FinanceiroAppState();
}

class _FinanceiroAppState extends State<FinanceiroApp> {
  bool _initialized = false;
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final logged = await AuthService.tryAutoLogin();
    setState(() {
      _isLogged = logged;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LancamentoProvider()),
        ChangeNotifierProvider(create: (_) => MetaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Financeiro App',
        theme: AppTheme.theme,
        home: _isLogged
            ? AppRoutes.routes[AppRoutes.home]!(context)
            : AppRoutes.routes[AppRoutes.login]!(context),
        routes: AppRoutes.routes,
      ),
    );
  }
}
