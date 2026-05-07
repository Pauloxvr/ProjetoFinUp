import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';
  static const String _tokenKey = 'auth_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _getHeaders({bool auth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool auth = true}) async {
    final headers = await _getHeaders(auth: auth);
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final headers = await _getHeaders(auth: auth);
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final headers = await _getHeaders(auth: auth);
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    final headers = await _getHeaders(auth: auth);
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.delete(url, headers: headers);
  }

  static dynamic decodeResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, _extractError(response));
  }

  static String _extractError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro desconhecido';
    } catch (_) {
      return 'Erro na requisição (${response.statusCode})';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}
