enum TipoLancamento { receita, despesa }

class LancamentoModel {
  final int id;
  final String titulo;
  final double valor;
  final DateTime data;
  final TipoLancamento tipo;
  final int? categoriaId;
  final String? categoriaNome;
  final bool parcelado;

  LancamentoModel({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    this.categoriaId,
    this.categoriaNome,
    this.parcelado = false,
  });

  bool get isReceita => tipo == TipoLancamento.receita;

  String? get categoria => categoriaNome;

  Map<String, dynamic> toJson() => {
        'description': titulo,
        'amount': valor,
        'date': data.toIso8601String().split('T')[0],
        'category_id': categoriaId,
      };

  factory LancamentoModel.fromJson(Map<String, dynamic> json, TipoLancamento tipo) {
    return LancamentoModel(
      id: json['id'],
      titulo: json['description'] ?? '',
      valor: (json['amount'] as num).toDouble(),
      data: DateTime.parse(json['date']),
      tipo: tipo,
      categoriaId: json['category_id'],
      categoriaNome: json['category_name'],
    );
  }
}
