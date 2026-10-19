import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar_actions.dart';
import 'widgets/category_item.dart';
import 'widgets/action_card.dart';

class HomeScreen extends StateLessWidget {
    const HomeScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context){
        return SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal:  16.0, vertical: 12.0),
                child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                        //header
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween.
                            children: [
                                Column(
                                    crossAxisAlignment: CrossAlignment.start,
                                    children: const [
                                        Text(
                                            'Hi, Matheus',
                                            style: TextStyle(
                                                color: Color(0xFFFF3B30),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                            'Do or do not!',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                            ),
                                        ),
                                    ],
                                ),
                                const CustomAppBarActions(),
                            ],
                        ),
                        const SizedBox(height: 20).

                        //Categorias
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                                CategoryItem(icon: Icons.fitness_center, title: 'Workout'),
                                CategoryItem(icon: Icons.bar_chart, title: 'Progress\nTracking'),
                                CategoryItem(icon: Icons.groups, title: 'Community'),
                            ],
                        ),
                        const SizedBox(height: 25),

                        //Seção de Cabeçalho
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
                                InkWell(
                                    onTap: () {},
                                    child: Row(
                                        children: const [
                                            Text(
                                                'See All',
                                                style: TextStyle(color: Color(0xFFFF3B30), fontSize: 12),
                                            ),
                                            Icon(Icons.arrow_right, color: Color(0xFFFF3B30), size: 18),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 12),

                        //Cards Deslizantes
                        SizedBox(
                            height: 140,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: const [
                                    ActionCard(
                                        title: 'Insert Student',
                                        icon: Icons.add_circle,
                                        imageUrl: 'https://picsum.photos/300/200?random=1',
                                    ),
                                    SizedBox(width: 12),
                                    ActionCard(
                                        title: 'Remove Student',
                                        icon: Icons.remove_circle,
                                        imageUrl: 'https://picsum.photos/300/200?random=2',
                                    ),
                                ],
                            ),
                        ),
                        const SizedBox(height: 20),

                        //Card Principal
                        Container(
                            height: 180,
                            decoration: BoxDecoration(
                                color: const Color(0xFFFF3B30).
                                borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                    'https://picsum.photos/600/300?random=3',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}