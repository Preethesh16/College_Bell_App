import 'package:flutter/material.dart';
import '../services/department_service.dart';
import './department_control_screen.dart';
import '../widgets/tech_card.dart';
import '../widgets/tech_sidebar.dart';
import '../widgets/status_dot.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 1;
  bool systemOnline = false;
  bool loading = true;

  final DepartmentService _service = DepartmentService();
  List<String> departments = [];

  String lastSyncTime = "--";

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  void loadDepartments() async {
    try {
      final data = await _service.getDepartments();

      setState(() {
        departments = data;
        loading = false;
        systemOnline = true;
        lastSyncTime = TimeOfDay.now().format(context);
      });
    } catch (e) {
      setState(() {
        loading = false;
        systemOnline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ================= SIDEBAR =================
          TechSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });

              if (index == 2) {
                Navigator.pop(context);
              }
            },
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== Header Section =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Departments",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Manage and monitor department bell schedules",
                                  style: TextStyle(color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                StatusDot(
                                  color: systemOnline
                                      ? const Color(0xFF00FF9C)
                                      : const Color(0xFFFF4D4D),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  systemOnline
                                      ? "System Online"
                                      : "System Offline",
                                  style: TextStyle(
                                    color: systemOnline
                                        ? const Color(0xFF00FF9C)
                                        : const Color(0xFFFF4D4D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        const Divider(color: Color(0xFF1F2937)),
                        const SizedBox(height: 30),

                        // ===== KPI CARDS =====
                        Row(
                          children: [
                            Expanded(
                              child: TechCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Departments",
                                      style:
                                          TextStyle(color: Color(0xFF94A3B8)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      departments.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00E5FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const SizedBox(width: 25),
                            // Expanded(
                            //   child: TechCard(
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const Text(
                            //           "System Status",
                            //           style:
                            //               TextStyle(color: Color(0xFF94A3B8)),
                            //         ),
                            //         const SizedBox(height: 12),
                            //         Text(
                            //           systemOnline ? "ONLINE" : "OFFLINE",
                            //           style: TextStyle(
                            //             fontSize: 28,
                            //             fontWeight: FontWeight.bold,
                            //             color: systemOnline
                            //                 ? const Color(0xFF00FF9C)
                            //                 : const Color(0xFFFF4D4D),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: TechCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Last Sync",
                                      style:
                                          TextStyle(color: Color(0xFF94A3B8)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      lastSyncTime,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // ===== DEPARTMENT GRID =====
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 25,
                              mainAxisSpacing: 25,
                              mainAxisExtent: 200,
                            ),
                            itemCount: departments.length,
                            itemBuilder: (context, index) {
                              final dept = departments[index];

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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 40,
                                      color: Color(0xFF00E5FF),
                                    ),
                                    Text(
                                      dept.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      "Manage department bells",
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                      ),
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
        ],
      ),
    );
  }
}
