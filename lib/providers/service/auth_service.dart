import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  /// 📝 Registrar nuevo usuario
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

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
      default:
        message = e.message ?? message;
        break;
    }

    Fluttertoast.showToast(msg: message);
  }
}
