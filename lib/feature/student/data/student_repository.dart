import 'package:flutter_application_1/feature/student/domain/student.dart';

class StudentRepository {
  static final List<Student> _students = [
    const Student(
      id: 'student-001',
      name: 'Ayesha Khan',
      fatherName: 'Imran Khan',
      cnic: '42101-1234567-1',
      phone: '03001234567',
      department: 'Biology',
      address: 'Karachi',
    ),
    const Student(
      id: 'student-002',
      name: 'Muhammad Ali',
      fatherName: 'Ahmed Ali',
      cnic: '35202-7654321-9',
      phone: '03111234567',
      department: 'Mathematics',
      address: 'Lahore',
    ),
  ];

  Future<bool> addStudent(Student student) async {
    _students.add(student);
    return true;
  }

  Future<void> deleteStudent(String id) async {
    final removedCount = _students.where((student) => student.id == id).length;
    if (removedCount == 0) {
      throw StateError('Student with id "$id" was not found.');
    }

    _students.removeWhere((student) => student.id == id);
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final index = _students.indexWhere(
      (student) => student.id == updatedStudent.id,
    );
    if (index == -1) {
      throw StateError('Student with id "${updatedStudent.id}" was not found.');
    }

    _students[index] = updatedStudent;
  }

  Future<List<Student>> getStudents() async {
    return List.unmodifiable(_students);
  }
}
