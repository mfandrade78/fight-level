import 'package:flutter/material.dart';

class CategoryItem extends StateLessWidget {
    final IconData icon;
    final String title;

    const CategoryItem({
        Key? key,
        required this.icon,
        required this.title,
    }) : super(key: key);

    @override
    Widget build(BuildContext context){
        return Column(
            children: [
                Icon(icon, color: const Color(0xFFFF3B30), size: 30),
                const SizedBox(height: 6),
                Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
            ],
        );
    }
}