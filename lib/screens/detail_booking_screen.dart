import 'package:flutter/material.dart';
import 'package:moderent/screens/booking_summary_screen.dart';
import 'package:moderent/services/book_service.dart';
import 'package:moderent/services/vehicle_service.dart';
import 'package:moderent/widgets/car_card.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';
import 'package:moderent/screens/detail_screen.dart';

class DetailBookingScreen extends StatefulWidget {
  final int vehicleId;
  final int delivery_location;

  const DetailBookingScreen({
    super.key,
    required this.vehicleId,
    required this.delivery_location,
  });

  @override
  State<DetailBookingScreen> createState() => _DetailBookingScreenState();
}

class _DetailBookingScreenState extends State<DetailBookingScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String selectedBank = 'BCA';
  List<String> bankList = ['BCA', 'BNI', 'Mandiri', 'BRI'];

  Map<String, dynamic>? vehicleData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicle();
  }

  Future<void> fetchVehicle() async {
    try {
      final data = await VehicleService().getVehicleById(widget.vehicleId);
      if (data != null) {
        setState(() {
          vehicleData = data['vehicle'];
        });
      }
    } catch (e) {
      print('Error fetching vehicle: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Detail Booking"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : vehicleData == null
                ? const Center(child: Text('Vehicle data not found'))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarCard(
                        title: vehicleData?['vehicle_name'] ?? '',
                        price: formatToIdr(vehicleData?['rental_price'] ?? 0),
                        imageUrl: vehicleData?['secure_url_image'] ?? '',
                        avatarUrl: vehicleData?['secure_url_image'] ?? '',
                        onTap: () {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailScreen(
                                      vehicleId: vehicleData?['id'] ?? 0,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildLabel("Start Date"),
                      _buildDateField(
                        _startDateController,
                        "Select Start Date",
                      ),
                      const SizedBox(height: 16),
                      _buildLabel("End Date"),
                      _buildDateField(_endDateController, "Select End Date"),
                      const SizedBox(height: 16),
                      _buildLabel("Select Bank (Transfer)"),
                      _buildBankDropdown(),
                      const SizedBox(height: 16),
                      _buildLabel("Booking Note"),
                      _buildNoteField(),
                      const SizedBox(height: 24),
                      _buildTotalPrice(),
                      const SizedBox(height: 24),
                      _buildContinueButton(),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w500));
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBank,
          items:
              bankList.map((bank) {
                return DropdownMenuItem(value: bank, child: Text(bank));
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBank = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Add any notes for this booking (optional)",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total price :",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          formatToIdr(vehicleData?['rental_price'] ?? 0),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(350, 48)),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: const WidgetStatePropertyAll(Color(0xFFB981FF)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        onPressed: _handleContinue,
        child: const Text(
          "Continue to Payment",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _handleContinue() async {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select start and end date")),
      );
      return;
    }

    try {
      // Format tanggal ke ISO (karena kamu minta ISO format di createBooking)
      final startDateParts = _startDateController.text.split('/');
      final endDateParts = _endDateController.text.split('/');

      final startDate =
          DateTime(
            int.parse(startDateParts[2]),
            int.parse(startDateParts[1]),
            int.parse(startDateParts[0]),
          ).toUtc().toIso8601String();

      final endDate =
          DateTime(
            int.parse(endDateParts[2]),
            int.parse(endDateParts[1]),
            int.parse(endDateParts[0]),
          ).toUtc().toIso8601String();

      // Sementara, anggap bank_transfer_id = 1 (karena kamu cuma pilih nama bank aja di UI)
      int bankTransferId = 1; // kamu bisa nanti mapping sesuai bank

      final result = await BookService().createBooking(
        vehicleId: widget.vehicleId,
        deliveryLocationId: widget.delivery_location,
        bankTransferId: bankTransferId,
        startDate: startDate,
        endDate: endDate,
        notes: _noteController.text,
      );

      if (result != null && result['success'] == true) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookingSummaryScreen(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to create booking'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  String formatToIdr(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }
}
