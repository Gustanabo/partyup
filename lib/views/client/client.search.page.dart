import 'package:flutter/material.dart';
import 'package:partyup/widgets/character.dart';
import 'package:partyup/widgets/search.field.dart';
import 'package:partyup/widgets/title.field.dart';
import 'package:partyup/services/characters/character_service.dart';
import 'package:partyup/views/character/character.details.page.dart';

class ClientSearchPage extends StatefulWidget {
  final String? searchText; // Adiciona o parâmetro searchText (opcional)
  final String? category; // Adiciona o parâmetro category (pode ser nulo)

  ClientSearchPage({
    super.key,
    this.searchText, // Torna searchText opcional
    this.category, // Adiciona category como parâmetro opcional
  });

  @override
  State<ClientSearchPage> createState() => _ClientSearchPageState();
}

class _ClientSearchPageState extends State<ClientSearchPage> {
  final CharacterService characterService = CharacterService();
  late final TextEditingController _searchController;
  String? _currentSearch;
  String? _currentCategory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchText ?? '');
    _currentSearch = widget.searchText != null && widget.searchText!.isNotEmpty
        ? widget.searchText
        : null;
    _currentCategory = widget.category;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _currentSearch = value.trim().isNotEmpty ? value.trim() : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determina o título baseado no que está sendo filtrado
    String title = 'Buscar Personagens';
    if (_currentCategory != null) {
      title = 'Categoria: $_currentCategory';
    } else if (_currentSearch != null) {
      title = 'Resultados da busca';
    }

    // Verifica se pode voltar (se foi aberto via Navigator.push)
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: canPop
          ? AppBar(
              backgroundColor: const Color(0xFFF8F6FA),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1423)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1423),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              if (!canPop) ...[
                TitleField(title: title),
                const SizedBox(height: 16),
              ],
              SearchField(
                ctrl: _searchController,
                onSubmitted: _onSearchSubmitted,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: characterService.watchCharacters(
                    search: _currentSearch,
                    category: _currentCategory,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Erro ao carregar personagens: ${snapshot.error}'),
                      );
                    }

                    final personagens = snapshot.data ?? [];

                    if (personagens.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _currentSearch != null || _currentCategory != null
                                  ? 'Nenhum personagem encontrado'
                                  : 'Digite algo para buscar ou selecione uma categoria',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: personagens.length,
                      itemBuilder: (context, index) => Character(
                        personagem: personagens[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CharacterDetailsPage(
                                character: personagens[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
