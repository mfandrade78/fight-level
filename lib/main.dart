import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final VoidCallback? onAchievements;
  final VoidCallback? onSupport;
  const FightBottomNav({
    super.key,
    this.onHome,
    this.onProgress,
    this.onAchievements,
    this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    Widget item(String label, IconData icon, VoidCallback? onTap) => Expanded(
          child: InkResponse(
            onTap: onTap,
            child: Tooltip(
              message: label,
              child: SizedBox(
                height: 64,
                child: Icon(icon, color: Colors.white, size: 32),
              ),
            ),
          ),
        );

    return Container(
      color: AppColors.red,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            item('Home', Icons.home_rounded, onHome),
            item('Progress', Icons.fact_check, onProgress),
            item('Achievements', Icons.star_rounded, onAchievements),
            item('Help and support', Icons.support_agent, onSupport),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME
// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> _students = List.of(_initialStudents);
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openStudentsLevel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudentsLevelPage(students: List.of(_students)),
      ),
    );
  }

  void _openWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WorkoutSchedulePage()),
    );
  }

  Future<void> _launchExternal(Uri uri, String failureMessage) async {
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage)),
        );
      }
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage)),
        );
      }
    }
  }

  void _openAchievements(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AchievementsPage(students: List.of(_students)),
      ),
    );
  }

  Future<void> _insertStudent() async {
    final student = await showDialog<Student>(
      context: context,
      builder: (_) => const _InsertStudentDialog(),
    );
    if (student == null || !mounted) return;

    if (_students.any(
      (existing) => existing.name.toLowerCase() == student.name.toLowerCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A student with this name already exists.'),
        ),
      );
      return;
    }
    setState(() => _students.add(student));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${student.name} was added.')),
    );
  }

  Future<void> _removeStudent() async {
    if (_students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There are no students to remove.')),
      );
      return;
    }

    final student = await showDialog<Student>(
      context: context,
      builder: (_) => _RemoveStudentDialog(students: List.of(_students)),
    );
    if (student == null || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove student?'),
        content: Text('Remove ${student.name} from the student list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _students.remove(student));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${student.name} was removed.')),
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
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 20),
                    _quickActions(context),
                    const SizedBox(height: 18),
                    _sectionTitle(context),
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
              onHome: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              ),
              onProgress: () => _openStudentsLevel(context),
              onAchievements: () => _openAchievements(context),
              onSupport: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupportPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
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
          IconButton(
            tooltip: 'Search students',
            icon: const Icon(Icons.search, color: AppColors.red, size: 26),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StudentSearchPage(students: List.of(_students)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none,
                color: AppColors.red, size: 26),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person, color: AppColors.red, size: 26),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
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
          action(Icons.fitness_center, 'Workout', () => _openWorkout(context)),
          divider(),
          action(Icons.assignment_turned_in, 'Progress\nTracking',
              () => _openStudentsLevel(context)),
          divider(),
          action(
            Icons.groups,
            'Community',
            () => _launchExternal(
              Uri.parse(
                'https://www.instagram.com/ctjuniorsilva?srtk=MXB6dDRkdGRkd2R5dw==',
              ),
              'Could not open the Instagram profile.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context) {
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
          InkWell(
            onTap: () => _openStudentsLevel(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'See All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'See all students',
            onPressed: () => _openStudentsLevel(context),
            icon: const Icon(Icons.arrow_right,
                color: AppColors.orange, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _studentCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              label: 'Insert Student',
              image: 'assets/images/add_student.jpg',
              icon: Icons.add,
              onTap: _insertStudent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionCard(
              label: 'Remove Student',
              image: 'assets/images/remove_student.jpg',
              icon: Icons.remove,
              onTap: _removeStudent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _classBanner() {
    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const AspectRatio(
              aspectRatio: 1,
              child: AppImage('assets/images/muay_thai_class.jpg'),
            ),
          ),
        ),
      ),
      child: Container(
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
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final String image;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionCard({
    required this.label,
    required this.image,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 112,
            decoration: BoxDecoration(
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
          ),
        ),
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

const _initialStudents = <Student>[
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

class StudentsLevelPage extends StatefulWidget {
  final List<Student> students;
  const StudentsLevelPage({super.key, required this.students});

  @override
  State<StudentsLevelPage> createState() => _StudentsLevelPageState();
}

class _StudentsLevelPageState extends State<StudentsLevelPage> {
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();

  List<Student> get _visibleStudents {
    final students = switch (_selectedFilter) {
      'Alphabet' => [...widget.students]
        ..sort((a, b) => a.name.compareTo(b.name)),
      'Media' => widget.students.where((student) => student.hasVideo).toList(),
      _ => widget.students,
    };
    return students;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Text('Sort by',
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 8),
                        for (final filter in const ['All', 'Alphabet', 'Media'])
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              onSelected: (_) =>
                                  setState(() => _selectedFilter = filter),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                      itemCount: _visibleStudents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _StudentCard(student: _visibleStudents[i]),
                    ),
                  ),
                ],
              ),
            ),
            FightBottomNav(
              onHome: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              onProgress: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              ),
              onAchievements: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      AchievementsPage(students: widget.students),
                ),
              ),
              onSupport: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupportPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsertStudentDialog extends StatefulWidget {
  const _InsertStudentDialog();

  @override
  State<_InsertStudentDialog> createState() => _InsertStudentDialogState();
}

class _InsertStudentDialogState extends State<_InsertStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _beltController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _beltController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Student(
        name: _nameController.text.trim(),
        experience: _experienceController.text.trim().isEmpty
            ? 'New Student'
            : _experienceController.text.trim(),
        belt: _beltController.text.trim().isEmpty
            ? 'White Praijed'
            : _beltController.text.trim(),
        progress: 0,
        beltColor: Colors.white,
        image: 'assets/images/victoria.jpg',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Student'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Name is required.'
                    : null,
              ),
              TextField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Experience (optional)',
                ),
              ),
              TextField(
                controller: _beltController,
                decoration:
                    const InputDecoration(labelText: 'Belt (optional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add student'),
        ),
      ],
    );
  }
}

