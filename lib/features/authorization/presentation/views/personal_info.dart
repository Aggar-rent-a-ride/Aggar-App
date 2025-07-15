import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/pick_date_of_birth_theme.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_up_have_an_account_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';

class PersonalInfoPage extends StatefulWidget {
  final PageController controller;
  final Function(Map<String, String>) onFormDataChanged;
  final Map<String, dynamic>? initialData;

  const PersonalInfoPage({
    super.key,
    required this.controller,
    required this.onFormDataChanged,
    this.initialData,
  });

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
        text: widget.initialData?['name'] as String? ?? '');
    _usernameController = TextEditingController(
        text: widget.initialData?['username'] as String? ?? '');
    _dateController = TextEditingController(
        text: widget.initialData?['dateOfBirth'] as String? ?? '');

    _nameController.addListener(_updateFormData);
    _usernameController.addListener(_updateFormData);
    _dateController.addListener(_updateFormData);

    _updateFormData();
  }

  void _updateFormData() {
    final formData = {
      'name': _nameController.text,
      'username': _usernameController.text,
      'dateOfBirth': _dateController.text,
    };

    widget.onFormDataChanged(formData);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return pickDateOfBirthTheme(context, child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        _dateController.text = formattedDate;
        _updateFormData();
      });
    }
  }

  void _nextPage() {
    // Trigger validation for all fields
    final formState = _formKey.currentState;
    if (formState != null) {
      final isValid = formState.validate();
      if (isValid) {
        widget.controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2 || value.length > 50) {
      return 'Name must be between 2 and 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3 || value.length > 15) {
      return 'Username must be between 3 and 15 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Username can only contain letters and numbers';
    }
    return null;
  }

  String? _validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your date of birth';
    }
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year -
          date.year -
          (now.month < date.month ||
                  (now.month == date.month && now.day < date.day)
              ? 1
              : 0);
      if (age < 13) {
        return 'You must be at least 13 years old';
      }
      if (date.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Information",
                      style: AppStyles.medium20(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                    const Gap(10),
                    CustomTextField(
                      labelText: 'Name',
                      inputType: TextInputType.text,
                      obscureText: false,
                      hintText: "Enter your name",
                      controller: _nameController,
                      validator: _validateName,
                    ),
                    const Gap(15),
                    CustomTextField(
                      labelText: 'Username',
                      inputType: TextInputType.text,
                      obscureText: false,
                      hintText: "Enter name other users will see",
                      controller: _usernameController,
                      validator: _validateUsername,
                    ),
                    const Gap(15),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          labelText: 'Date of birth',
                          inputType: TextInputType.none,
                          obscureText: false,
                          hintText: "Select your birth date",
                          controller: _dateController,
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: context.theme.black50,
                          ),
                          validator: _validateDateOfBirth,
                        ),
                      ),
                    ),
                    const Gap(30),
                    Center(
                      child: CustomElevatedButton(
                        onPressed: _nextPage, // Always allow validation to run
                        text: "Next",
                      ),
                    ),
                    const Gap(20),
                    const SignUpHaveAnAccountSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
