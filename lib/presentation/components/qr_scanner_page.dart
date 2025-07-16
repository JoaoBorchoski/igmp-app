import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isFlashOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            iconSize: 32.0,
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.cameraswitch),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? qrCodeData = barcodes.first.rawValue;
            if (qrCodeData != null) {
              Navigator.pop(context, qrCodeData);
            }
          }
        },
      ),
    );
  }
}
