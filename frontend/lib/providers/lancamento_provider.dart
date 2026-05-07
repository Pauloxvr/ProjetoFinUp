import 'package:flutter/material.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';

class LancamentoProvider extends ChangeNotifier {
  bool _loading = false;

  List<LancamentoModel> get receitas => LancamentoService.getReceitas();
  List<LancamentoModel> get despesas => LancamentoService.getDespesas();
  bool get loading => _loading;

  double get totalReceitas => LancamentoService.totalReceitas;
  double get totalDespesas => LancamentoService.totalDespesas;
  double get saldo => LancamentoService.saldo;

  Future<void> carregar() async {
    _loading = true;
    notifyListeners();

    await LancamentoService.carregarLancamentos();
    _loading = false;
    notifyListeners();
  }

  Future<void> adicionarReceita(LancamentoModel l) async {
    await LancamentoService.adicionarReceita(l);
    notifyListeners();
  }

  Future<void> adicionarDespesa(LancamentoModel l) async {
    await LancamentoService.adicionarDespesa(l);
    notifyListeners();
  }

  Future<void> removerReceita(int id) async {
    await LancamentoService.removerReceita(id);
    notifyListeners();
  }

  Future<void> removerDespesa(int id) async {
    await LancamentoService.removerDespesa(id);
    notifyListeners();
  }
}
