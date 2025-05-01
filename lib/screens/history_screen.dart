import 'package:flutter/material.dart';
import 'package:moderent/widgets/search_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _historyData = [
    {
      'name': 'Innova Cumi Darat FullSpek',
      'type': 'Car',
      'duration': '3 days',
      'date': '12 Apr 2025 - 15 Apr 2025',
      'price': 'Rp. 1.500.000',
      'status': 'Paid',
    },
    {
      'name': 'Yamaha R15 V4',
      'type': 'Motorbike',
      'duration': '2 days',
      'date': '5 May 2025 - 7 May 2025',
      'price': 'Rp. 500.000',
      'status': 'Unpaid',
    },
    {
      'name': 'Honda Jazz RS',
      'type': 'Car',
      'duration': '1 week',
      'date': '1 Jun 2025 - 8 Jun 2025',
      'price': 'Rp. 3.200.000',
      'status': 'Paid',
    },
    {
      'name': 'Kawasaki Ninja 250',
      'type': 'Motorbike',
      'duration': '1 day',
      'date': '10 Jul 2025 - 11 Jul 2025',
      'price': 'Rp. 300.000',
      'status': 'Canceled',
    },
    {
      'name': 'Toyota Alphard',
      'type': 'Car',
      'duration': '5 days',
      'date': '15 Aug 2025 - 20 Aug 2025',
      'price': 'Rp. 5.500.000',
      'status': 'Paid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
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
              SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _historyData.length,
                  itemBuilder: (context, index) {
                    final item = _historyData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFEDF1F3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Color(0xFFF0F0F0)),
                                  ),
                                  child: Text(
                                    item['status'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6C7278),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['type'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6C7278),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['duration'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6C7278),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['date'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6C7278),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['price'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6C7278),
                              ),
                            ),
                          ],
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
