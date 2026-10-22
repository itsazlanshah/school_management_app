import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/widgets/custom_dropdown_field.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/primary_button.dart';
import 'package:flutter_application_1/feature/teacher/data/teacher_repository.dart';
import 'package:flutter_application_1/feature/teacher/domain/teacher.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  static const List<String> _departments = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _addressController = TextEditingController();
  final _teacherRepository = TeacherRepository();

  String? _selectedDepartment;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _addTeacher() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    final department = _selectedDepartment;
    if (department == null) return;

    final teacher = Teacher(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      cnic: _cnicController.text.trim(),
      department: department,
      address: _addressController.text.trim(),
    );

    setState(() => _isLoading = true);
    try {
      final added = await _teacherRepository.addTeacher(teacher);
      if (!mounted) return;
      if (!added) {
        _showMessage('Unable to add teacher. Please try again.', isError: true);
        return;
      }

      _showMessage('Teacher registered successfully!');
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
    _cnicController.clear();
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
        title: const Text('Add Teacher'),
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
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
            _buildCnicField(),
            const SizedBox(height: 16),
            _buildDepartmentField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Add Teacher',
              onPressed: _addTeacher,
              isLoading: _isLoading,
              icon: Icons.check,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _isLoading ? null : _clearForm,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                backgroundColor: AppColors.surfaceContainerLow,
                minimumSize: const Size.fromHeight(50),
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
      label: 'Teacher Name *',
      hintText: 'e.g. Dr. Asim Ali',
      prefixIcon: Icons.person_outline,
      controller: _nameController,
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
      hintText: 'e.g. Sector F-7, Islamabad',
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
