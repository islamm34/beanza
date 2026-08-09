import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/scan_result_entity.dart';
import '../widgets/permission_denied_view.dart';
import '../widgets/scan_controls.dart';
import '../widgets/scan_frame.dart';
import '../widgets/scanner_overlay.dart';
import 'scan_result_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _isProcessing = false;
  bool _hasPermission = false;
  bool _isLoadingPermission = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: const [
        BarcodeFormat.qrCode,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.itf,
        BarcodeFormat.dataMatrix,
        BarcodeFormat.pdf417,
        BarcodeFormat.aztec,
      ],
    );
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    setState(() => _isLoadingPermission = true);
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _isLoadingPermission = false;
      });
      _controller.start();
    } else {
      final requestedStatus = await Permission.camera.request();
      setState(() {
        _hasPermission = requestedStatus.isGranted;
        _isLoadingPermission = false;
      });
      if (requestedStatus.isGranted) {
        _controller.start();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isProcessing) {
          _controller.start();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _controller.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null) return;

    final rawValue = barcode.rawValue ?? barcode.displayValue;
    if (rawValue == null || rawValue.trim().isEmpty) {
      _showInvalidCodeSnackBar();
      return;
    }

    _isProcessing = true;
    try {
      await _controller.stop();
    } catch (_) {}

    final scanResult = ScanResultEntity(
      rawValue: rawValue,
      barcodeFormat: barcode.format.name,
      scanType: ScanResultEntity.classifyType(barcode.format.name, rawValue),
      timestamp: DateTime.now(),
    );

    if (!mounted) return;

    final shouldScanAgain = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScanResultPage(scanResult: scanResult),
      ),
    );

    if (shouldScanAgain == true && mounted) {
      _resetScanner();
    } else {
      setState(() => _isProcessing = false);
    }
  }

  void _resetScanner() {
    setState(() => _isProcessing = false);
    if (_hasPermission) {
      _controller.start();
    }
  }

  void _showInvalidCodeSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Couldn't read this code. Position code inside frame.",
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPermission) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner'),
          elevation: 0,
        ),
        body: PermissionDeniedView(
          onRequestPermission: _checkCameraPermission,
          onCancel: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final scanBoxSize = (screenWidth * 0.72).clamp(260.0, 320.0);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Real Device Camera Preview
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcodeDetected,
            errorBuilder: (context, error, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Camera Error: ${error.errorCode.name}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _controller.start(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 2. Dark Overlay Cutout
          ScannerOverlay(scanBoxSize: scanBoxSize),

          // 3. Centered Scanning Frame & Laser Animation
          Center(
            child: ScanFrame(
              size: scanBoxSize,
              isScanning: !_isProcessing,
            ),
          ),

          // 4. Top Action Bar
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const Text(
                      'Scan a QR code or barcode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // Balance spacing
                  ],
                ),
              ),
            ),
          ),

          // 5. Bottom Controls (Flash Toggle & Gallery Picker)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: ScanControls(
                  controller: _controller,
                  onImageScanned: _handleBarcodeDetected,
                  onError: _showInvalidCodeSnackBar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
