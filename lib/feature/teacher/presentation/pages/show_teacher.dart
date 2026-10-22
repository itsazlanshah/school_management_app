import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/feature/teacher/data/teacher_repository.dart';
import 'package:flutter_application_1/feature/teacher/domain/teacher.dart';
import 'package:flutter_application_1/feature/teacher/presentation/pages/add_teacher.dart';
import 'package:flutter_application_1/feature/teacher/presentation/pages/edit_teacher.dart';
import 'package:flutter_application_1/feature/teacher/widget/teacher_card.dart';

class ShowTeacherScreen extends StatefulWidget {
  const ShowTeacherScreen({super.key});

  @override
  State<ShowTeacherScreen> createState() => _ShowTeacherScreenState();
}

class _ShowTeacherScreenState extends State<ShowTeacherScreen> {
  final _teacherRepository = TeacherRepository();
  Future<List<Teacher>>? _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherRepository.getTeachers();
  }

  Future<void> _addTeacher() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddTeacherScreen()));
    if (!mounted) return;
    setState(() {
      _teachersFuture = _teacherRepository.getTeachers();
    });
  }

  Future<void> _confirmDelete(Teacher teacher) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete teacher?'),
        content: Text('Delete ${teacher.name} from the teacher list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    try {
      await _teacherRepository.deleteTeacher(teacher.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Teacher deleted successfully.'),
            backgroundColor: AppColors.tertiaryContainer,
          ),
        );
      setState(() {
        _teachersFuture = _teacherRepository.getTeachers();
      });
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  Future<void> _editTeacher(Teacher teacher) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => EditTeacherScreen(teacher: teacher),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _teachersFuture = _teacherRepository.getTeachers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Teachers List'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: AppColors.onPrimary, size: 18),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Enrolled Teachers',
                style: AppTextStyles.headlineSmall,
              ),
            ),
            Expanded(child: _buildTeacherList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTeacher,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTeacherList() {
    return FutureBuilder<List<Teacher>>(
      future: _teachersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load teachers: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ),
          );
        }

        final teachers = snapshot.data;
        if (teachers == null || teachers.isEmpty) {
          return const Center(
            child: Text('No teachers found.', style: AppTextStyles.body),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TeacherCard(
                teacher: teacher,
                onEdit: () => _editTeacher(teacher),
                onDelete: () => _confirmDelete(teacher),
              ),
            );
          },
        );
      },
    );
  }
}
