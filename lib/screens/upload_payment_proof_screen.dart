import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img; // Image processing package
import 'package:moderent/layouts/default.dart';
import 'package:moderent/services/book_service.dart';
import 'package:moderent/widgets/custom_back_appbar.dart'; // BookService to handle upload

class UploadPaymentProofScreen extends StatefulWidget {
  final int bookingId;
  const UploadPaymentProofScreen({super.key, required this.bookingId});

  @override
  State<UploadPaymentProofScreen> createState() =>
      _UploadPaymentProofScreenState();
}

class _UploadPaymentProofScreenState extends State<UploadPaymentProofScreen> {
  File? _selectedImage;
  final BookService _bookService = BookService();

  // Function to pick image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); // You can also use ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to convert image to jpeg or png format
  Future<File> _convertImage(File imageFile) async {
    // Load the image using the image package
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Convert image to JPEG (you can change to PNG if needed)
    final imgList = img.encodeJpg(image, quality: 85); // 85 is the quality percentage
    final newFile = File(imageFile.path.replaceFirst(RegExp(r'\.\w+$'), '.jpg')); // Change extension to .jpg
    await newFile.writeAsBytes(imgList);

    return newFile; // Return the converted image file
  }

  // Submit payment proof
  Future<void> _submitProof() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    // Convert image to JPEG or PNG
    File convertedImage;
    try {
      convertedImage = await _convertImage(_selectedImage!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error converting image: $e')),
      );
      return;
    }

    // Show a loading indicator while uploading
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Upload the converted image using the BookService's method
    final result = await _bookService.uploadPaymentProof(
      bookingId: widget.bookingId,
      image: convertedImage,
    );

    Navigator.pop(context); // Dismiss the loading dialog

    if (result != null && result['success'] != null && result['success']) {
      // If the upload is successful, show a success message
      Fluttertoast.showToast(
        msg: 'Payment proof uploaded successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      if(mounted)  {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DefaultLayout() ));
      }
    } else {
      // If there was an error, show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?['message'] ?? 'Unknown error')),
      );
    }

  }

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
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFB38DF4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _selectedImage != null
                          ? Image.file(_selectedImage!, height: 200)
                          : const Icon(
                              Icons.cloud_upload_outlined,
                              color: Color(0xFFB38DF4),
                              size: 48,
                            ),
                      const SizedBox(height: 16),
                      const Text(
                        'Browse Files',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Format: .jpeg, .png & Max file size: 25 MB',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB38DF4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Browse Files'),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitProof,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB38DF4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
