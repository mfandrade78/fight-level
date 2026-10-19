import 'package:flutter/material.dart';

void main() => runApp(const FightLevelApp());

// ---------------------------------------------------------------------------
// Cores
// ---------------------------------------------------------------------------
class AppColors {
  static const background = Color(0xFF1F1F1F);
  static const red = Color(0xFFF93B3B);
  static const orange = Color(0xFFE8A324);
  static const cardBorder = Color(0xFF4A4A4A);
  static const lightText = Color(0xFFE6E6E6);
}

class FightLevelApp extends StatelessWidget {
  const FightLevelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fight Level',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Imagem com fallback: se o arquivo não existir em assets/images/, mostra
// um placeholder em vez de quebrar o app.
// ---------------------------------------------------------------------------
class AppImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  const AppImage(this.path, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A3A3A), Color(0xFF151515)],
          ),
        ),
        child: const Center(
          child: Icon(Icons.sports_mma, color: Colors.white24, size: 36),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barra de navegação inferior (vermelha)
// ---------------------------------------------------------------------------
class FightBottomNav extends StatelessWidget {
  final VoidCallback? onHome;
  final VoidCallback? onProgress;
  const FightBottomNav({super.key, this.onHome, this.onProgress});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, VoidCallback? onTap) => Expanded(
          child: InkResponse(
            onTap: onTap,
            child: SizedBox(
              height: 64,
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ),
        );

    return Container(
      color: AppColors.red,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            item(Icons.home_rounded, onHome),
            item(Icons.fact_check, onProgress),
            item(Icons.star_rounded, () {}),
            item(Icons.support_agent, () {}),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME
// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openStudentsLevel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StudentsLevelPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 20),
                    _quickActions(context),
                    const SizedBox(height: 18),
                    _sectionTitle(),
                    const SizedBox(height: 10),
                    _studentCards(),
                    const SizedBox(height: 22),
                    _classBanner(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            FightBottomNav(
              onHome: () {},
              onProgress: () => _openStudentsLevel(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Matheus',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Do or do not!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.search, color: AppColors.red, size: 26),
          const SizedBox(width: 12),
          const Icon(Icons.notifications_none,
              color: AppColors.red, size: 26),
          const SizedBox(width: 12),
          const Icon(Icons.person, color: AppColors.red, size: 26),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    Widget action(IconData icon, String label, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Icon(icon, color: AppColors.red, size: 36),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget divider() => Container(
          width: 1.5,
          height: 50,
          color: AppColors.red.withValues(alpha: 0.8),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          action(Icons.fitness_center, 'Workout', () {}),
          divider(),
          action(Icons.assignment_turned_in, 'Progress\nTracking',
              () => _openStudentsLevel(context)),
          divider(),
          action(Icons.groups, 'Community', () {}),
        ],
      ),
    );
  }

  Widget _sectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Students Fight Level',
              style: TextStyle(
                color: AppColors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Text(
            'See All',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.arrow_right, color: AppColors.orange, size: 22),
        ],
      ),
    );
  }

  Widget _studentCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: const [
          Expanded(
            child: _ActionCard(
              label: 'Insert Student',
              image: 'assets/images/add_student.jpg',
              icon: Icons.add,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _ActionCard(
              label: 'Remove Student',
              image: 'assets/images/remove_student.jpg',
              icon: Icons.remove,
            ),
          ),
        ],
      ),
    );
  }

  Widget _classBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.red,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: AspectRatio(
        aspectRatio: 2.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: const AppImage('assets/images/muay_thai_class.jpg'),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final String image;
  final IconData icon;
  const _ActionCard({
    required this.label,
    required this.image,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              child: AppImage(image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STUDENTS LEVEL
// ---------------------------------------------------------------------------
class Student {
  final String name;
  final String experience;
  final String belt;
  final double progress; // 0.0 a 1.0 (largura da linha colorida)
  final Color beltColor;
  final String image;
  final bool hasVideo;

  const Student({
    required this.name,
    required this.experience,
    required this.belt,
    required this.progress,
    required this.beltColor,
    required this.image,
    this.hasVideo = false,
  });
}

const _students = <Student>[
  Student(
    name: 'Francisco M.',
    experience: '4y Experience',
    belt: 'Blue Praijed',
    progress: 1.0,
    beltColor: Color(0xFF2D7FD8),
    image: 'assets/images/francisco.jpg',
    hasVideo: true,
  ),
  Student(
    name: 'Larissa N.',
    experience: '2y Experience',
    belt: 'Yellow/White Praijed',
    progress: 0.62,
    beltColor: Color(0xFFF2C41D),
    image: 'assets/images/larissa.jpg',
  ),
  Student(
    name: 'Hellen O.',
    experience: '3y Experience',
    belt: 'Green Praijed',
    progress: 1.0,
    beltColor: Color(0xFF3DB54A),
    image: 'assets/images/hellen.jpg',
    hasVideo: true,
  ),
  Student(
    name: 'Marcos P.',
    experience: '3y Experience',
    belt: '',
    progress: 1.0,
    beltColor: Color(0xFF3DB54A),
    image: 'assets/images/marcos.jpg',
  ),
  Student(
    name: 'Victoria R.',
    experience: '1y Experience',
    belt: 'White Praijed',
    progress: 0.0,
    beltColor: Colors.white,
    image: 'assets/images/victoria.jpg',
  ),
];

class StudentsLevelPage extends StatelessWidget {
  const StudentsLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.red, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Students Level',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                itemCount: _students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _StudentCard(student: _students[i]),
              ),
            ),
            FightBottomNav(
              onHome: () => Navigator.of(context).pop(),
              onProgress: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    const photoWidth = 118.0;

    return Container(
      height: 98,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange, width: 1.3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Texto + linha de progresso
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            student.experience,
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (student.belt.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            student.belt,
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (student.progress > 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: student.progress,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: student.beltColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Foto
          SizedBox(
            width: photoWidth,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(student.image),
                if (student.hasVideo)
                  Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}