import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  MobileScannerController? cameraController;
  bool _isFlashOn = false;
  bool _isDisposed = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() async {
    if (!_isDisposed) {
      try {
        cameraController = MobileScannerController();
        await cameraController!.start();
        if (mounted) {
          setState(() {
            _hasError = false;
            _errorMessage = null;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Erro ao inicializar a câmera: $e';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    cameraController?.stop();
    cameraController?.dispose();
    cameraController = null;
    super.dispose();
  }

  void _retryInitialization() {
    if (!_isDisposed) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });
      _initializeController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escanear QR Code'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Erro desconhecido',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _retryInitialization,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (cameraController == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escanear QR Code'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Inicializando câmera...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            iconSize: 32.0,
            onPressed: () {
              if (cameraController != null && !_isDisposed) {
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
                cameraController!.toggleTorch();
              }
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.cameraswitch),
            iconSize: 32.0,
            onPressed: () {
              if (cameraController != null && !_isDisposed) {
                cameraController!.switchCamera();
              }
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController!,
        onDetect: (capture) {
          if (_isDisposed || _isProcessing) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? qrCodeData = barcodes.first.rawValue;
            if (qrCodeData != null && mounted && !_isProcessing) {
              _isProcessing = true;
              // Pequeno delay para evitar múltiplas leituras
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && !_isDisposed) {
                  Navigator.pop(context, qrCodeData);
                }
              });
            }
          }
        },
      ),
    );
  }
}
