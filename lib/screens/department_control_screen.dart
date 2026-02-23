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

class _DepartmentControlScreenState extends State<DepartmentControlScreen>
    with SingleTickerProviderStateMixin {
  final DepartmentService _service = DepartmentService();

  bool loading = true;
  bool systemOnline = true;
  String mode = "college";

  late AnimationController _modeAnimController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    loadDepartmentData();

    _modeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 12).animate(CurvedAnimation(
      parent: _modeAnimController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _modeAnimController.dispose();
    super.dispose();
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

    _modeAnimController.forward(from: 0);
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
    final modeColor =
        mode == "college" ? const Color(0xFF00E5FF) : const Color(0xFFFFB020);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back,
                                color: Color(0xFF94A3B8)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dept.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Department Bell Control Panel",
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // ===== SMALL LOGO =====
                          Opacity(
                            opacity: 0.85,
                            child: Image.asset(
                              "assets/logo.png",
                              height: 40,
                            ),
                          ),

                          const SizedBox(width: 20),

                          // ===== STATUS =====
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

                  // CONTROL ROW
                  SizedBox(
                    height: 110,
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: modeColor
                                        .withOpacity(_glowAnimation.value / 20),
                                    width: 2,
                                  ),
                                ),
                                child: TechCard(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Mode:",
                                            style: TextStyle(
                                                color: Color(0xFF94A3B8)),
                                          ),
                                          const SizedBox(width: 12),
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: modeColor,
                                            ),
                                            child: Text(mode.toUpperCase()),
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
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: TechCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Manual Bell Control",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                ElevatedButton(
                                    onPressed: triggerManualRing,
                                    child: const Text("Ring Now")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SCHEDULE SECTION
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                  onPressed: _pickTimeAndAdd,
                                  child: const Text("Add Time")),
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
                                      child: CircularProgressIndicator());
                                }

                                final times = snapshot.data!;

                                if (times.isEmpty) {
                                  return const Center(
                                      child: Text("No schedule added yet.",
                                          style: TextStyle(
                                              color: Color(0xFF94A3B8))));
                                }

                                return ListView.builder(
                                  itemCount: times.length,
                                  itemBuilder: (context, index) {
                                    return HoverScheduleTile(
                                      minuteValue: times[index],
                                      dept: widget.dept,
                                      mode: mode,
                                      service: _service,
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

class HoverScheduleTile extends StatefulWidget {
  final int minuteValue;
  final String dept;
  final String mode;
  final DepartmentService service;

  const HoverScheduleTile(
      {super.key,
      required this.minuteValue,
      required this.dept,
      required this.mode,
      required this.service});

  @override
  State<HoverScheduleTile> createState() => _HoverScheduleTileState();
}

class _HoverScheduleTileState extends State<HoverScheduleTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final hour = widget.minuteValue ~/ 60;
    final minute = widget.minuteValue % 60;
    final displayTime =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        transform: hovering
            ? (Matrix4.identity()..translate(0, -3))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hovering ? const Color(0xFF00E5FF) : const Color(0xFF1F2937),
          ),
          boxShadow: hovering
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.5),
                    blurRadius: 12,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(displayTime,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            IconButton(
              onPressed: () {
                widget.service
                    .deleteTime(widget.dept, widget.mode, widget.minuteValue);
              },
              icon: Icon(
                Icons.delete_outline,
                color: hovering ? Colors.redAccent : const Color(0xFFFF4D4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
