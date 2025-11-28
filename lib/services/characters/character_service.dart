import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterService {
  final _db = FirebaseFirestore.instance;

  // Mapeamento de categorias da interface para o banco de dados
  static final Map<String, String> _categoryMapping = {
    'Super-Heróis': 'Super-Herói',
    'Princesas': 'Princesa',
    'Desenhos': 'Desenho Animado',
    'Palhaços': 'Palhaços',
    'Animais': 'Animais',
    'Natal': 'Natal',
  };

  // Converte categoria da interface para categoria do banco
  String? _mapCategoryToDb(String? category) {
    if (category == null || category.isEmpty) return null;
    return _categoryMapping[category] ?? category;
  }

  Stream<List<Map<String, dynamic>>> watchCharacters({
    String? search,
    String? category,
  }) {
    // Iniciando a query para a coleção "characters"
    Query<Map<String, dynamic>> query = _db
        .collection('characters')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data() ?? {},
          toFirestore: (data, _) => data,
        );

    // Filtra por categoria, caso a categoria seja fornecida
    // Converte a categoria da interface para a categoria do banco
    final dbCategory = _mapCategoryToDb(category);
    if (dbCategory != null && dbCategory.isNotEmpty) {
      query = query.where('category', isEqualTo: dbCategory);
    }

    // Retorna um stream de dados
    return query.snapshots().map((snapshot) {
      var list = snapshot.docs.map((doc) {
        final data = doc.data();
        // Adiciona o ID do documento aos dados
        data['id'] = doc.id;

        // Transforma os dados do Firebase para o formato esperado pelo widget Character
        // O widget Character espera: img, personagem, nome
        // O Firebase retorna: photoUrl, name, description, category
        final transformedData = <String, dynamic>{
          'id': doc.id,
          'img': data['photoUrl'] ?? '',
          'personagem': data['name'] ?? '',
          'nome': data['description'] ?? data['category'] ?? '',
          'category': data['category'] ?? '',
          'description': data['description'] ?? '',
          'name': data['name'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'companyId': data['companyId'] ?? '',
          'companyName': data['companyName'] ?? '',
        };

        return transformedData;
      }).toList();

      // Filtro de busca baseado no nome do personagem e descrição
      // Nota: Firestore não suporta busca de texto completo nativamente,
      // então fazemos o filtro em memória após buscar os documentos
      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase().trim();
        list = list.where((c) {
          // Busca no nome (name) e na descrição (description)
          final name = (c['name'] as String? ?? '').toLowerCase();
          final description = (c['description'] as String? ?? '').toLowerCase();
          final category = (c['category'] as String? ?? '').toLowerCase();

          return name.contains(q) ||
              description.contains(q) ||
              category.contains(q);
        }).toList();
      }

      return list;
    });
  }
}
