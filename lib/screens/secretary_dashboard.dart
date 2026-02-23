import 'package:flutter/material.dart';
import '../services/department_service.dart';
import 'department_control_screen.dart';
import '../widgets/tech_card.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050F1E),
              Color(0xFF071426),
              Color(0xFF081B30),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: allowedDepartments.isEmpty
              ? const Center(
                  child: Text(
                    "No departments assigned.",
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Secretary Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Manage your assigned department bells",
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                          mainAxisExtent: 160,
                        ),
                        itemCount: allowedDepartments.length,
                        itemBuilder: (context, index) {
                          final dept = allowedDepartments[index];

                          return TechCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DepartmentControlScreen(dept: dept),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 40,
                                      color: Color(0xFF00E5FF),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      dept.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DepartmentControlScreen(dept: dept),
                                      ),
                                    );
                                  },
                                  child: const Text("Manage"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
