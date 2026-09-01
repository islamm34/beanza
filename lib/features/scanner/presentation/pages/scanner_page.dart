import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../widgets/permission_denied_view.dart';
import '../widgets/scan_frame.dart';
import '../widgets/scanner_overlay.dart';

class ScannerPage extends StatefulWidget {
  final bool? overrideHasPermission;
  const ScannerPage({this.overrideHasPermission, Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _isProcessing = false;
  bool _isNavigating = false;
  bool _hasPermission = false;
  bool _isLoadingPermission = true;
  bool _isStartingCamera = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      autoStart: false,
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
    if (widget.overrideHasPermission != null) {
      _hasPermission = widget.overrideHasPermission!;
      _isLoadingPermission = false;
    } else if (Get.testMode) {
      _hasPermission = true;
      _isLoadingPermission = false;
    } else {
      _checkCameraPermission();
    }
  }

  Future<void> _checkCameraPermission() async {
    setState(() => _isLoadingPermission = true);
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _hasPermission = true;
          _isLoadingPermission = false;
        });
        _safeStartCamera();
      }
    } else {
      final requestedStatus = await Permission.camera.request();
      if (mounted) {
        setState(() {
          _hasPermission = requestedStatus.isGranted;
          _isLoadingPermission = false;
        });
        if (requestedStatus.isGranted) {
          _safeStartCamera();
        }
      }
    }
  }

  Future<void> _safeStartCamera() async {
    if (!_hasPermission ||
        _isProcessing ||
        _isNavigating ||
        _isStartingCamera ||
        !mounted) {
      return;
    }
    _isStartingCamera = true;
    try {
      if (!_controller.isStarting) {
        await _controller.start();
      }
    } catch (_) {
    } finally {
      if (mounted) {
        _isStartingCamera = false;
      }
    }
  }

  Future<void> _safeStopCamera() async {
    try {
      await _controller.stop();
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission || _isNavigating) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isProcessing && !_isNavigating) {
          _safeStartCamera();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _safeStopCamera();
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
    if (_isProcessing || _isNavigating) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null) return;

    final rawValue = barcode.rawValue ?? barcode.displayValue;
    if (rawValue == null || rawValue.trim().isEmpty) {
      _showInvalidCodeSnackBar();
      return;
    }

    _isProcessing = true;
    _isNavigating = true;
    await _safeStopCamera();

    final tableNum = _extractTableNumber(rawValue);

    if (!mounted) return;

    Get.offNamed(
      Routes.NAME_ENTRY,
      arguments: {
        'tableId': tableNum,
        'tableNumber': tableNum,
      },
    );
  }

  String _extractTableNumber(String raw) {
    final clean = raw.trim();
    if (clean.contains('table/')) {
      return clean.split('table/').last.split('?').first;
    }
    final digitsOnly = clean.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.isNotEmpty ? digitsOnly : '12';
  }

  void _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      if (mounted) {
        setState(() {
          _isTorchOn = !_isTorchOn;
        });
      }
    } catch (_) {}
  }

  void _showManualTableDialog() {
    final textController = TextEditingController(text: '12');
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          title: Text(
            'Enter Table Number',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Table Number',
              hintText: 'e.g. 12',
              prefixIcon: Icon(Icons.table_restaurant_rounded,
                  color: isDark ? AppColors.gold : AppColors.goldLight),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final tableNum = textController.text.trim().isEmpty
                    ? '12'
                    : textController.text.trim();
                _isProcessing = true;
                _isNavigating = true;
                _safeStopCamera();
                Navigator.pop(context);
                Get.offNamed(
                  Routes.NAME_ENTRY,
                  arguments: {
                    'tableId': tableNum,
                    'tableNumber': tableNum,
                  },
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidCodeSnackBar() {
    if (!mounted) return;
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
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
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
    final scanBoxSize = (screenWidth * 0.72).clamp(260.0, 310.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview
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
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Camera Error: ${error.errorCode.name}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _safeStartCamera,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScanFrame(
                  size: scanBoxSize,
                  isScanning: !_isProcessing && !_isNavigating,
                ),
                const SizedBox(height: 24),
                // Detected Table Status
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.brightGreen.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.brightGreen,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Point at Table QR to Join Session',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Top Action Bar: Flash on top-left, Close on top-right
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Flash Button (Top-Left)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isTorchOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color:
                              _isTorchOn ? AppColors.goldBright : Colors.white,
                          size: 20,
                        ),
                        onPressed: _toggleTorch,
                      ),
                    ),

                    // Manual Table Button
                    GestureDetector(
                      onTap: _showManualTableDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.edit_note_rounded,
                                color: AppColors.goldBright, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Enter Table #',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Close Button (Top-Right)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          _safeStopCamera();
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Get.offAllNamed(Routes.HOME);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Bottom Swipe up / Open Menu instruction
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: () {
                    _safeStopCamera();
                    Get.offAllNamed(Routes.HOME);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.restaurant_menu_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Open Menu Directly',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
