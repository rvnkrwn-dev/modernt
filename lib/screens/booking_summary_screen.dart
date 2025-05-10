import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk clipboard
import 'package:moderent/screens/upload_payment_proof_screen.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class BookingSummaryScreen extends StatelessWidget {
  final int bookingId;
  final String vehicleName;
  final String dateRange;
  final int rentalPeriod;
  final int totalPrice;
  final String nameBank;
  final String number;

  const BookingSummaryScreen({
    super.key,
    required this.bookingId,
    required this.vehicleName,
    required this.dateRange,
    required this.rentalPeriod,
    required this.totalPrice,
    required this.nameBank,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Booking Summary"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Please transfer the total amount to the account\nbelow before the deadline.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                number,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Menyalin nomor rekening ke clipboard
                                  Clipboard.setData(ClipboardData(text: number));
                                  // Menampilkan snackbar setelah menyalin
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Account number copied to clipboard!"),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.copy_rounded, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            nameBank,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailRow('Vehicle:', vehicleName),
              const SizedBox(height: 16),
              _buildDetailRow('Rental Period:', dateRange),
              const SizedBox(height: 16),
              _buildDetailRow('Total Days:', '$rentalPeriod days'),
              const SizedBox(height: 16),
              _buildDetailRow('Total Price:', 'Rp ${_formatCurrency(totalPrice)}'),
              const SizedBox(height: 16),
              _buildDetailRow('Payment Deadline:', '1 day before start – 23:59 WIB'), // Optional dynamic
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPaymentProofScreen(bookingId: bookingId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB38DF4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
