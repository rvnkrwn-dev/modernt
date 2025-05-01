import 'package:flutter/material.dart';
import 'package:moderent/screens/pick_location_screen.dart';
import 'package:moderent/services/address_service.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? pinLocation; // Lokasi yang dipilih
  String? longitude;
  String? latitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Add Address"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPinLocationSection(),
              const SizedBox(height: 24),
              _buildTextField("Full Name", _fullNameController),
              const SizedBox(height: 16),
              _buildTextField(
                "Phone Number",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinLocationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pin Point Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Make sure the pin is placed accurately for smoother delivery.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _choosePinLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pinLocation ?? "Choose Pin Location",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveAddress,
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(350, 48)),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: const WidgetStatePropertyAll(Color(0xFFB981FF)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: const Text('Save', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _choosePinLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PickLocationScreen()),
    );

    if (result != null && result is PickedLocationResult) {
      setState(() {
        pinLocation = result.address;
        latitude = result.latitude.toString();
        longitude = result.longitude.toString();
      });
    }
  }

  void _saveAddress() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (fullName.isEmpty || phone.isEmpty || pinLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields and pick a location."),
        ),
      );
      return;
    }

    final addressService = AddressService();
    final response = await addressService.createAddress(
      fullName: fullName,
      address: pinLocation!,
      phone: phone,
      fullAddress: pinLocation!, // Bisa diatur kalau mau beda full_address
      latitude: latitude!,
      longitude: longitude!,
    );

    if (response != null && response['success'] == true) {
      // Kalau sukses, kembali ke screen sebelumnya
      final addressData = response['address'] as Map;
      final addressStringMap = addressData.map<String, String>(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );

      Navigator.pop(context, addressStringMap);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?['message'] ?? 'Failed to save address'),
        ),
      );
    }
  }
}
