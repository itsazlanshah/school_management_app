import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/widgets/custom_dropdown_field.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/primary_button.dart';
import 'package:flutter_application_1/feature/student/data/student_repository.dart';
import 'package:flutter_application_1/feature/student/domain/student.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({super.key, required this.student});

  final Student student;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  static const List<String> _departments = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _fatherNameController;
  late final TextEditingController _cnicController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _studentRepository = StudentRepository();

  late String? _selectedDepartment;
  bool _isLoading = false;

  List<String> get _availableDepartments {
    final currentDepartment = widget.student.department;
    if (_departments.contains(currentDepartment)) return _departments;
    return [..._departments, currentDepartment];
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _fatherNameController = TextEditingController(
      text: widget.student.fatherName,
    );
    _cnicController = TextEditingController(text: widget.student.cnic);
    _phoneController = TextEditingController(text: widget.student.phone);
    _addressController = TextEditingController(text: widget.student.address);
    _selectedDepartment = widget.student.department;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    final department = _selectedDepartment;
    if (department == null) return;

    final updatedStudent = Student(
      id: widget.student.id,
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      cnic: _cnicController.text.trim(),
      phone: _phoneController.text.trim(),
      department: department,
      address: _addressController.text.trim(),
    );

    setState(() => _isLoading = true);
    try {
      await _studentRepository.updateStudent(updatedStudent);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student updated successfully.'),
          backgroundColor: AppColors.tertiaryContainer,
        ),
      );
      Navigator.of(context).pop(true);
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        title: const Text('Edit Student'),
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildFormCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildFatherNameField(),
            const SizedBox(height: 16),
            _buildCnicField(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildDepartmentField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Update Student',
              onPressed: _updateStudent,
              isLoading: _isLoading,
              icon: Icons.update,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Student Name *',
      hintText: 'e.g. Zainab Ahmed',
      prefixIcon: Icons.person_outline,
      controller: _nameController,
      validator: _requiredFieldValidator,
    );
  }

  Widget _buildFatherNameField() {
    return CustomTextField(
      label: "Father's Name *",
      hintText: 'e.g. Tariq Ahmed',
      prefixIcon: Icons.family_restroom,
      controller: _fatherNameController,
      validator: _requiredFieldValidator,
    );
  }

  Widget _buildCnicField() {
    return CustomTextField(
      label: 'CNIC *',
      hintText: 'XXXXX-XXXXXXX-X',
      prefixIcon: Icons.badge_outlined,
      controller: _cnicController,
      keyboardType: TextInputType.number,
      inputFormatters: [CnicInputFormatter()],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the CNIC.';
        }
        if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(value)) {
          return 'Enter a valid CNIC.';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      label: 'Phone Number *',
      hintText: '+92 300 1234567',
      prefixIcon: Icons.phone_outlined,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validator: _requiredFieldValidator,
    );
  }

  Widget _buildDepartmentField() {
    return CustomDropdownField(
      label: 'Department *',
      hintText: 'Select Department',
      value: _selectedDepartment,
      items: _availableDepartments,
      icon: Icons.school_outlined,
      onChanged: (department) {
        setState(() => _selectedDepartment = department);
      },
      validator: (value) =>
          value == null ? 'Please select a department.' : null,
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      label: 'Address *',
      hintText: 'e.g. Flat 3B, Rawalpindi',
      prefixIcon: Icons.location_on_outlined,
      controller: _addressController,
      maxLines: 3,
      validator: _requiredFieldValidator,
    );
  }

  String? _requiredFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }
}
