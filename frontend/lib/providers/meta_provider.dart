import 'package:flutter/material.dart';
import '../models/meta_model.dart';
import '../services/meta_service.dart';

class MetaProvider extends ChangeNotifier {
  List<MetaModel> _metas = [];
  bool _loading = false;
  String? _errorMessage;

  List<MetaModel> get metas => _metas;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> carregar() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await MetaService.carregarMetas();
      _metas = MetaService.metas.toList();
    } catch (e) {
      _errorMessage = "Não foi possível carregar as metas.";
      debugPrint("Erro MetaProvider: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> adicionar(String titulo, double valorMeta) async {
    _loading = true;
    notifyListeners();
    try {
      await MetaService.criarMeta(titulo, valorMeta);
      await carregar();
    } catch (e) {
      _errorMessage = "Erro ao criar meta.";
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> atualizar(int id, {double? valorAtual, String? titulo, double? valorMeta}) async {
    try {
      await MetaService.atualizarMeta(id, valorAtual: valorAtual, titulo: titulo, valorMeta: valorMeta);
      await carregar();
    } catch (e) {
      _errorMessage = "Erro ao atualizar meta.";
      notifyListeners();
    }
  }

  Future<void> remover(int id) async {
    _loading = true;
    notifyListeners();
    try {
      await MetaService.removerMeta(id);
      await carregar();
    } catch (e) {
      _errorMessage = "Erro ao remover meta.";
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

