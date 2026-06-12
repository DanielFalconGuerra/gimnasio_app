import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../services/firestore_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final Profile _profile = Profile(email: '');

  Profile get profile => _profile;

  void updateEmail(String email) {
    _profile.email = email;
    notifyListeners();
  }

  void updateAge(int? age) {
    _profile.age = age;
    notifyListeners();
  }

  void updateWeight(double? weight) {
    _profile.weight = weight;
    notifyListeners();
  }

  void updateHeight(double? height) {
    _profile.height = height;
    notifyListeners();
  }

  void updateLevel(String level) {
    _profile.level = level;
    notifyListeners();
  }

  /// Carga el perfil del usuario desde Firestore
  Future<bool> loadProfile({required String uid}) async {
    try {
      if (Firebase.apps.isNotEmpty) {
        final FirestoreService svc = FirestoreService();
        final Profile? loaded = await svc.loadProfile(uid: uid);
        
        if (loaded != null) {
          _profile.email = loaded.email;
          _profile.age = loaded.age;
          _profile.weight = loaded.weight;
          _profile.height = loaded.height;
          _profile.level = loaded.level;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error loading profile in viewmodel: $e');
    }
    
    return false;
  }

  // Placeholder save - in next phases connect to Firebase/Auth
// 🔑 Modifica tu método saveProfile en lib/viewmodels/profile_viewmodel.dart
  Future<bool> saveProfile() async {
    try {
      if (Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null) {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final FirestoreService svc = FirestoreService();

        // Intentamos guardar en la nube de verdad
        await svc.saveProfile(_profile, uid: uid);
        return true;
      }
    } catch (e) {
      debugPrint('Error saving profile in viewmodel: $e');
      return false; // 👈 Cambia esto a false para que la UI sepa que falló la red
    }

    // Fallback en caso de que no haya sesión iniciada
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }
}
