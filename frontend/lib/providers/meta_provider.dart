import 'package:flutter/material.dart';
import '../models/meta_model.dart';
import '../services/meta_service.dart';

class MetaProvider extends ChangeNotifier {
  List<MetaModel> _metas = [];
  bool _loading = false;

  List<MetaModel> get metas => _metas;
  bool get loading => _loading;

  Future<void> carregar() async {
    _loading = true;
    notifyListeners();

    try {
      await MetaService.carregarMetas();
      _metas = MetaService.metas.toList();
    } catch (_) {
      // Mantém a UI atual e apenas encerra o loading.
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> adicionar(String titulo, double valorMeta) async {
    await MetaService.criarMeta(titulo, valorMeta);
    await carregar();
  }

  Future<void> atualizar(int id, {double? valorAtual, String? titulo, double? valorMeta}) async {
    await MetaService.atualizarMeta(id, valorAtual: valorAtual, titulo: titulo, valorMeta: valorMeta);
    await carregar();
  }

  Future<void> remover(int id) async {
    await MetaService.removerMeta(id);
    await carregar();
  }
}
