import 'package:cloud_firestore/cloud_firestore.dart';

class QuotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 Obtener todas las frases
  Future<List<Map<String, dynamic>>> getQuotes() async {
    try {
      final snapshot = await _firestore
          .collection('frases')
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'texto': doc['texto'],
          'autor': doc['autor'],
          'fecha': doc['fecha'],
        };
      }).toList();
    } catch (e) {
      print('❌ Error al obtener frases: $e');
      return [];
    }
  }

  /// ➕ Agregar una nueva frase
  Future<void> addQuote(String texto, String autor) async {
    try {
      await _firestore.collection('frases').add({
        'texto': texto,
        'autor': autor,
        'fecha': FieldValue.serverTimestamp(),
      });
      print('✅ Frase agregada correctamente');
    } catch (e) {
      print('❌ Error al agregar frase: $e');
    }
  }

  /// ✏️ Actualizar una frase existente
  Future<void> updateQuote(String id, String texto, String autor) async {
    try {
      await _firestore.collection('frases').doc(id).update({
        'texto': texto,
        'autor': autor,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });
      print('✅ Frase actualizada correctamente');
    } catch (e) {
      print('❌ Error al actualizar frase: $e');
    }
  }

  /// 🗑️ Eliminar una frase por su ID
  Future<void> deleteQuote(String id) async {
    try {
      await _firestore.collection('frases').doc(id).delete();
      print('🗑️ Frase eliminada correctamente');
    } catch (e) {
      print('❌ Error al eliminar frase: $e');
    }
  }
}
