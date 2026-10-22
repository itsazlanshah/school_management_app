import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/widgets/custom_dropdown_field.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/primary_button.dart';
import 'package:flutter_application_1/feature/student/data/student_repository.dart';
import 'package:flutter_application_1/feature/student/domain/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  static const List<String> _departments = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _studentRepository = StudentRepository();

  String? _selectedDepartment;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _addStudent() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    final department = _selectedDepartment;
    if (department == null) return;

    final student = Student(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      cnic: _cnicController.text.trim(),
      phone: _phoneController.text.trim(),
      department: department,
      address: _addressController.text.trim(),
    );

    setState(() => _isLoading = true);
    try {
      final added = await _studentRepository.addStudent(student);
      if (!mounted) return;
      if (!added) {
        _showMessage('Unable to add student. Please try again.', isError: true);
        return;
      }

      _showMessage('Student added successfully!');
      _clearForm();
    } on Exception catch (error) {
      if (!mounted) return;
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _fatherNameController.clear();
    _cnicController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() => _selectedDepartment = null);
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.error
              : AppColors.tertiaryContainer,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        title: const Text('Add Student'),
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
              text: 'Add Student',
              onPressed: _addStudent,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _clearForm,
              icon: const Icon(Icons.restart_alt, color: AppColors.secondary),
              label: const Text('Clear Form'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.surfaceContainerLow,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
      items: _departments,
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
