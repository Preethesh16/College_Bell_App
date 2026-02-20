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
  String currentMode = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMode();
  }

  void loadMode() async {
    String mode = await _service.getMode(widget.dept);
    setState(() {
      currentMode = mode;
      loading = false;
    });
  }

  void changeMode(String mode) async {
    await _service.setMode(widget.dept, mode);
    loadMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.dept.toUpperCase()} Control")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("Current Mode: $currentMode",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _service.triggerManualRing(widget.dept),
                    child: const Text("Ring Bell Now"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => changeMode("college"),
                    child: const Text("Set College Mode"),
                  ),
                  ElevatedButton(
                    onPressed: () => changeMode("exam"),
                    child: const Text("Set Exam Mode"),
                  ),
                ],
              ),
            ),
    );
  }
}
