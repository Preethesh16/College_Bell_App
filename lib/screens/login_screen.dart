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
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "College Bell Login",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
              const SizedBox(height: 10),
              Text(error, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
