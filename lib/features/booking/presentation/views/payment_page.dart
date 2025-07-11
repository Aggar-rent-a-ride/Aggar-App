import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_button.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_method_section.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_success_dialog.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_section.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_terms_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:gap/gap.dart';

class PaymentScreen extends StatefulWidget {
  final String clientSecret;
  final int bookingId;
  final double amount;
  final BookingModel booking;

  const PaymentScreen({
    super.key,
    required this.clientSecret,
    required this.bookingId,
    required this.amount,
    required this.booking,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  CardFieldInputDetails? _cardDetails;
  final CardEditController _cardController = CardEditController();

  @override
  void initState() {
    super.initState();
    _ensureStripeInitialized();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _ensureStripeInitialized() {
    if (Stripe.publishableKey.isEmpty) {
      Stripe.publishableKey =
          'pk_test_51QzlxRLiWNEAMEsfyM1WAReytcHlTzP2Kn4vYh8QBMW7kxNHpY3oJkcaiSKHTV2QS4uAMRbmSd2mdZLehd2WYzb300dZB5tYwJ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentSummarySection(widget: widget),
            PaymentMethodSection(
              cardController: _cardController,
              onCardChanged: (card) {
                setState(() {
                  _cardDetails = card;
                });
              },
            ),
            const Gap(16),
            PaymentButton(
              isProcessing: _isProcessing,
              isEnabled: _cardDetails?.complete == true,
              amount: widget.amount,
              onPressed: _handlePayment,
            ),
            const SizedBox(height: 16),
            const PaymentTermsText(),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      shadowColor: Colors.grey[900],
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      backgroundColor: context.theme.white100_1,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.theme.black100,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Payment',
        style: AppStyles.semiBold24(context)
            .copyWith(color: context.theme.black100),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_cardDetails?.complete != true) {
      _showErrorMessage('Please enter complete card information');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        _showSuccessDialog();
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
        _showErrorMessage('Payment requires additional authentication');
      } else {
        _showErrorMessage('Payment failed. Please try again.');
      }
    } on StripeException catch (e) {
      _showErrorMessage(e.error.localizedMessage ?? 'Payment failed');
    } catch (e) {
      _showErrorMessage('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PaymentSuccessDialog(
          onDone: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(true); // Go back to booking details
            Navigator.of(context).pop(true); // Go back to bookings list
          },
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        context,
        "Error",
        message,
        SnackBarType.error,
      ),
    );
  }
}
