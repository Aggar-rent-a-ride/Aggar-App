import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/features/payment/data/model/connected_account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';

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
  
  bool _obscureAccountNumber = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  Future<void> _createConnectedAccount() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final accessToken = await tokenCubit.getAccessToken();
      
      if (accessToken == null) {
        _showErrorDialog('Authentication failed. Please login again.');
        return;
      }
      context.read<PaymentCubit>().createConnectedAccount(
        accessToken,
        _phoneController.text,
        _accountNumberController.text,
        _routingNumberController.text,
      );
    } catch (e) {
      _showErrorDialog('Failed to authenticate. Please try again.');
    }
  }

  void _showSuccessSnackBar(ConnectedAccountModel connectedAccount) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Connected Successfully!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Account ID: ${connectedAccount.stripeAccountId}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PaymentCubit()),
      ],
      child: Scaffold(
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
        body: MultiBlocListener(
          listeners: [
            BlocListener<PaymentCubit, PaymentState>(
              listener: (context, state) {
                if (state is PaymentConnectedAccountSuccess) {
                  _showSuccessSnackBar(state.connectedAccountModel);
                } else if (state is PaymentError) {
                  _showErrorDialog(state.message);
                }
              },
            ),
            BlocListener<TokenRefreshCubit, TokenRefreshState>(
              listener: (context, state) {
                if (state is TokenRefreshFailure) {
                  _showErrorDialog('Session expired. Please login again.');
                }
              },
            ),
          ],
          child: SafeArea(
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

                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        final isLoading = state is PaymentLoading;
                        
                        return ElevatedButton(
                          onPressed: isLoading ? null : _createConnectedAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
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
                        );
                      },
                    ),
                  ],
                ),
              ),
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