class _RemoveStudentDialog extends StatelessWidget {
  final List<Student> students;
  const _RemoveStudentDialog({required this.students});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a student'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return ListTile(
              title: Text(student.name),
              trailing: const Icon(Icons.remove_circle_outline),
              onTap: () => Navigator.pop(context, student),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class StudentSearchPage extends StatefulWidget {
  final List<Student> students;
  const StudentSearchPage({super.key, required this.students});

  @override
  State<StudentSearchPage> createState() => _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results = widget.students.where((student) {
      return student.name.toLowerCase().contains(query) ||
          student.experience.toLowerCase().contains(query) ||
          student.belt.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search students'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Name, experience or belt',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: results.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, index) =>
                        _StudentCard(student: results[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class WorkoutSchedulePage extends StatelessWidget {
  const WorkoutSchedulePage({super.key});

  static const _schedule = <String, List<String>>{
    'Monday': [],
    'Tuesday': ['9:00 AM - 10:30 AM', '6:00 PM - 7:30 PM'],
    'Wednesday': ['9:00 AM - 10:30 AM'],
    'Thursday': ['6:00 PM - 7:30 PM'],
    'Friday': ['9:00 AM - 10:30 AM'],
    'Saturday': [],
    'Sunday': [],
  };

  @override
  Widget build(BuildContext context) {
    return _StandardPage(
      title: 'Workout schedule',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Weekly training times',
            style: TextStyle(color: AppColors.lightText, fontSize: 16),
          ),
          const SizedBox(height: 12),
          for (final entry in _schedule.entries)
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today,
                    color: AppColors.red),
                title: Text(entry.key),
                subtitle: Text(
                  entry.value.isEmpty
                      ? 'No training'
                      : entry.value.join('\n'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AchievementsPage extends StatelessWidget {
  final List<Student> students;
  const AchievementsPage({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final completed = students.where((student) => student.progress >= 1).length;
    return _StandardPage(
      title: 'Achievements',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: AppColors.orange),
              title: const Text('Level progress completed'),
              subtitle: Text('$completed of ${students.length} students'),
            ),
          ),
          for (final student in students)
            Card(
              child: ListTile(
                title: Text(student.name),
                subtitle: LinearProgressIndicator(value: student.progress),
                trailing: Text('${(student.progress * 100).round()}%'),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StandardPage(
      title: 'Notifications',
      child: Center(child: Text('You are all caught up.')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StandardPage(
      title: 'Profile',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.red,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            SizedBox(height: 12),
            Text('Matheus', style: TextStyle(fontSize: 20)),
            Text('Fight Level'),
          ],
        ),
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _StandardPage(
      title: 'Help & support',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Find help with the main Fight Level features.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.fitness_center, color: AppColors.red),
            title: const Text('View training days and times'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const WorkoutSchedulePage(),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.people, color: AppColors.red),
            title: Text('Manage students from the home screen.'),
          ),
          const ListTile(
            leading: Icon(Icons.search, color: AppColors.red),
            title: Text('Search students by name, experience or belt.'),
          ),
        ],
      ),
    );
  }
}

class _StandardPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _StandardPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(child: child),
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