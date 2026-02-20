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

  Stream<List<int>> scheduleStream(String dept, String mode) {
    return _db
        .child("departments/$dept/schedules/$mode/times")
        .onValue
        .map((event) {
      if (!event.snapshot.exists) return [];

      List<dynamic> raw = event.snapshot.value as List<dynamic>;

      return raw.map((e) => e as int).toList();
    });
  }

  Stream<String> modeStream(String dept) {
    return _db
        .child("departments/$dept/mode")
        .onValue
        .map((event) => event.snapshot.value?.toString() ?? "");
  }

  // ===============================
// ADD TIME
// ===============================
  Future<void> addTime(String dept, String mode, int minuteValue) async {
    DatabaseReference ref =
        _db.child("departments/$dept/schedules/$mode/times");

    DatabaseEvent event = await ref.once();

    List<int> times = [];

    if (event.snapshot.exists) {
      List<dynamic> raw = event.snapshot.value as List<dynamic>;
      times = raw.map((e) => e as int).toList();
    }

    // Prevent duplicate
    if (times.contains(minuteValue)) return;

    times.add(minuteValue);
    times.sort();

    await ref.set(times);
  }

// ===============================
// DELETE TIME
// ===============================
  Future<void> deleteTime(String dept, String mode, int minuteValue) async {
    DatabaseReference ref =
        _db.child("departments/$dept/schedules/$mode/times");

    DatabaseEvent event = await ref.once();

    if (!event.snapshot.exists) return;

    List<dynamic> raw = event.snapshot.value as List<dynamic>;
    List<int> times = raw.map((e) => e as int).toList();

    times.remove(minuteValue);

    await ref.set(times);
  }
}
