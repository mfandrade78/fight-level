import 'package:flutter/material.dart';

class FilterChipWidget extends StateLessWidget {
    final String label;
    final bool isSelected;
    final VoidCallback onTap;

    const FilterChipWidget({
        Key? key,
        required this.label,
        required this.isSelected,
        required this.onTap,
    }) : super(key: key);

    @override
    Widget build(BuildContext context){
        return GestureDetector(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF3B30) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                    label,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                    ),
                ),
            ),
        );
    }

}

