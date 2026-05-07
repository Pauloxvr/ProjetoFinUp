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

    await MetaService.carregarMetas();
    _metas = MetaService.metas.toList();
    _loading = false;
    notifyListeners();
  }

  Future<void> adicionar(String titulo, double valorMeta) async {
    await MetaService.criarMeta(titulo, valorMeta);
    _metas = MetaService.metas.toList();
    notifyListeners();
  }

  Future<void> atualizar(int id, {double? valorAtual, String? titulo, double? valorMeta}) async {
    await MetaService.atualizarMeta(id, valorAtual: valorAtual, titulo: titulo, valorMeta: valorMeta);
    _metas = MetaService.metas.toList();
    notifyListeners();
  }

  Future<void> remover(int id) async {
    await MetaService.removerMeta(id);
    _metas = MetaService.metas.toList();
    notifyListeners();
  }
}
