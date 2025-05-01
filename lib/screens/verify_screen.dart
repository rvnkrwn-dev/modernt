import 'package:flutter/material.dart';
import 'package:moderent/screens/set_password_screen.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
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
                "Verify Now",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Enter the code sent to your email to verify your identity.",
                style: TextStyle(color: Color(0xFF6C7278)),
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter OTP"),
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
                        hintText: "1234",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SetPasswordScreen()));
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
                child: Text("Verify", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}