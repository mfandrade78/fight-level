import 'package:flutter/material.dart';

class ActionCard extends StateLessWidget {
    final String title,
    final IconData icon,
    final String imageUrl,

    const ActionCard({
        Key? key,
        required this.title,
        required this.icon,
        required this.imageUrl,
    }) : super(key: key);

    @override
    Widget build(BuildContext context){
        return Container(
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
                image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                    ),
                ),
            ),
            child: Stack(
                children: [
                    Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: Text(
                                        title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        ),
    };
}