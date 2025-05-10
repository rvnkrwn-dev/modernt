import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/screens/login_screen.dart'; // Impor LoginScreen untuk navigasi
import 'package:moderent/screens/privacy_and_security.dart';
import 'package:moderent/screens/setting_profile_screen.dart';
import 'package:moderent/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = FlutterSecureStorage();
  String _userName = '';
  String _userEmail = '';
  String _userProfileImage =
      'https://www.sonicboomwellness.com/wp-content/uploads/2020/08/anon-01.png'; // Default image

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk membaca data user dari storage
  Future<void> _loadUserData() async {
    String? userData = await _storage.read(key: 'user');

    if (userData != null) {
      Map<String, dynamic> user = jsonDecode(userData);

      setState(() {
        _userName = user['username'] ?? 'No Name';
        _userEmail = user['email'] ?? 'No Email';
        _userProfileImage =
            user['secure_url_profile'] ??
            'https://www.sonicboomwellness.com/wp-content/uploads/2020/08/anon-01.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(_userProfileImage),
              ),
              const SizedBox(height: 16),
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                overflow:
                    TextOverflow
                        .ellipsis, // Prevents overflow if text is too long
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                _userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                overflow: TextOverflow.ellipsis, // Prevents overflow
                maxLines: 1,
              ),
              const SizedBox(height: 32),
              buildMenuItem('Profile', SettingProfileScreen()),
              buildMenuItem('Privacy & Security', PrivacyAndSecurityScreen()),
              buildMenuItem('Log out', null, () async {
                // Call logout when the menu item is tapped
                await AuthService().logout();

                // You can add navigation or show a message based on the result
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
    String title,
    Widget? widget, [
    Function()? onTapAction,
  ]) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            if (onTapAction != null) {
              onTapAction(); // Menjalankan fungsi logout jika ada
            } else if (widget != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          child: const Divider(thickness: 1),
        ),
      ],
    );
  }
}
