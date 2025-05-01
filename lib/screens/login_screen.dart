import 'package:flutter/material.dart';
import 'package:moderent/layouts/default.dart';
import 'package:moderent/screens/forget_screen.dart';
import 'package:moderent/screens/register_screen.dart';
import 'package:moderent/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var result = await AuthService().login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result != null && result['success']) {
      // If login is successful, you can navigate to another screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      // Navigate to the next screen if needed
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DefaultLayout()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?['message'] ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/logo-light.png"),
                  SizedBox(height: 32),
                  Text(
                    "Sign in to your Account",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Enter your email and password to log in",
                    style: TextStyle(color: Color(0xFF6C7278)),
                  ),
                  SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFEDF1F3)),
                        ),
                        padding: EdgeInsets.all(12),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "your@email.com",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password"),
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFEDF1F3)),
                        ),
                        padding: EdgeInsets.all(12),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "********",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => {
                        if (mounted) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetScreen()))
                        }
                      },
                      child: Text(
                        "Forget password ?",
                        style: TextStyle(color: Color(0xFF4D81E7)),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login, // Disable button while loading
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(350, 48)),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xFFB981FF),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white) // Show loading spinner
                        : Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => {
                      if (mounted) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                      }
                    },
                    child: Text(
                      "Sign Up",
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
}
