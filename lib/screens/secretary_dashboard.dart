import 'package:flutter/material.dart';
import '../services/department_service.dart';
import 'department_control_screen.dart';

class SecretaryDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SecretaryDashboard({super.key, required this.userData});

  @override
  State<SecretaryDashboard> createState() => _SecretaryDashboardState();
}

class _SecretaryDashboardState extends State<SecretaryDashboard> {
  final DepartmentService _service = DepartmentService();
  List<String> allowedDepartments = [];

  @override
  void initState() {
    super.initState();

    if (widget.userData.containsKey("departments")) {
      Map departments = widget.userData["departments"] as Map;

      allowedDepartments = departments.keys.map((e) => e.toString()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secretary Dashboard"),
      ),
      body: allowedDepartments.isEmpty
          ? const Center(
              child: Text("No departments assigned."),
            )
          : ListView.builder(
              itemCount: allowedDepartments.length,
              itemBuilder: (context, index) {
                final dept = allowedDepartments[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      dept.toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DepartmentControlScreen(
                              dept: dept,
                            ),
                          ),
                        );
                      },
                      child: const Text("Manage"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
