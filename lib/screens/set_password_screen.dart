import 'package:flutter/material.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                "Set New Password",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please enter your new password below. Make sure it’s something secure and easy for you to remember.",
                style: TextStyle(color: Color(0xFF6C7278)),
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set New Password"),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFEDF1F3)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: _passwordController, // Controller for email
                      decoration: InputDecoration(
                        hintText: "********",
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
                  Text("Set New Password"),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFEDF1F3)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: _confirmPasswordController, // Controller for email
                      decoration: InputDecoration(
                        hintText: "********",
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
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;
          
                  // Validate inputs (you can add more validation if needed)
                  if (password.isEmpty || confirmPassword.isEmpty) {
                    // Show error message if fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields")),
                    );
                  } else {
                    // You can handle the login logic here
                    print("Email: $password");

                    if(mounted) {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SetPasswordScreen()));
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