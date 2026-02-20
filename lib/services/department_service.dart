import 'package:firebase_database/firebase_database.dart';

class DepartmentService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ===============================
  // STREAM MODE (Realtime)
  // ===============================
  Stream<String> modeStream(String dept) {
    return _db
        .child("departments/$dept/mode")
        .onValue
        .map((event) => event.snapshot.value?.toString() ?? "");
  }

  // ===============================
  // SET MODE
  // ===============================
  Future<void> setMode(String dept, String mode) async {
    await _db.child("departments/$dept/mode").set(mode);
  }

  // ===============================
  // TRIGGER MANUAL RING
  // ===============================
  Future<void> triggerManualRing(String dept) async {
    await _db.child("departments/$dept/manualRing").set(true);
  }
}