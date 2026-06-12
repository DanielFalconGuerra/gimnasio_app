import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Controla el inicio de sesión consumiendo el servicio de autenticación nativo
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _mapFirebaseError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Ocurrió un error inesperado al intentar ingresar.';
      notifyListeners();
      return false;
    }
  }

  /// Registra al estudiante y crea automáticamente su documento inicial en Firestore
  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Crear el usuario en Firebase Authentication
      final UserCredential credential = await _authService.register(email, password);

      // 2. Inicializar el perfil en Cloud Firestore de manera segura usando su UID
      if (credential.user != null) {
        await _firestoreService.initializeUser(
          uid: credential.user!.uid,
          email: email,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _mapFirebaseError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al registrar las credenciales institucionales.';
      notifyListeners();
      return false;
    }
  }

  /// Cierra la sesión activa del alumno
  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }

  /// Mapeo técnico y amigable de excepciones nativas de Firebase
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe ningún alumno registrado con este correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Verifica tus datos.';
      case 'email-already-in-use':
        return 'Este correo institucional ya está registrado en otra cuenta.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
      case 'user-disabled':
        return 'Esta cuenta universitaria ha sido deshabilitada.';
      default:
        return 'Error de comunicación con el servidor de la Universidad ($code).';
    }
  }
}