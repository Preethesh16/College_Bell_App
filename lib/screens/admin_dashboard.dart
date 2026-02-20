import 'package:flutter/material.dart';
import '../services/department_service.dart';
import './department_control_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DepartmentService _service = DepartmentService();
  List<String> departments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  void loadDepartments() async {
    final data = await _service.getDepartments();
    setState(() {
      departments = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final dept = departments[index];
                return ListTile(
                  title: Text(dept.toUpperCase()),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DepartmentControlScreen(dept: dept),
                        ),
                      );
                    },
                    child: const Text("Manage"),
                  ),
                );
              },
            ),
    );
  }
}

