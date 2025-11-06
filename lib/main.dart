import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_config.dart';
import 'firestone_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas con Firebase',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Personal'; // Valor por defecto
  final FirestoneService _service = FirestoneService();

  Future<void> _addNote() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    await _service.addnote(text, _selectedCategory);
    _textController.clear();
  }

  Future<void> _editNote(String id, String oldText, String oldCategory) async {
    final textCtrl = TextEditingController(text: oldText);
    String selectedCategory = oldCategory;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: const [
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Trabajo', child: Text('Trabajo')),
                DropdownMenuItem(value: 'Estudio', child: Text('Estudio')),
                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              ],
              onChanged: (value) => selectedCategory = value!,
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'text': textCtrl.text.trim(),
              'category': selectedCategory,
            }),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == null || result['text']!.isEmpty) return;
    await _service.updateNote(id, result['text']!, result['category']!);
  }

  Future<void> _deleteNote(String id) async {
    await _service.deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notas con Firebase')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe una nota...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                    DropdownMenuItem(value: 'Trabajo', child: Text('Trabajo')),
                    DropdownMenuItem(value: 'Estudio', child: Text('Estudio')),
                    DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addNote, child: const Text('Agregar')),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getNotesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!.docs;
                if (notes.isEmpty) {
                  return const Center(child: Text('Sin notas aún'));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    final doc = notes[i];
                    final text = doc['text'];
                    final category = doc['category'] ?? 'Sin categoría';
                    final timestamp = doc['createdAt'] as Timestamp?;
                    final date = timestamp != null
                        ? timestamp.toDate()
                        : DateTime.now();

                    return ListTile(
                      title: Text(text),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categoría: $category'),
                          Text('Creado: ${date.toLocal()}'),
                        ],
                      ),
                      onTap: () =>
                          _editNote(doc.id, text, category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteNote(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

