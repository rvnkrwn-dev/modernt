import 'package:flutter/material.dart';
import 'package:moderent/screens/verify_screen.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: ""),
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                "Forget Password",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Enter your email and we’ll send you a link to reset your password.",
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
                      controller: _emailController, // Controller for email
                      decoration: InputDecoration(
                        hintText: "your@email.com",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Get the values from the text controllers
                  String email = _emailController.text;
          
                  // Validate inputs (you can add more validation if needed)
                  if (email.isEmpty) {
                    // Show error message if fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields")),
                    );
                  } else {
                    // You can handle the login logic here
                    print("Email: $email");

                    if(mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyScreen()));
                    }
                  }
                },
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(350, 48)),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: WidgetStatePropertyAll(
                    Color(0xFFB981FF),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text("Send OTP", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}