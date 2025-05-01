import 'package:flutter/material.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class PrivacyAndSecurityScreen extends StatefulWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  State<PrivacyAndSecurityScreen> createState() => _PrivacyAndSecurityScreenState();
}

class _PrivacyAndSecurityScreenState extends State<PrivacyAndSecurityScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Privacy & Security"),
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 20,
              children: [
                  Text("We respect your privacy and are fully committed to protecting the personal information you provide through this rental application. This policy outlines how we collect, use, and safeguard your data when you use our services.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("When you register or place a rental order, we collect basic personal information including your full name, phone number, email address, and home or delivery address. This data is necessary to manage your booking, deliver the vehicle to your location, and provide support when needed.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("Our application may also request access to your location (GPS) to help us determine the most accurate delivery point for the vehicle you rent. Location data is used only during the delivery process and is not stored permanently after your rental is complete.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("We do not collect sensitive information beyond what is required to deliver our services effectively. All data you provide is stored securely in our system, and we implement appropriate technical and organizational measures to prevent unauthorized access, loss, or misuse of your information. These include secure server storage, limited access, and encrypted communication when applicable. We do not share, sell, or rent your personal data to any third party. The information is only accessible to authorized personnel within our team who are responsible for processing your orders and managing customer service.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("By using our application, you agree to the collection and use of your personal data as described in this policy. If you have any questions or wish to update or remove your information from our system, you may contact us at any time.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("We may update this policy from time to time to reflect changes in our services or to comply with new legal requirements. Any significant updates will be communicated through the app.", style: TextStyle(color: Color(0xFF6C7278)),),
                  Text("Your trust is important to us, and we are dedicated to keeping your information safe throughout your rental experience.", style: TextStyle(color: Color(0xFF6C7278)),),
                ],
            ),
          ),
        ),
      ),
    );
  }
}