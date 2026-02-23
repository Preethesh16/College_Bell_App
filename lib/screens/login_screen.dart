import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_dashboard.dart';
import 'secretary_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool loading = false;
  String error = "";

  void login() async {
    setState(() {
      loading = true;
      error = "";
    });

    try {
      final userData = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userData == null) {
        setState(() {
          error = "User not configured in database.";
          loading = false;
        });
        return;
      }

      String role = userData['role'];

      if (role == "admin" || role == "superadmin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboard(),
          ),
        );
      } else if (role == "secretary") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SecretaryDashboard(userData: userData),
          ),
        );
      } else {
        setState(() {
          error = "Invalid role assigned.";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Login failed. Check credentials.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== BACKGROUND GRADIENT =====
          Container(
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
          ),

          // ===== LOGO WATERMARK =====
          Center(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                "assets/logo.png", // place logo in assets
                width: 600,
              ),
            ),
          ),

          // ===== MAIN CONTENT =====
          Row(
            children: [
              // LEFT INFO PANEL
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COLLEGE BELL",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Automated Bell Control System",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // RIGHT LOGIN CARD
              Expanded(
                child: Center(
                  child: Container(
                    width: 380,
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1F2937)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Secure Login",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // EMAIL
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            filled: true,
                            fillColor: const Color(0xFF111827),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF1F2937)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // PASSWORD
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            filled: true,
                            fillColor: const Color(0xFF111827),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF1F2937)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    "LOGIN",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        if (error.isNotEmpty)
                          Text(
                            error,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ===== FOOTER =====
          const Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Powered by ARC-SJEC",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Automation & Robotics Club",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
