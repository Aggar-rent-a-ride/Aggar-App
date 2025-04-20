import 'package:aggar/core/extensions/context_colors_extension.dart';
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

  bool _isFormValid = false;

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

    setState(() {
      _isFormValid = _nameController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty &&
          _dateController.text.isNotEmpty;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      widget.controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Text("Personal Information",
                      style: AppStyles.medium20(context)),
                  const Gap(10),
                  CustomTextField(
                    labelText: 'Name',
                    inputType: TextInputType.text,
                    obscureText: false,
                    hintText: "Enter your name",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  CustomTextField(
                    labelText: 'Username',
                    inputType: TextInputType.text,
                    obscureText: false,
                    hintText: "Enter name other users will see",
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
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
                        suffixIcon: const Icon(Icons.calendar_today),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const Gap(30),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: _isFormValid ? _nextPage : null,
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
    );
  }
}
