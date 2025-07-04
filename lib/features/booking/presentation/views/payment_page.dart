import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentSummaryCard(),
            const SizedBox(height: 24),
            _buildPaymentMethodCard(),
            const SizedBox(height: 32),
            _buildPayButton(),
            const SizedBox(height: 16),
            _buildTermsText(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildVehicleInfo(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildBookingDetails(),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildTotalAmount(),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.booking.vehicleImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://aggarapi.runasp.net/api/booking${widget.booking.vehicleImagePath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.directions_car,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.directions_car,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.booking.vehicleBrand ?? ''} ${widget.booking.vehicleModel}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Booking ID: ${widget.bookingId}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDetails() {
    return Column(
      children: [
        _buildSummaryRow('Booking Period',
            '${DateFormat('MMM dd').format(widget.booking.startDate)} - ${DateFormat('MMM dd, yyyy').format(widget.booking.endDate)}'),
        _buildSummaryRow('Duration',
            '${widget.booking.totalDays} day${widget.booking.totalDays > 1 ? 's' : ''}'),
        _buildSummaryRow('Daily Rate',
            '\$${(widget.booking.price / widget.booking.totalDays).toStringAsFixed(2)}'),
        if (widget.booking.discount > 0) ...[
          _buildSummaryRow(
              'Subtotal', '\$${widget.booking.price.toStringAsFixed(2)}'),
          _buildSummaryRow(
              'Discount', '-\$${widget.booking.discount.toStringAsFixed(2)}'),
        ],
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${widget.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCardField(),
          const SizedBox(height: 12),
          _buildTestCardNotice(),
          const SizedBox(height: 16),
          _buildSecurityNotice(),
        ],
      ),
    );
  }

  Widget _buildCardField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CardField(
        controller: _cardController,
        onCardChanged: (card) {
          setState(() {
            _cardDetails = card;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Card number',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
        ),
        enablePostalCode: false,
        autofocus: false,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTestCardNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade700,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Test Card Numbers',
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Visa: 4242 4242 4242 4242\nMastercard: 5555 5555 5555 4444\nUse any future date and 123 CVC',
            style: TextStyle(
              color: Colors.amber.shade700,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your payment information is secure and encrypted.',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isProcessing || _cardDetails?.complete != true
            ? null
            : _handlePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Pay \$${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Text(
      'By completing this payment, you agree to our Terms of Service and Privacy Policy.',
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      // Confirm the payment using the client secret
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        // Payment successful
        _showSuccessDialog();
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
        // Handle 3D Secure or other actions
        _showErrorMessage('Payment requires additional authentication');
      } else {
        // Payment failed
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your booking has been confirmed. You will receive a confirmation email shortly.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context)
                        .pop(true); // Go back to booking details
                    Navigator.of(context).pop(true); // Go back to bookings list
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
