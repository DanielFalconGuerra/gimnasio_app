import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool isInstitutional(String email) {
    final String lower = email.toLowerCase();
    return email.contains('@') && (lower.contains('edu') || lower.contains('uni'));
  }
}
