import 'dart:convert';
import 'api_service.dart';

/// Serviço de autenticação.
/// Gerencia login, registro e dados do usuário via API + JWT.
class AuthService {
  static bool _isLogged = false;
  static String _nome = '';
  static String _email = '';
  static String _token = '';

  static bool isLogged() => _isLogged;

  static String get nome => _nome;
  static String get email => _email;
  static String get token => _token;

  /// Iniciais do nome para o avatar placeholder
  static String get iniciais {
    if (_nome.isEmpty) return '?';
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.first[0].toUpperCase();
  }

  /// Tenta carregar sessão salva
  static Future<bool> tryAutoLogin() async {
    _token = await ApiService.getToken() ?? '';
    if (_token.isEmpty) return false;

    try {
      final response = await ApiService.get('/users/me', auth: true);
      final data = ApiService.decodeResponse(response);
      _nome = data['name'] ?? '';
      _email = data['email'] ?? '';
      _isLogged = true;
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  /// Login via API backend
  static Future<void> login({required String email, required String password}) async {
    final response = await ApiService.post(
      '/auth/login',
      {'email': email, 'password': password},
      auth: false,
    );

    final data = ApiService.decodeResponse(response);
    _token = data['token'];
    _nome = data['user']['name'] ?? '';
    _email = data['user']['email'] ?? '';
    _isLogged = true;

    await ApiService.setToken(_token);
  }

  /// Registro via API backend
  static Future<void> register({
    required String nome,
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      '/users',
      {'name': nome, 'email': email, 'password': password},
      auth: false,
    );

    ApiService.decodeResponse(response);
    // Após registro, faz login automático
    await login(email: email, password: password);
  }

  static Future<void> logout() async {
    _isLogged = false;
    _nome = '';
    _email = '';
    _token = '';
    await ApiService.removeToken();
  }
}
