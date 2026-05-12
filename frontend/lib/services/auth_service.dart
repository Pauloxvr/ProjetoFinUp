import 'package:flutter/material.dart';
import 'api_service.dart';

/// Serviço de autenticação.
/// Gerencia login, registro e dados do usuário via API + JWT.
class AuthService extends ChangeNotifier {
  bool _isLogged = false;
  String _nome = '';
  String _email = '';
  String _token = '';
  bool _loading = false;

  bool get isLogged => _isLogged;
  bool get loading => _loading;
  String get nome => _nome;
  String get email => _email;
  String get token => _token;

  /// Iniciais do nome para o avatar placeholder
  String get iniciais {
    if (_nome.isEmpty) return '?';
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.first[0].toUpperCase();
  }

  /// Tenta carregar sessão salva
  Future<bool> tryAutoLogin() async {
    _token = await ApiService.getToken() ?? '';
    if (_token.isEmpty) return false;

    try {
      final response = await ApiService.get('/users/me', auth: true);
      final data = ApiService.decodeResponse(response);
      _nome = data['name'] ?? '';
      _email = data['email'] ?? '';
      _isLogged = true;
      notifyListeners();
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  /// Login via API backend
  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    try {
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
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Registro via API backend
  Future<void> register({
    required String nome,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
    final response = await ApiService.post(
      '/users',
      {'name': nome, 'email': email, 'password': password},
      auth: false,
    );

    ApiService.decodeResponse(response);
    // Após registro, faz login automático
    await login(email: email, password: password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await ApiService.removeToken();
    _isLogged = false;
    _nome = '';
    _email = '';
    _token = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}

