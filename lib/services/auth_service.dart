import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ================= LOGIN =================
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return null;

      final uid = user.uid;

      DatabaseEvent event = await _db.child("users/$uid").once();

      if (!event.snapshot.exists) return null;

      return Map<String, dynamic>.from(event.snapshot.value as Map);
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ================= CURRENT USER (Optional Utility) =================
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
