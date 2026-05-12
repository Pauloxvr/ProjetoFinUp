import 'package:flutter/material.dart';
import 'api_service.dart';
import '../models/lancamento_model.dart';

/// Serviço responsável por CRUD de lançamentos via API.
class LancamentoService extends ChangeNotifier {
  List<LancamentoModel> _receitas = [];
  List<LancamentoModel> _despesas = [];
  bool _loading = false;

  List<LancamentoModel> get receitas => _receitas;
  List<LancamentoModel> get despesas => _despesas;
  bool get loading => _loading;

  double get totalReceitas =>
      _receitas.fold(0, (sum, l) => sum + l.valor);

  double get totalDespesas =>
      _despesas.fold(0, (sum, l) => sum + l.valor);

  double get saldo => totalReceitas - totalDespesas;

  /// Carrega receitas e despesas da API
  Future<void> carregarLancamentos() async {
    _loading = true;
    notifyListeners();
    
    try {
    final rReceitas = await ApiService.get('/incomes');
    final rDespesas = await ApiService.get('/expenses');

    final bodyReceitas = ApiService.decodeResponse(rReceitas);
    final bodyDespesas = ApiService.decodeResponse(rDespesas);

    _receitas = (bodyReceitas as List)
        .map((json) => LancamentoModel.fromJson(json, TipoLancamento.receita))
        .toList();

    _despesas = (bodyDespesas as List)
        .map((json) => LancamentoModel.fromJson(json, TipoLancamento.despesa))
        .toList();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Adiciona uma receita via API
  Future<void> adicionarReceita(LancamentoModel l) async {
    final response = await ApiService.post('/incomes', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  /// Adiciona uma despesa via API
  Future<void> adicionarDespesa(LancamentoModel l) async {
    final response = await ApiService.post('/expenses', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  Future<void> atualizarReceita(LancamentoModel l) async {
    final response = await ApiService.patch('/incomes/${l.id}', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  Future<void> atualizarDespesa(LancamentoModel l) async {
    final response = await ApiService.patch('/expenses/${l.id}', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  /// Remove uma receita por ID
  Future<void> removerReceita(int id) async {
    await ApiService.delete('/incomes/$id');
    _receitas.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Remove uma despesa por ID
  Future<void> removerDespesa(int id) async {
    await ApiService.delete('/expenses/$id');
    _despesas.removeWhere((l) => l.id == id);
    notifyListeners();
  }
}

