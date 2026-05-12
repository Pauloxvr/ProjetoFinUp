import 'package:flutter/material.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';

class LancamentoProvider extends ChangeNotifier {
  final LancamentoService _service = LancamentoService();
  bool _loading = false;

  List<LancamentoModel> get receitas => _service.receitas;
  List<LancamentoModel> get despesas => _service.despesas;
  bool get loading => _loading;

  double get totalReceitas => _service.totalReceitas;
  double get totalDespesas => _service.totalDespesas;
  double get saldo => _service.saldo;

  Future<void> carregar() async {
    _loading = true;
    notifyListeners();

    await _service.carregarLancamentos();
    _loading = false;
    notifyListeners();
  }

  Future<void> adicionarReceita(LancamentoModel l) async {
    await _service.adicionarReceita(l);
    notifyListeners();
  }

  Future<void> adicionarDespesa(LancamentoModel l) async {
    await _service.adicionarDespesa(l);
    notifyListeners();
  }

  Future<void> removerReceita(int id) async {
    await _service.removerReceita(id);
    notifyListeners();
  }

  Future<void> removerDespesa(int id) async {
    await _service.removerDespesa(id);
    notifyListeners();
  }
}
