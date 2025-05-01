import 'package:flutter/material.dart';
import 'package:moderent/screens/address_screen.dart';
import 'package:moderent/screens/detail_booking_screen.dart';
import 'package:moderent/services/address_service.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final int vehicleId;
  const DeliveryAddressScreen({super.key, required this.vehicleId});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  List<Map<String, String>> addresses = [];
  final AddressService _addressService = AddressService(); // Tambahkan ini

  @override
  void initState() {
    super.initState();
    _fetchAddresses(); // Panggil saat init
  }

  Future<void> _fetchAddresses() async {
    final response = await _addressService.getAddresses();

    if (!mounted) return; // Cek kalau widget masih ada

    if (response?['success'] == true) {
      final List<dynamic> fetchedAddresses = response?['addresses'] ?? [];

      // Mapping List<dynamic> ke List<Map<String, String>>
      setState(() {
        addresses =
            fetchedAddresses.map<Map<String, String>>((address) {
              return {
                'id': address['id'].toString(), // <-- tambah ini
                'name': address['full_name'] ?? '',
                'phone': address['phone'] ?? '',
                'address': address['address'] ?? '',
              };
            }).toList();
      });
    } else {
      // Bisa tambahkan snackbar/toast kalau gagal
      print(response?['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Delivery Addresses"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: addresses.isEmpty ? _buildEmptyAddress() : _buildAddressList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _navigateToAddAddress,
          style: ButtonStyle(
            minimumSize: const WidgetStatePropertyAll(Size(350, 48)),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFB981FF)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          child: const Text(
            'Add Address',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAddAddress() async {
    final newAddress = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const AddressScreen()),
    );

    print(newAddress);

    if (!mounted) return;

    if (newAddress != null) {
      setState(() {
        addresses = [...addresses, newAddress];
      });
    }
  }

  Widget _buildEmptyAddress() {
    return const Center(
      child: Text(
        "No addresses added yet.",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressHeader(address['name'] ?? '', index),
                const SizedBox(height: 8),
                Text(address['phone'] ?? ''),
                const SizedBox(height: 4),
                Text(address['address'] ?? ''),
                const SizedBox(height: 16),
                _buildActionButtons(index),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressHeader(String name, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () => _removeAddress(index),
        ),
      ],
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _updateAddress(index),
            child: const Text("Update"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _useAddress(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBB86FC),
            ),
            child: const Text("Use Address"),
          ),
        ),
      ],
    );
  }

  void _removeAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }

  void _updateAddress(int index) {
    // Nanti bisa dibuka screen edit, untuk sekarang contoh dummy:
    setState(() {
      addresses[index]['name'] = addresses[index]['name']! + " (Updated)";
    });
  }

  void _useAddress(int index) {
  final idString = addresses[index]['id']; // ambil dari addresses[index], bukan addresses[1]
  print(idString);
  if (idString == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address ID not found")),
    );
    return;
  }

  final deliveryLocationId = int.parse(idString);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailBookingScreen(
        vehicleId: widget.vehicleId,
        delivery_location: deliveryLocationId,
      ),
    ),
  );
}

}
