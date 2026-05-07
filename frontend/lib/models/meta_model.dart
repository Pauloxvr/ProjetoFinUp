class MetaModel {
  final int id;
  final String titulo;
  final double valorAtual;
  final double valorMeta;
  final String icone;

  MetaModel({
    required this.id,
    required this.titulo,
    required this.valorAtual,
    required this.valorMeta,
    this.icone = '',
  });

  double get progresso => valorMeta > 0 ? valorAtual / valorMeta : 0;

  int get porcentagem => (progresso * 100).clamp(0, 100).toInt();

  Map<String, dynamic> toJson() => {
        'title': titulo,
        'target_amount': valorMeta,
        'current_amount': valorAtual,
      };

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      id: json['id'],
      titulo: json['title'],
      valorAtual: (json['current_amount'] as num).toDouble(),
      valorMeta: (json['target_amount'] as num).toDouble(),
    );
  }
}
