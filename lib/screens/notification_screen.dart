import 'package:flutter/material.dart';
import 'package:moderent/widgets/custom_back_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> todayNotifications = [
    {
      'title': 'Tour Booked Successfully',
      'message': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard.',
      'time': '1h',
    },
    {
      'title': 'Tour Booked Successfully',
      'message': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard.',
      'time': '1h',
    },
  ];

  final List<Map<String, String>> yesterdayNotifications = [
    {
      'title': 'Tour Booked Successfully',
      'message': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard.',
      'time': '1d',
    },
    {
      'title': 'Tour Booked Successfully',
      'message': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard.',
      'time': '1d',
    },
  ];

  Widget buildNotificationItem(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF6EDFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.calendar_today_outlined, color: Color(0xFFB96CFE)),
          ),
          SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  data['message'] ?? '',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // Time
          Text(
            data['time'] ?? '',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<Map<String, String>> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ...notifications.map(buildNotificationItem).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(title: "Notification"),
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildSection("Today", todayNotifications),
              buildSection("Yesterday", yesterdayNotifications),
            ],
          ),
        ),
      ),
    );
  }
}
