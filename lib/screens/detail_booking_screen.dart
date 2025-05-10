import 'package:flutter/material.dart';
import 'package:moderent/screens/booking_summary_screen.dart';
import 'package:moderent/services/book_service.dart';
import 'package:moderent/services/vehicle_service.dart';
import 'package:moderent/widgets/car_card.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';
import 'package:moderent/screens/detail_screen.dart';
import 'package:moderent/services/bank_transfer_service.dart';

class DetailBookingScreen extends StatefulWidget {
  final int vehicleId;
  final int deliveryLocation;

  const DetailBookingScreen({
    super.key,
    required this.vehicleId,
    required this.deliveryLocation,
  });

  @override
  State<DetailBookingScreen> createState() => _DetailBookingScreenState();
}

class _DetailBookingScreenState extends State<DetailBookingScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String selectedBank = 'BCA';
  List<String> bankList = [];
  Map<String, dynamic>? vehicleData;
  bool isLoading = true;

  int rentalPeriod = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchVehicle();
    fetchBankTransfers();
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

  Future<void> fetchBankTransfers() async {
    try {
      final result = await BankTransferService().getBankTransfers();
      if (result != null && result['success']) {
        setState(() {
          bankList = List<String>.from(
            result['bankTransfers']
                .map<String>((bank) => bank['name_bank'] as String)
                .toSet(),
          );
        });
      } else {
        print('Error: ${result?['message']}');
      }
    } catch (e) {
      print('Error fetching bank transfers: $e');
    }
  }

  void _updatePriceAndPeriod() {
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty) {
      try {
        final startParts = _startDateController.text.split('/');
        final endParts = _endDateController.text.split('/');

        final startDate = DateTime(
          int.parse(startParts[2]),
          int.parse(startParts[1]),
          int.parse(startParts[0]),
        );
        final endDate = DateTime(
          int.parse(endParts[2]),
          int.parse(endParts[1]),
          int.parse(endParts[0]),
        );

        if (endDate.isBefore(startDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("End date must be later or equal to start date"),
            ),
          );
          return;
        }

        // Jika end date sama dengan start date, tetap hitung 1 hari
        final int days =
            endDate.difference(startDate).inDays == 0
                ? 1
                : endDate.difference(startDate).inDays;

        final pricePerDay = vehicleData?['rental_price'] ?? 0;
        setState(() {
          rentalPeriod = days;
          totalPrice = (days * pricePerDay).toInt();
        });
      } catch (e) {
        print('Invalid date format: $e');
      }
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
                                      vehicleId: vehicleData?['id'],
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
          _updatePriceAndPeriod(); // update when date changes
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
      child:
          bankList.isEmpty
              ? const Text("No banks available")
              : bankList.length == 1
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(bankList[0]),
              )
              : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: bankList.contains(selectedBank) ? selectedBank : null,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rental Period: $rentalPeriod days"),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total price:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              formatToIdr(totalPrice),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB981FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _handleContinue,
        child: const Text(
          "Continue to Payment",
          style: TextStyle(color: Colors.white),
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
      final startParts = _startDateController.text.split('/');
      final endParts = _endDateController.text.split('/');

      final startDate =
          DateTime(
            int.parse(startParts[2]),
            int.parse(startParts[1]),
            int.parse(startParts[0]),
          ).toUtc().toIso8601String();

      final endDate =
          DateTime(
            int.parse(endParts[2]),
            int.parse(endParts[1]),
            int.parse(endParts[0]),
          ).toUtc().toIso8601String();

      int bankTransferId = 1;

      final result = await BookService().createBooking(
        vehicleId: widget.vehicleId,
        deliveryLocationId: widget.deliveryLocation,
        bankTransferId: bankTransferId,
        startDate: startDate,
        endDate: endDate,
        notes: _noteController.text,
      );

      print(result);

      if (result != null && result['success']) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookingSummaryScreen(
                    bookingId: result['booking']['booking_id'],
                    vehicleName: result['booking']['vehicle_name'],
                    dateRange: result['booking']['date_range'],
                    rentalPeriod: result['booking']['rental_period'],
                    totalPrice: result['booking']['total_price'],
                    nameBank: result['booking']['name_bank'],
                    number: result['booking']['number'],
                  ),
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
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";
  }
}
