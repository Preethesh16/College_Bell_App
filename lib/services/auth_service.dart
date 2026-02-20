import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      String uid = cred.user!.uid;

      DatabaseEvent event = await _db.child("users/$uid").once();

      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
