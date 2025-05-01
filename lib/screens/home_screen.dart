import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/screens/detail_screen.dart';
import 'package:moderent/services/vehicle_service.dart';
import 'package:moderent/screens/notification_screen.dart';
import 'package:moderent/screens/search_screen.dart';
import 'package:moderent/utils/format_to_idr.dart';
import 'package:moderent/widgets/banner_slider.dart';
import 'package:moderent/widgets/car_card.dart';
import 'package:moderent/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();
  final VehicleService _vehicleService = VehicleService();
  List<dynamic> _vehicles = [];
  bool _isLoading = true;
  String _fullName = '';
  String _avatar = 'https://www.sonicboomwellness.com/wp-content/uploads/2020/08/anon-01.png';

  Future<void> _loadUserData() async {
    String? userData = await _storage.read(key: 'user');
    if (userData != null) {
      Map<String, dynamic> user = jsonDecode(userData);
      setState(() {
        _fullName = user['full_name'] ?? user['username'];
        _avatar = user['secure_url_profile'] ?? 'https://www.sonicboomwellness.com/wp-content/uploads/2020/08/anon-01.png';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final result = await _vehicleService.getVehicles();

    if (result != null && result['success']) {
      setState(() {
        _vehicles = result['vehicles'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to load vehicles'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildHeader(_fullName, _avatar),
                        const SizedBox(height: 24),
                        CustomSearchBar(
                          onSubmitted: (value) {
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SearchScreen(keyword: value),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        const BannerSlider(),
                        const SizedBox(height: 24),
                        _buildRecommendedList(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildHeader(String fullName, String avatar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.network(avatar, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hai!"),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEDF1F3)),
                ),
                child: const Icon(Icons.notifications_outlined),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEDF1F3)),
                  ),
                  child: const Center(
                    child: Text(
                      "99+",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Recommended",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      _vehicles.isEmpty
          ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return CarCard(
                  title: vehicle['vehicle_name'] ?? '',
                  price: formatToIdr(vehicle['rental_price']),
                  imageUrl: vehicle['secure_url_image'] ?? '',
                  avatarUrl: vehicle['secure_url_image'] ?? '',
                  onTap: () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            vehicleId: vehicle['id'] ?? 0,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    ],
  );
}

}
