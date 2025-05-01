import 'package:flutter/material.dart';
import 'package:moderent/screens/upload_payment_proof_screen.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
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
                      'Please transfer the total amount to the account\nabove before the deadline.',
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
                              const Text(
                                '08127423282323',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.copy_rounded, color: Colors.black54),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Image.network(
                            'https://th.bing.com/th/id/OIP.bb0jIrc4JmKYsjI2Wx7S_gHaDt?w=500&h=250&rs=1&pid=ImgDetMain', // pastikan logo BCA ada di assets
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailRow('Vehicle:', 'Innova Cumi Darat FullSpek'),
              const SizedBox(height: 16),
              _buildDetailRow('Rental Period:', 'April 27 - April 30, 2025'),
              const SizedBox(height: 16),
              _buildDetailRow('Total Days:', '3 days'),
              const SizedBox(height: 16),
              _buildDetailRow('Price per Day:', 'Rp 500.000'),
              const SizedBox(height: 16),
              _buildDetailRow('Total Price:', 'Rp 1.500.000'),
              const SizedBox(height: 16),
              _buildDetailRow('Payment Deadline:', 'April 26, 2025 – 23:59 WIB'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan aksi konfirmasi pembayaran
                    if(mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPaymentProofScreen() ));
                    }
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
}
