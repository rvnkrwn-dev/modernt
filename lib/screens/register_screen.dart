import 'package:flutter/material.dart';
import 'package:moderent/screens/privacy_and_security.dart';
import 'package:moderent/services/auth_service.dart'; // Import AuthService
import 'package:moderent/widgets/custom_back_appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isChecked = false;

  final AuthService _authService = AuthService(); // Instance AuthService

  bool _isLoading = false;

  void _register() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the privacy and security policy")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.register(username, email, password);

    setState(() {
      _isLoading = false;
    });

    if (result != null && result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      if (mounted) {
        Navigator.pop(context); // Balik ke login screen
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?['message'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: ""),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Create an account to continue!",
                    style: TextStyle(color: Color(0xFF6C7278)),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField("Username", "johndoe", _usernameController),
                  const SizedBox(height: 12),
                  _buildTextField("Email", "your@email.com", _emailController),
                  const SizedBox(height: 12),
                  _buildTextField("Set Password", "********", _passwordController, isPassword: true),
                  const SizedBox(height: 12),
                  _buildTextField("Confirm Password", "********", _confirmPasswordController, isPassword: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Row(
                              children: [
                                const Text("I accept with "),
                                GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacyAndSecurityScreen()));
                                    }
                                  },
                                  child: const Text(
                                    "privacy and security",
                                    style: TextStyle(color: Color(0xFF4D81E7)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(350, 48)),
                      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                      backgroundColor: const WidgetStatePropertyAll(
                        Color(0xFFB981FF),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => {
                      if (mounted) {
                        Navigator.pop(context)
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF4D81E7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEDF1F3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
