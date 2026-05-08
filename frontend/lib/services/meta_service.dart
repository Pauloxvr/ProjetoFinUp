import 'dart:convert';
import 'api_service.dart';
import '../models/meta_model.dart';

class MetaService {
  static List<MetaModel> _metas = [];

  static List<MetaModel> get metas => List.unmodifiable(_metas);

  static Future<void> carregarMetas() async {
    final response = await ApiService.get('/goals');
    final data = ApiService.decodeResponse(response);
    _metas = (data as List).map((json) => MetaModel.fromJson(json)).toList();
  }

  static Future<void> criarMeta(String titulo, double valorMeta) async {
    final response = await ApiService.post('/goals', {
      'title': titulo,
      'target_amount': valorMeta,
    });
    ApiService.decodeResponse(response);
    await carregarMetas();
  }

  static Future<void> atualizarMeta(int id, {double? valorAtual, String? titulo, double? valorMeta}) async {
    final body = <String, dynamic>{};
    if (valorAtual != null) body['current_amount'] = valorAtual;
    if (titulo != null) body['title'] = titulo;
    if (valorMeta != null) body['target_amount'] = valorMeta;

    final response = await ApiService.patch('/goals/$id', body);
    ApiService.decodeResponse(response);
    await carregarMetas();
  }

  static Future<void> removerMeta(int id) async {
    try {
      await ApiService.delete('/goals/$id');
      await carregarMetas();
    } catch (e) {
      rethrow;
    }
  }
}
