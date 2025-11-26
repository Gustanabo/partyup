import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;

class CharacterAddPage extends StatefulWidget {
  const CharacterAddPage({super.key});

  @override
  State<CharacterAddPage> createState() => _CharacterAddPageState();
}

class _CharacterAddPageState extends State<CharacterAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _categoriaSelecionada;

  final List<String> _categorias = [
    'Super-Herói',
    'Princesa',
    'Desenho Animado',
    'Outros',
    'Palhaços',
    'Animais',
    'Halloween',
  ];

  XFile? _image;
  Uint8List? _imageBytes;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    if (!mounted) return;

    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da Galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      await _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: source, imageQuality: 92);
      if (img != null) {
        final bytes = await img.readAsBytes();
        if (mounted) {
          setState(() {
            _image = img;
            _imageBytes = bytes;
          });
        }
      }
    } catch (_) {}
  }

  String? _convertImageToBase64() {
    if (_imageBytes == null) return null;
    final base64String = base64Encode(_imageBytes!);
    return 'data:image/jpeg;base64,$base64String';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    // Obtém o usuário logado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado')));
      return;
    }

    setState(() => _saving = true);
    try {
      final col = FirebaseFirestore.instance.collection('characters');
      final docRef = col.doc();
      final imageBase64 = _convertImageToBase64();
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final companyName =
          user.displayName ?? (userDoc.data()?['name'] as String?) ?? '';

      await docRef.set({
        'name': _nameCtrl.text.trim(),
        'category': _categoriaSelecionada,
        'description': _descCtrl.text.trim(),
        'photoUrl': imageBase64 ?? '',
        'companyId': user.uid,
        'companyName': companyName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personagem criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Volta para a página anterior (CompanyHomePage com a bottom navigation bar)
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        title: const Text('Novo Personagem'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_image == null) ...[
                        const Icon(Icons.camera_alt_outlined, size: 50),
                        const SizedBox(height: 10),
                        const Text(
                          'Foto do Personagem',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Toque para enviar uma imagem de alta qualidade',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        if (_imageBytes != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _imageBytes!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          const CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        const Text('Toque para trocar a foto'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nome do Personagem',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Ex: Homem-Aranha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Categoria',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: const Text('Selecione uma categoria'),
                value: _categoriaSelecionada,
                isExpanded: true,
                items: _categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoriaSelecionada = v),
              ),
              const SizedBox(height: 24),
              const Text(
                'Descrição',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Apresentação com acrobacias e sessão de fotos...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _saving
                  ? const CircularProgressIndicator.adaptive()
                  : const Text(
                      'Adicionar Personagem',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
