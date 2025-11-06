import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoneService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Crear nota con categoría y fecha de creación
  Future<void> addnote(String text, String category) async {
    await _db.collection('notes').add({
      'text': text,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(), // usa la hora del servidor
    });
  }

  // Leer notas ordenadas por fecha
  Stream<QuerySnapshot> getNotesStream() {
    return _db
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Actualizar nota (texto y categoría)
  Future<void> updateNote(String id, String text, String category) async {
    await _db.collection('notes').doc(id).update({
      'text': text,
      'category': category,
      // No se actualiza 'createdAt' para conservar la fecha original
    });
  }

  // Eliminar nota
  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }
}

