import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import 'widgets/filter_chip_widget.dart';
import 'widgets/student_card_widget.dart';

class StudentsLevelScreen extends StatefulWidget {
  const StudentsLevelScreen({super.key});

  @override
  State<StudentsLevelScreen> createState() => _StudentsLevelScreenState();
}

class _StudentsLevelScreenState extends State<StudentsLevelScreen> {
  String _selectedFilter = 'All';

  static const List<Student> _students = [
    Student(
      name: 'Francisco M.',
      experience: '4y Experience',
      belt: 'Blue belt',
      beltColor: Colors.blue,
      imageAsset: 'images/Francisco M. - Fight Level.jpg',
      hasVideo: true,
    ),
    Student(
      name: 'Larissa N.',
      experience: '2y Experience',
      belt: 'Yellow/white belt',
      beltColor: Colors.amber,
      imageAsset: 'images/Larissa N. - Fight Level.jpg',
    ),
    Student(
      name: 'Hellen O.',
      experience: '3y Experience',
      belt: 'Green belt',
      beltColor: Colors.green,
      imageAsset: 'images/Hellen O. - Fight Level.jpg',
      hasVideo: true,
    ),
    Student(
      name: 'Marcos P.',
      experience: '3y Experience',
      belt: 'Green belt',
      beltColor: Colors.green,
      imageAsset: 'images/Marcos P. - Fight Level.jpg',
    ),
    Student(
      name: 'Victoria R.',
      experience: '1y Experience',
      belt: 'White belt',
      beltColor: Colors.white,
      imageAsset: 'images/Victoria R. - Fight Level.jpg',
    ),
  ];

  List<Student> get _visibleStudents {
    final students = switch (_selectedFilter) {
      'Alphabet' => [..._students]..sort((a, b) => a.name.compareTo(b.name)),
      'Media' => _students.where((student) => student.hasVideo).toList(),
      _ => _students,
    };
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Students Level',
              style: TextStyle(
                color: Color(0xFFFF3B30),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(width: 10),
                for (final filter in const ['All', 'Alphabet', 'Media']) ...[
                  FilterChipWidget(
                    label: filter,
                    isSelected: _selectedFilter == filter,
                    onTap: () => setState(() => _selectedFilter = filter),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              key: ValueKey(_selectedFilter),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: _visibleStudents.length,
              itemBuilder: (context, index) =>
                  StudentCardWidget(student: _visibleStudents[index]),
            ),
          ),
        ],
      ),
    );
  }
}