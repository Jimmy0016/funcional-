import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 🔐 Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  /// 📩 Iniciar sesión con correo y contraseña
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Fluttertoast.showToast(msg: "Inicio de sesión exitoso 👋");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error inesperado: $e");
      return null;
    }
  }

  /// 📝 Registrar nuevo usuario con datos personales
  Future<User?> register(String email, String password, String nombre, String apellido) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user != null) {
        await _saveUserData(credential.user!.uid, nombre, apellido, email);
      }

      Fluttertoast.showToast(msg: "Cuenta creada correctamente 🎉");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error inesperado: $e");
      return null;
    }
  }

  /// 💾 Guardar datos del usuario en Firestore
  Future<void> _saveUserData(String uid, String nombre, String apellido, String email) async {
    try {
      await _firestore.collection('usuarios').doc(uid).set({
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'fechaRegistro': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error al guardar datos del usuario: $e');
    }
  }

  /// 👤 Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  /// 🔄 Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Fluttertoast.showToast(msg: "Correo de recuperación enviado 📧");
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error inesperado: $e");
      return false;
    }
  }

  /// 📷 Subir foto de perfil
  Future<String?> uploadProfilePhoto(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child('profile_photos').child('$uid.jpg');
      await ref.putFile(imageFile);
      final downloadURL = await ref.getDownloadURL();
      
      await _firestore.collection('usuarios').doc(uid).update({
        'photoURL': downloadURL,
      });
      
      Fluttertoast.showToast(msg: "Foto actualizada correctamente 📸");
      return downloadURL;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al subir foto: $e");
      return null;
    }
  }

  /// 🔐 Cambiar contraseña
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      
      Fluttertoast.showToast(msg: "Contraseña actualizada correctamente 🔐");
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error inesperado: $e");
      return false;
    }
  }

  /// 🚪 Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: "Sesión cerrada correctamente 👋");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al cerrar sesión: $e");
    }
  }

  /// ⚠️ Manejar errores comunes de Firebase
  void _handleAuthError(FirebaseAuthException e) {
    String message = "Error desconocido";

    switch (e.code) {
      case 'invalid-email':
        message = "El correo no es válido";
        break;
      case 'user-disabled':
        message = "El usuario ha sido deshabilitado";
        break;
      case 'user-not-found':
        message = "No existe una cuenta con ese correo";
        break;
      case 'wrong-password':
        message = "Contraseña incorrecta";
        break;
      case 'email-already-in-use':
        message = "Este correo ya está registrado";
        break;
      case 'weak-password':
        message = "La contraseña es demasiado débil";
        break;
      case 'too-many-requests':
        message = "Demasiados intentos. Intenta más tarde";
        break;
      case 'network-request-failed':
        message = "Error de conexión. Verifica tu internet";
        break;
      default:
        message = e.message ?? message;
        break;
    }

    Fluttertoast.showToast(msg: message);
  }
}
