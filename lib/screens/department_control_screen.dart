import 'package:flutter/material.dart';
import '../services/department_service.dart';

class DepartmentControlScreen extends StatefulWidget {
  final String dept;
  const DepartmentControlScreen({super.key, required this.dept});

  @override
  State<DepartmentControlScreen> createState() =>
      _DepartmentControlScreenState();
}

class _DepartmentControlScreenState extends State<DepartmentControlScreen> {
  final DepartmentService _service = DepartmentService();

  String formatTime(int minutes) {
    int hrs = minutes ~/ 60;
    int mins = minutes % 60;

    String h = hrs.toString().padLeft(2, '0');
    String m = mins.toString().padLeft(2, '0');

    return "$h:$m";
  }

  void changeMode(String mode) async {
    await _service.setMode(widget.dept, mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.dept.toUpperCase()} Control"),
      ),
      body: StreamBuilder<String>(
        stream: _service.modeStream(widget.dept),
        builder: (context, modeSnapshot) {
          if (!modeSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          String currentMode = modeSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Mode: $currentMode",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _service.triggerManualRing(widget.dept),
                  child: const Text("🔔 Ring Bell Now"),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Schedule Times",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<int>>(
                    stream: _service.scheduleStream(widget.dept, currentMode),
                    builder: (context, scheduleSnapshot) {
                      if (!scheduleSnapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      List<int> times = scheduleSnapshot.data!;

                      if (times.isEmpty) {
                        return const Text("No schedule set.");
                      }

                      return ListView.builder(
                        itemCount: times.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(formatTime(times[index])),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Change Mode"),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => changeMode("college"),
                      child: const Text("College"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => changeMode("exam"),
                      child: const Text("Exam"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
