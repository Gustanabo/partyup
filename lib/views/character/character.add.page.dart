import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:partyup/views/company/company.characters.page.dart';

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
    'Outro'
  ];

  XFile? _image;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 92);
    if (img != null) setState(() => _image = img);
  }

  Future<String?> _uploadImage(String docId) async {
    if (_image == null) return null;
    final bytes = await _image!.readAsBytes(); // funciona no mobile e web
    final ref = FirebaseStorage.instance.ref().child('characters/$docId.jpg');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final col = FirebaseFirestore.instance.collection('characters');
      final docRef = col.doc(); // gera ID
      final photoUrl = await _uploadImage(docRef.id);

      await docRef.set({
        'name': _nameCtrl.text.trim(),
        'category': _categoriaSelecionada,
        'description': _descCtrl.text.trim(),
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personagem criado')),
        );
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompanyCharactersPage(),
        ),
      );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(title: const Text('Novo Personagem'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (_image == null) ...[
                    const Icon(Icons.camera_alt_outlined, size: 50),
                    const SizedBox(height: 10),
                    const Text('Foto do Personagem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      'Toque para enviar uma imagem de alta qualidade',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        // preview cross-plataform
                        // ignore: invalid_use_of_visible_for_testing_member
                        awaitForImage(_image!) as Uint8List, // ver helper abaixo
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Toque para trocar a foto'),
                  ],
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Nome do Personagem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: 'Ex: Homem-Aranha',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 24),
            const Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              hint: const Text('Selecione uma categoria'),
              value: _categoriaSelecionada,
              isExpanded: true,
              items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _categoriaSelecionada = v),
            ),
            const SizedBox(height: 24),
            const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Apresentação com acrobacias e sessão de fotos...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: _saving
                ? const CircularProgressIndicator.adaptive()
                : const Text('Adicionar Personagem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

/// Helper para ler bytes do XFile e exibir no Image.memory
Future<Uint8List> awaitForImage(XFile file) => file.readAsBytes();
