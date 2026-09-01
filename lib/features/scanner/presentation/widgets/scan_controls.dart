import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../app/theme/app_colors.dart';

class ScanControls extends StatefulWidget {
  final MobileScannerController controller;
  final Function(BarcodeCapture capture) onImageScanned;
  final VoidCallback onError;

  const ScanControls({
    Key? key,
    required this.controller,
    required this.onImageScanned,
    required this.onError,
  }) : super(key: key);

  @override
  State<ScanControls> createState() => _ScanControlsState();
}

class _ScanControlsState extends State<ScanControls> {
  bool _isTorchOn = false;

  Future<void> _toggleTorch() async {
    try {
      await widget.controller.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (_) {}
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bool success = await widget.controller.analyzeImage(image.path);
        if (!success) {
          widget.onError();
        }
      }
    } catch (_) {
      widget.onError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Flash Toggle
        _buildControlButton(
          icon: _isTorchOn ? Icons.flash_on : Icons.flash_off,
          label: _isTorchOn ? 'Flash On' : 'Flash Off',
          isActive: _isTorchOn,
          onTap: _toggleTorch,
        ),

        // Gallery Picker
        _buildControlButton(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          isActive: false,
          onTap: _pickFromGallery,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isActive ? AppColors.caramel : Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.caramel : Colors.white24,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.espressoDark : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
