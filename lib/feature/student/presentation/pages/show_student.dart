import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/feature/student/data/student_repository.dart';
import 'package:flutter_application_1/feature/student/domain/student.dart';
import 'package:flutter_application_1/feature/student/presentation/pages/add_student.dart';
import 'package:flutter_application_1/feature/student/presentation/pages/edit_student.dart';
import 'package:flutter_application_1/feature/student/widget/student_card.dart';

class ShowStudentScreen extends StatefulWidget {
  const ShowStudentScreen({super.key});

  @override
  State<ShowStudentScreen> createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen> {
  final _studentRepository = StudentRepository();
  Future<List<Student>>? _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentRepository.getStudents();
  }

  Future<void> _addStudent() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddStudentScreen()));
    if (!mounted) return;
    setState(() {
      _studentsFuture = _studentRepository.getStudents();
    });
  }

  Future<void> _confirmDelete(Student student) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('Delete ${student.name} from the student list?'),
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
      await _studentRepository.deleteStudent(student.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Student deleted successfully.'),
            backgroundColor: AppColors.tertiaryContainer,
          ),
        );
      setState(() {
        _studentsFuture = _studentRepository.getStudents();
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

  Future<void> _editStudent(Student student) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _studentsFuture = _studentRepository.getStudents();
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
        title: const Text('Students List'),
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
                'Enrolled Students',
                style: AppTextStyles.headlineSmall,
              ),
            ),
            Expanded(child: _buildStudentList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentList() {
    return FutureBuilder<List<Student>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load students: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ),
          );
        }

        final students = snapshot.data;
        if (students == null || students.isEmpty) {
          return const Center(
            child: Text('No students found.', style: AppTextStyles.body),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: StudentCard(
                student: student,
                onEdit: () => _editStudent(student),
                onDelete: () {
                  _confirmDelete(student);
                },
              ),
            );
          },
        );
      },
    );
  }
}
