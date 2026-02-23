import 'package:flutter/material.dart';
import '../services/department_service.dart';
import '../widgets/tech_card.dart';
import '../widgets/status_dot.dart';

class DepartmentControlScreen extends StatefulWidget {
  final String dept;

  const DepartmentControlScreen({super.key, required this.dept});

  @override
  State<DepartmentControlScreen> createState() =>
      _DepartmentControlScreenState();
}

class _DepartmentControlScreenState extends State<DepartmentControlScreen> {
  final DepartmentService _service = DepartmentService();

  bool loading = true;
  bool systemOnline = true;
  String mode = "college";

  @override
  void initState() {
    super.initState();
    loadDepartmentData();
  }

  void loadDepartmentData() async {
    try {
      final currentMode = await _service.getMode(widget.dept);

      setState(() {
        mode = currentMode;
        loading = false;
        systemOnline = true;
      });
    } catch (e) {
      setState(() {
        loading = false;
        systemOnline = false;
      });
    }
  }

  void toggleMode() async {
    final newMode = mode == "college" ? "exam" : "college";
    await _service.setMode(widget.dept, newMode);

    setState(() {
      mode = newMode;
    });
  }

  void triggerManualRing() async {
    await _service.triggerManualRing(widget.dept);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bell triggered successfully"),
        backgroundColor: Color(0xFF00E5FF),
      ),
    );
  }

  void _pickTimeAndAdd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final minuteValue = picked.hour * 60 + picked.minute;
    await _service.addTime(widget.dept, mode, minuteValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dept.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Department Bell Control Panel",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
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
                            systemOnline ? "Connected" : "Disconnected",
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

                  // ================= CONTROL ROW =================
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        // MODE CARD (slightly smaller)
                        Expanded(
                          flex: 5,
                          child: TechCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Mode",
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      mode.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: mode == "college"
                                            ? const Color(0xFF00E5FF)
                                            : const Color(0xFFFFB020),
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: toggleMode,
                                  child: const Text("Toggle"),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 25),

                        // MANUAL CARD (slightly larger)
                        Expanded(
                          flex: 6,
                          child: TechCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Manual Bell Control",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: triggerManualRing,
                                  child: const Text("Ring Now"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ================= SCHEDULE =================
                  Expanded(
                    child: TechCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Schedule Management",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _pickTimeAndAdd,
                                child: const Text("Add Time"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Expanded(
                            child: StreamBuilder<List<int>>(
                              stream:
                                  _service.scheduleStream(widget.dept, mode),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final times = snapshot.data!;

                                if (times.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "No schedule added yet.",
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  itemCount: times.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final minuteValue = times[index];

                                    final hour = minuteValue ~/ 60;
                                    final minute = minuteValue % 60;

                                    final displayTime =
                                        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F172A),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFF1F2937),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            displayTime,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _service.deleteTime(widget.dept,
                                                  mode, minuteValue);
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Color(0xFFFF4D4D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
      ),
    );
  }
}
