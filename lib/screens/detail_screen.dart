import 'package:flutter/material.dart';
import 'package:moderent/screens/delivery_address_screen.dart';
import 'package:moderent/services/vehicle_service.dart';
import 'package:moderent/utils/format_to_idr.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class DetailScreen extends StatefulWidget {
  final int vehicleId;

  const DetailScreen({super.key, required this.vehicleId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? vehicleData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicle();
  }

  Future<void> fetchVehicle() async {
    final data = await VehicleService().getVehicleById(widget.vehicleId);
    setState(() {
      // Ensure the correct key is used, and the response is handled properly
      vehicleData = data?['vehicle']; // Assuming the API returns 'vehicle' not 'vehicles'
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Detail"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ensure the image URL is valid
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: vehicleData?['secure_url_image'] != null
                          ? Image.network(
                              vehicleData!['secure_url_image'] ?? '',
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Ensure the brand image is available
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: vehicleData?['brand']?['public_url_image'] != null
                                    ? Image.network(
                                        vehicleData!['brand']?['public_url_image'] ?? '',
                                        width: 30,
                                      )
                                    : const Icon(Icons.car_repair, size: 30),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vehicleData?['vehicle_name'] ?? 'Unknown Vehicle',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatToIdr(vehicleData?['rental_price']),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SpecItem(
                                icon: Icons.directions_car,
                                label: "Type",
                                value: vehicleData?['vehicle_type'] ?? 'N/A',
                              ),
                              _SpecItem(
                                icon: Icons.calendar_today,
                                label: "Year",
                                value: vehicleData?['year']?.toString().substring(0, 4) ?? 'N/A',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SpecItem(
                                icon: Icons.event_seat,
                                label: "Seats",
                                value: vehicleData?['seats']?.toString() ?? 'N/A',
                              ),
                              _SpecItem(
                                icon: Icons.bolt,
                                label: "HP",
                                value: vehicleData?['horse_power']?.toString() ?? 'N/A',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full Specifications & Features',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          // Ensure specification list is valid and non-null
                          ...(vehicleData?['specification_list']?.split(',') ?? [])
                              .map((feature) => _BulletPoint(text: feature.trim()))
                              .toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            vehicleData?['description'] ?? 'No description available.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Bottom padding for buttons
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isLoading
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        print('Message Us for ID: ${widget.vehicleId}');
                      },
                      style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(350, 48)),
                      shadowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 112, 112, 112)),
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                      child: const Text(
                        'Message Us',
                        style: TextStyle(color: Color(0xFF7F56D9)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if(mounted){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryAddressScreen(vehicleId: widget.vehicleId)));
                        }
                      },
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
                      child: const Text(
                        'Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
