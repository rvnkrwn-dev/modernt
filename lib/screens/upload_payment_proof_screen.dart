import 'package:flutter/material.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class UploadPaymentProofScreen extends StatefulWidget {
  const UploadPaymentProofScreen({super.key});

  @override
  State<UploadPaymentProofScreen> createState() => _UploadPaymentProofScreenState();
}

class _UploadPaymentProofScreenState extends State<UploadPaymentProofScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Upload Payment Proof"),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Please upload the receipt or screenshot of your\nbank transfer to complete your booking.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFB38DF4),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Color(0xFFB38DF4),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'browse Files',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Format: .jpeg, .png & Max file size: 25 MB',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Aksi untuk pilih file
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB38DF4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Browse Files'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi submit file
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB38DF4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
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
}
