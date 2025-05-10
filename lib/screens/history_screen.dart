import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moderent/screens/upload_payment_proof_screen.dart';
import 'package:moderent/widgets/search_bar.dart';
import 'package:moderent/services/book_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBookingHistory();
  }

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString); // Parse the string to DateTime
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); // Format to 'dd/MM/yyyy'
      return dateFormat.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  // Function to fetch booking history from the API
  Future<void> _fetchBookingHistory() async {
    final bookService = BookService();
    try {
      final response = await bookService.getBookingHistory();

      if (response != null && response['success']) {
        // Check if 'data' is a List
        if (response['data']['data'] is List) {
          setState(() {
            _historyData = List<Map<String, dynamic>>.from(response['data']['data']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Data format is incorrect';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = response?['message'] ?? 'Failed to load data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e";
        _isLoading = false;
      });
    }
  }

  // Function to handle card tap
  void _handleCardTap(Map<String, dynamic> item) {
    // Check if the status is "pending"
    if (item['payment_proof'] == 'unpaid') {
      // Perform action, e.g., navigate to edit screen or show dialog
      if(mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPaymentProofScreen(bookingId: item['booking_id']) ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _historyData.length,
                        itemBuilder: (context, index) {
                          final item = _historyData[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () => _handleCardTap(item),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFEDF1F3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['vehicle']['vehicle_name'] ?? 'Unknown Vehicle',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(0xFFF0F0F0),
                                                ),
                                              ),
                                              child: Text(
                                                item['payment_proof'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6C7278),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(0xFFF0F0F0),
                                                ),
                                              ),
                                              child: Text(
                                                item['rental_status'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6C7278),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Duration: ${item['rental_period'] ?? ''} days',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6C7278),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Date: ${formatDate(item['start_date'] ?? '')} - ${formatDate(item['end_date'] ?? '')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6C7278),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Price: Rp. ${item['total_price'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6C7278),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
