import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';

class QRScannerPage extends StatefulWidget {
  final int rentalId;

  const QRScannerPage({
    super.key,
    required this.rentalId,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late MobileScannerController controller;
  bool isFlashOn = false;
  bool isScanning = true;
  bool isProcessing = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    controller.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  void _exitWithResult(bool success, [String? message]) {
    if (!_isDisposed && mounted) {
      Navigator.of(context).pop(success);
    }
  }

  void _showErrorAndRetry(String message) {
    if (!_isDisposed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          message,
          SnackBarType.error,
        ),
      );

      // Reset scanner state after showing error
      _safeSetState(() {
        isProcessing = false;
        isScanning = true;
      });

      // Restart scanning
      try {
        controller.start();
      } catch (e) {
        debugPrint('Error restarting scanner: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RentalHistoryCubit, RentalHistoryState>(
      listener: (context, state) {
        debugPrint('QR Scanner received state: ${state.runtimeType}');

        if (state is RentalHistoryLoaded) {
          // Rental confirmed successfully
          debugPrint('Rental confirmed successfully');
          if (!_isDisposed && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context,
                "Success",
                'Rental confirmed successfully!',
                SnackBarType.success,
              ),
            );
          }

          // Exit with success after a short delay to show the success message
          Future.delayed(const Duration(milliseconds: 1500), () {
            _exitWithResult(true, 'Rental confirmed successfully');
          });
        } else if (state is RentalHistoryError) {
          // Handle specific error cases
          debugPrint('QR Scanner error: ${state.message}');
          String errorMessage = state.message;

          // Check for specific error types
          if (errorMessage.toLowerCase().contains('qr code is not valid')) {
            errorMessage =
                'Invalid QR code. Please scan a valid QR code or enter the correct code manually.';
          } else if (errorMessage.toLowerCase().contains('network')) {
            errorMessage =
                'Network error. Please check your connection and try again.';
          } else if (errorMessage.toLowerCase().contains('timeout')) {
            errorMessage = 'Request timeout. Please try again.';
          } else if (errorMessage.toLowerCase().contains('400')) {
            errorMessage =
                'Invalid QR code. Please scan the correct QR code for this rental.';
          }

          _showErrorAndRetry(errorMessage);
        } else if (state is RentalHistoryLoading) {
          // Handle loading state - keep showing processing
          debugPrint('QR Scanner processing...');
          _safeSetState(() {
            isProcessing = true;
            isScanning = false;
          });
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          // Stop camera when leaving the screen
          try {
            await controller.stop();
          } catch (e) {
            debugPrint('Error stopping camera: $e');
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                try {
                  await controller.stop();
                } catch (e) {
                  debugPrint('Error stopping camera: $e');
                }
                _exitWithResult(false);
              },
            ),
            title: const Text(
              'Scan QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
                onPressed: _toggleFlash,
              ),
              if (!isProcessing)
                IconButton(
                  icon: const Icon(Icons.keyboard, color: Colors.white),
                  onPressed: _showManualInputDialog,
                ),
            ],
          ),
          body: Stack(
            children: [
              // QR Scanner View
              MobileScanner(
                controller: controller,
                onDetect: _onQRViewCreated,
              ),

              // Custom Overlay
              Container(
                decoration: const ShapeDecoration(
                  shape: QrScannerOverlayShape(
                    borderColor: Color(0xFF2563EB),
                    borderRadius: 12,
                    borderLength: 30,
                    borderWidth: 8,
                    cutOutSize: 280,
                  ),
                ),
              ),

              // Top instruction text
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Position the QR code within the frame to scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 80,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    // Status indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isProcessing
                            ? Colors.orange.withOpacity(0.8)
                            : isScanning
                                ? Colors.green.withOpacity(0.8)
                                : Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isProcessing)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else
                            Icon(
                              isScanning ? Icons.qr_code_scanner : Icons.pause,
                              color: Colors.white,
                              size: 16,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            isProcessing
                                ? 'Confirming rental...'
                                : isScanning
                                    ? 'Scanning...'
                                    : 'Paused',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Manual input button
                    ElevatedButton.icon(
                      onPressed: isProcessing ? null : _showManualInputDialog,
                      icon: const Icon(Icons.keyboard, size: 18),
                      label: const Text('Enter Code Manually'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(BarcodeCapture barcodeCapture) {
    if (isScanning && !isProcessing && barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        debugPrint('QR Code scanned: ${barcode.rawValue}');

        _safeSetState(() {
          isScanning = false;
          isProcessing = true;
        });

        try {
          controller.stop();
        } catch (e) {
          debugPrint('Error stopping camera: $e');
        }

        _confirmRental(barcode.rawValue!);
      }
    }
  }

  void _toggleFlash() async {
    if (!_isDisposed && mounted) {
      try {
        await controller.toggleTorch();
        _safeSetState(() {
          isFlashOn = !isFlashOn;
        });
      } catch (e) {
        debugPrint('Error toggling flash: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              'Unable to toggle flash',
              SnackBarType.error,
            ),
          );
        }
      }
    }
  }

  void _confirmRental(String scannedCode) {
    if (!_isDisposed && mounted) {
      try {
        debugPrint(
            'Confirming rental with code: $scannedCode, rentalId: ${widget.rentalId}');
        final rentalHistoryCubit = context.read<RentalHistoryCubit>();
        rentalHistoryCubit.confirmRental(
          rentalId: widget.rentalId,
          scannedQrCode: scannedCode,
        );
      } catch (e) {
        debugPrint('Error confirming rental: $e');
        _showErrorAndRetry('Failed to confirm rental. Please try again.');
      }
    }
  }

  void _showManualInputDialog() {
    if (isProcessing) return;

    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.keyboard,
                color: Color(0xFF2563EB),
                size: 24,
              ),
              SizedBox(width: 8),
              Text('Enter Code Manually'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the verification code if you cannot scan the QR code:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the code here',
                  prefixIcon: Icon(Icons.qr_code),
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.of(dialogContext).pop();
                    _handleManualInput(value.trim());
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = textController.text.trim();
                if (code.isNotEmpty) {
                  Navigator.of(dialogContext).pop();
                  _handleManualInput(code);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      'Please enter a valid code',
                      SnackBarType.error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _handleManualInput(String code) {
    debugPrint('Manual input code: $code');

    _safeSetState(() {
      isScanning = false;
      isProcessing = true;
    });

    try {
      controller.stop();
    } catch (e) {
      debugPrint('Error stopping camera: $e');
    }

    _confirmRental(code);
  }
}

// Custom overlay shape for the QR scanner
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    path = Path.combine(
      PathOperation.difference,
      path,
      _getScannerPath(rect),
    );
    return path;
  }

  Path _getScannerPath(Rect rect) {
    final scanArea = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanArea,
          Radius.circular(borderRadius),
        ),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final borderLength =
        this.borderLength > cutOutSize / 2 ? cutOutSize / 2 : this.borderLength;
    final borderRadius =
        this.borderRadius > borderLength ? borderLength : this.borderRadius;

    final cutOutRect = Rect.fromLTWH(
      rect.left + borderWidthSize - (cutOutSize / 2),
      rect.top + (height / 2) - (cutOutSize / 2),
      cutOutSize,
      cutOutSize,
    );

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            cutOutRect,
            Radius.circular(borderRadius),
          ),
        ),
    );

    canvas.drawPath(path, backgroundPaint);

    // Draw the border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cutOutRect,
        Radius.circular(borderRadius),
      ),
      borderPaint,
    );

    // Draw corner lines
    final lineLength = borderLength;
    final lineWidth = borderWidth;
    final cornerRadius = borderRadius;

    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    // Top left corner
    canvas.drawLine(
      Offset(cutOutRect.left + cornerRadius, cutOutRect.top + borderOffset),
      Offset(cutOutRect.left + cornerRadius + lineLength,
          cutOutRect.top + borderOffset),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.left + borderOffset, cutOutRect.top + cornerRadius),
      Offset(cutOutRect.left + borderOffset,
          cutOutRect.top + cornerRadius + lineLength),
      cornerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(cutOutRect.right - cornerRadius - lineLength,
          cutOutRect.top + borderOffset),
      Offset(cutOutRect.right - cornerRadius, cutOutRect.top + borderOffset),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.right - borderOffset, cutOutRect.top + cornerRadius),
      Offset(cutOutRect.right - borderOffset,
          cutOutRect.top + cornerRadius + lineLength),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(cutOutRect.left + borderOffset,
          cutOutRect.bottom - cornerRadius - lineLength),
      Offset(cutOutRect.left + borderOffset, cutOutRect.bottom - cornerRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.left + cornerRadius, cutOutRect.bottom - borderOffset),
      Offset(cutOutRect.left + cornerRadius + lineLength,
          cutOutRect.bottom - borderOffset),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(cutOutRect.right - borderOffset,
          cutOutRect.bottom - cornerRadius - lineLength),
      Offset(cutOutRect.right - borderOffset, cutOutRect.bottom - cornerRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.right - cornerRadius - lineLength,
          cutOutRect.bottom - borderOffset),
      Offset(cutOutRect.right - cornerRadius, cutOutRect.bottom - borderOffset),
      cornerPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
