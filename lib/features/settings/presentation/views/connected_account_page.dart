import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';

class ConnectedAccountPage extends StatefulWidget {
  const ConnectedAccountPage({super.key});

  @override
  State<ConnectedAccountPage> createState() => _ConnectedAccountPageState();
}

class _ConnectedAccountPageState extends State<ConnectedAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureAccountNumber = true;
  
  // DioConsumer instance
  late final DioConsumer dioConsumer;
  
  // Replace with your actual access token
  String accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDg0IiwianRpIjoiODMzZGViMjYtMjk5NC00NjgwLWI2MTYtNzAwOTFkMGUwMDZlIiwidXNlcm5hbWUiOiJSYW50YXIiLCJ1aWQiOiIyMDg0Iiwicm9sZXMiOlsiVXNlciIsIlJlbnRlciJdLCJleHAiOjE3NTA5MTkxMjAsImlzcyI6IkFnZ2FyQXBpIiwiYXVkIjoiRmx1dHRlciJ9.HxPmEoqoD52gb_-obC06LdH9NHJuE1uGgas4nqG6040";

  @override
  void initState() {
    super.initState();
    // Initialize DioConsumer
    dioConsumer = DioConsumer(dio: Dio());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  Future<void> _createConnectedAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Prepare form data
      final formData = {
        'phone': _phoneController.text,
        'bankAccountNumber': _accountNumberController.text,
        'bankAccountRoutingNumber': _routingNumberController.text,
      };

      // Prepare options with authorization header
      final options = Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      );

      // Make POST request using DioConsumer
      final response = await dioConsumer.post(
        '/api/payment/connected-account',
        data: formData,
        options: options,
        isFromData: true, // This will convert the data to FormData
      );

      if (response != null) {
        _showSuccessDialog(response['data']);
      } else {
        _showErrorDialog('Failed to create connected account');
      }
    } catch (e) {
      String errorMessage = 'Network error occurred';
      
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timeout';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Receive timeout';
            break;
          case DioExceptionType.badResponse:
            errorMessage = 'Server error: ${e.response?.statusCode}';
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'Connection error';
            break;
          default:
            errorMessage = 'Request failed: ${e.message}';
        }
      } else {
        errorMessage = 'Network error: ${e.toString()}';
      }
      
      _showErrorDialog(errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account created successfully!'),
            const Gap(16),
            Text('Stripe Account ID: ${data['stripeAccountId']}'),
            Text('Bank Account ID: ${data['bankAccountId']}'),
            Text('Verified: ${data['isVerified'] ? 'Yes' : 'No'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation - adjust regex as needed
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value.replaceAll(RegExp(r'[\s-()]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account number is required';
    }
    if (value.length < 8 || value.length > 17) {
      return 'Account number must be 8-17 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Account number must contain only numbers';
    }
    return null;
  }

  String? _validateRoutingNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Routing number is required';
    }
    if (value.length != 9) {
      return 'Routing number must be exactly 9 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Routing number must contain only numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Connect Bank Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 48,
                        color: Colors.blue[600],
                      ),
                      const Gap(12),
                      Text(
                        'Connect Account',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Securely link your bank account to receive payments',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const Gap(32),

                _buildInputField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '+20 460 585 1234',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s()]')),
                  ],
                ),

                const Gap(20),

                _buildInputField(
                  controller: _accountNumberController,
                  label: 'Bank Account Number',
                  hint: '000123456789',
                  icon: Icons.account_balance_wallet,
                  keyboardType: TextInputType.number,
                  validator: _validateAccountNumber,
                  obscureText: _obscureAccountNumber,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureAccountNumber ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureAccountNumber = !_obscureAccountNumber;
                      });
                    },
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(17),
                  ],
                ),

                const Gap(20),

                _buildInputField(
                  controller: _routingNumberController,
                  label: 'Routing Number',
                  hint: '110000000',
                  icon: Icons.route,
                  keyboardType: TextInputType.number,
                  validator: _validateRoutingNumber,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                ),

                const Gap(32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.green[600]),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          'Your banking information is encrypted and secure',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _createConnectedAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Connect Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}