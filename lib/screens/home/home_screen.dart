import 'package:flutter/material.dart';

import 'widgets/action_card.dart';
import 'widgets/category_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.onViewStudents, super.key});

  final VoidCallback onViewStudents;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Matheus',
              style: TextStyle(
                color: Color(0xFFFF3B30),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Do or do not!',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoryItem(icon: Icons.fitness_center, title: 'Workout'),
                CategoryItem(icon: Icons.bar_chart, title: 'Progress\nTracking'),
                CategoryItem(icon: Icons.groups, title: 'Community'),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Students Fight Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: onViewStudents,
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('See All'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFF3B30),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ActionCard(
                    title: 'View students',
                    imageAsset: 'images/Add Student - Fight Level.jpg',
                    onTap: onViewStudents,
                  ),
                  const SizedBox(width: 12),
                  ActionCard(
                    title: 'Muay Thai class',
                    imageAsset: 'images/Muay Thai Class - Fight Level.jpg',
                    onTap: () => _showClassImage(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'images/Muay Thai Class - Fight Level.jpg',
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassImage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('images/Muay Thai Class - Fight Level.jpg'),
        ),
      ),
    );
  }
}