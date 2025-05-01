import 'dart:math' as math;
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final String imageUrl; // banner
  final String avatarUrl; // avatar
  final VoidCallback? onTap;

  const CarCard({
    super.key,
    required this.title,
    required this.price,
    this.duration = "day",
    required this.imageUrl,
    required this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFEDF1F3)),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Banner Image
            AspectRatio(
              aspectRatio: 16 / 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar + title + price
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(price,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            Text("/$duration",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Rotated Button
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFB981FF),
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: -45 * math.pi / 180,
                        child: const Icon(
                          Icons.arrow_right_alt_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
