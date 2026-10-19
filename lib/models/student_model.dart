import 'package:flutter/material.dart';

class Student {
  const Student({
    required this.name,
    required this.experience,
    required this.belt,
    required this.beltColor,
    required this.imageAsset,
    this.hasVideo = false,
  });

  final String name;
  final String experience;
  final String belt;
  final Color beltColor;
  final String imageAsset;
  final bool hasVideo;
}