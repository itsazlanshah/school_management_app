import 'package:flutter_application_1/feature/teacher/domain/teacher.dart';

class TeacherRepository {
  static final List<Teacher> _teachers = [
    const Teacher(
      id: 'teacher-001',
      name: 'Sara Ahmed',
      cnic: '42101-2345678-2',
      department: 'Biology',
      address: 'Karachi',
    ),
    const Teacher(
      id: 'teacher-002',
      name: 'Usman Tariq',
      cnic: '35202-8765432-1',
      department: 'Mathematics',
      address: 'Lahore',
    ),
  ];

  Future<bool> addTeacher(Teacher teacher) async {
    _teachers.add(teacher);
    return true;
  }

  Future<void> deleteTeacher(String id) async {
    final removedCount = _teachers.where((teacher) => teacher.id == id).length;
    if (removedCount == 0) {
      throw StateError('Teacher with id "$id" was not found.');
    }

    _teachers.removeWhere((teacher) => teacher.id == id);
  }

  Future<void> updateTeacher(Teacher updatedTeacher) async {
    final index = _teachers.indexWhere(
      (teacher) => teacher.id == updatedTeacher.id,
    );
    if (index == -1) {
      throw StateError('Teacher with id "${updatedTeacher.id}" was not found.');
    }

    _teachers[index] = updatedTeacher;
  }

  Future<List<Teacher>> getTeachers() async {
    return List.unmodifiable(_teachers);
  }
}
