import 'dart:convert';
import 'api_service.dart';
import '../models/lancamento_model.dart';

/// Serviço responsável por CRUD de lançamentos via API.
class LancamentoService {
  static List<LancamentoModel> _receitas = [];
  static List<LancamentoModel> _despesas = [];

  static List<LancamentoModel> getReceitas() => _receitas;
  static List<LancamentoModel> getDespesas() => _despesas;

  static double get totalReceitas =>
      _receitas.fold(0, (sum, l) => sum + l.valor);

  static double get totalDespesas =>
      _despesas.fold(0, (sum, l) => sum + l.valor);

  static double get saldo => totalReceitas - totalDespesas;

  /// Carrega receitas e despesas da API
  static Future<void> carregarLancamentos() async {
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
  }

  /// Adiciona uma receita via API
  static Future<void> adicionarReceita(LancamentoModel l) async {
    final response = await ApiService.post('/incomes', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  /// Adiciona uma despesa via API
  static Future<void> adicionarDespesa(LancamentoModel l) async {
    final response = await ApiService.post('/expenses', l.toJson());
    ApiService.decodeResponse(response);
    await carregarLancamentos();
  }

  /// Remove uma receita por ID
  static Future<void> removerReceita(int id) async {
    await ApiService.delete('/incomes/$id');
    _receitas.removeWhere((l) => l.id == id);
  }

  /// Remove uma despesa por ID
  static Future<void> removerDespesa(int id) async {
    await ApiService.delete('/expenses/$id');
    _despesas.removeWhere((l) => l.id == id);
  }
}
