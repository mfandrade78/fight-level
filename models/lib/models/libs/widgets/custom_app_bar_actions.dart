import 'package:flutter/material.dart';

class CustomAppBarActions extends StateLessWidget {
    const CustomAppBarActions({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context){
        return Row(
            MainAxisSize: MainAxisSize.min,
            children: [
                IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFFFF3B30)),
                    onPressed: () {},
                ),
                IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF3B30)),
                    onPressed: () {},
                ),
                IconButton(
                    icon: const Icon(Icons.person_outline, color: Color(0xFFFF3B30)),
                    onPressed: () {},
                ),
            ],
        );
    }
}