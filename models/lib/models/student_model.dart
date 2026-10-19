import 'package:flutter/material.dart';

class Student {
    final String name;
    final String experience;
    final String praijed;
    final color accentColor;
    final String imageUrl;
    final bool hasVideo;

    const student({
        required this.name,
        required this.experience,
        this.praijed = '',
        required this.accentColor,
        required this.imageUrl,
        this.hasVideo = false,
    });
}