import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';

class QRScannerPage extends StatefulWidget {
  final int bookingId;

  const QRScannerPage({
    super.key,
    required this.bookingId,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late MobileScannerController controller;
  bool isFlashOn = false;
  bool isScanning = true;
  bool isProcessing = false;

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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RentalHistoryCubit, RentalHistoryState>(
      listener: (context, state) {
        if (state is RentalHistoryLoaded) {
          // Rental confirmed successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rental confirmed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return success
        } else if (state is RentalHistoryError) {
          // Show error and allow scanning again
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            isProcessing = false;
            isScanning = true;
          });
          controller.start();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(BarcodeCapture barcodeCapture) {
    if (isScanning && !isProcessing && barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          isScanning = false;
          isProcessing = true;
        });
        controller.stop();
        _confirmRental(barcode.rawValue!);
      }
    }
  }

  void _toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _confirmRental(String scannedCode) {
    final rentalHistoryCubit = context.read<RentalHistoryCubit>();
    rentalHistoryCubit.confirmRental(
      rentalId: widget.bookingId,
      scannedQrCode: scannedCode,
    );
  }

  void _showManualInputDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Code Manually'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the code if you cannot scan the QR code:'),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the code here',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = textController.text.trim();
                if (code.isNotEmpty) {
                  Navigator.of(context).pop();
                  setState(() {
                    isScanning = false;
                    isProcessing = true;
                  });
                  controller.stop();
                  _confirmRental(code);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid code'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
