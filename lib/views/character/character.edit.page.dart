// lib/views/character/character.edit.page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;

class CharacterEditPage extends StatefulWidget {
  const CharacterEditPage({super.key, required this.characterId, this.initialData});
  final String characterId;
  final Map<String, dynamic>? initialData;

  @override
  State<CharacterEditPage> createState() => _CharacterEditPageState();
}

class _CharacterEditPageState extends State<CharacterEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _categoriaSelecionada;
  String? _photoUrl;
  bool _loading = true;
  bool _saving = false;

  final List<String> _categorias = [
    'Super-Herói',
    'Princesa',
    'Desenho Animado',
    'Outro'
  ];

  XFile? _image;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      Map<String, dynamic>? data = widget.initialData;
      if (data == null || (data['name'] == null && data['category'] == null)) {
        final doc = await FirebaseFirestore.instance.collection('characters').doc(widget.characterId).get();
        data = doc.data() ?? {};
      }
      _nameCtrl.text = (data['name'] as String?) ?? '';
      _descCtrl.text = (data['description'] as String?) ?? '';
      _categoriaSelecionada = (data['category'] as String?) ?? null;
      _photoUrl = (data['photoUrl'] as String?) ?? '';
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
    setState(() => _saving = true);
    try {
      final updates = {
        'name': _nameCtrl.text.trim(),
        'category': _categoriaSelecionada,
        'description': _descCtrl.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final newPhoto = _convertImageToBase64();
      if (newPhoto != null) {
        updates['photoUrl'] = newPhoto;
      }
      await FirebaseFirestore.instance
          .collection('characters')
          .doc(widget.characterId)
          .update(updates);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personagem atualizado')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildImage(String? imageUrl) {
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(_imageBytes!, height: 160, width: double.infinity, fit: BoxFit.cover),
      );
    }
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.camera_alt_outlined, size: 48),
      );
    }
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(bytes, height: 160, width: double.infinity, fit: BoxFit.cover),
        );
      } catch (_) {
        return Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.camera_alt_outlined, size: 48),
        );
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        title: const Text('Editar Personagem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: _showImageSourceDialog,
              child: _buildImage(_photoUrl),
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
                hintText: 'Detalhes da apresentação...',
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
                : const Text('Salvar Alterações', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}