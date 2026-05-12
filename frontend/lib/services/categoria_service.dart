import 'api_service.dart';

class Categoria {
  final int id;
  final String name;
  final String type;

  Categoria({required this.id, required this.name, required this.type});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class CategoriaService {
  static List<Categoria> _categorias = [];

  static List<Categoria> getCategoriasReceita() =>
      _categorias.where((c) => c.type == 'income').toList();

  static List<Categoria> getCategoriasDespesa() =>
      _categorias.where((c) => c.type == 'expense').toList();

  static Future<void> carregarCategorias() async {
    final response = await ApiService.get('/categories');
    final data = ApiService.decodeResponse(response);
    _categorias = (data as List)
        .map((json) => Categoria.fromJson(json))
        .toList();
  }

  static Future<void> criarCategoria(String name, String type) async {
    final response = await ApiService.post('/categories', {
      'name': name,
      'type': type,
    });
    ApiService.decodeResponse(response);
    await carregarCategorias();
  }
}
