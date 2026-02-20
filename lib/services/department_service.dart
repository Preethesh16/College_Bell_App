import 'package:firebase_database/firebase_database.dart';

class DepartmentService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<String>> getDepartments() async {
    DatabaseEvent event = await _db.child("departments").once();

    if (!event.snapshot.exists) return [];

    Map data = event.snapshot.value as Map;

    return data.keys.map((e) => e.toString()).toList();
  }

  Future<void> triggerManualRing(String dept) async {
    await _db.child("departments/$dept/manualRing").set(true);
  }

  Future<String> getMode(String dept) async {
    DatabaseEvent event = await _db.child("departments/$dept/mode").once();

    return event.snapshot.value.toString();
  }

  Future<void> setMode(String dept, String mode) async {
    await _db.child("departments/$dept/mode").set(mode);
  }
}
