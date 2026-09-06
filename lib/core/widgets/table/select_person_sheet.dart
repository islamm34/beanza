import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/table_session_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../buttons/primary_button.dart';
import '../common/cafe_card.dart';
import '../common/adaptive_cafe_logo.dart';

class SelectPersonSheet extends StatefulWidget {
  final String? currentSelectedId;
  final ValueChanged<String> onSelected;

  const SelectPersonSheet({
    Key? key,
    this.currentSelectedId,
    required this.onSelected,
  }) : super(key: key);

  static Future<String?> show(BuildContext context,
      {String? currentSelectedId}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SelectPersonSheet(
          currentSelectedId: currentSelectedId,
          onSelected: (id) => Navigator.pop(context, id),
        ),
      ),
    );
  }

  @override
  State<SelectPersonSheet> createState() => _SelectPersonSheetState();
}

class _SelectPersonSheetState extends State<SelectPersonSheet> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    final tableCtrl = Get.isRegistered<TableSessionController>()
        ? Get.find<TableSessionController>()
        : null;
    _selectedId = widget.currentSelectedId ??
        tableCtrl?.currentParticipant.value?.participantId ??
        'me';
  }

  void _showAddNameDialog() {
    final textCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        title: const Text('Add New Person / إضافة اسم'),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'e.g. Sarah',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = textCtrl.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(ctx);
                setState(() {
                  _selectedId = name;
                });
                widget.onSelected(name);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    final tableCtrl = Get.isRegistered<TableSessionController>()
        ? Get.find<TableSessionController>()
        : null;

    final participants = tableCtrl?.currentSession.value?.participants ?? [];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Logo / Gold Coffee Icon at top center
          const Center(
            child: AdaptiveCafeLogo(size: 64, semanticsLabel: 'Cafe Logo'),
          ),
          const SizedBox(height: 12),

          // Title & Arabic Subtitle
          Text(
            'Who is this order for?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'لمن هذا المشروب في الطاولة؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Vertical List of Connected Members
          if (participants.isNotEmpty)
            ...participants.map((p) {
              final isSelected = _selectedId == p.participantId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedId = p.participantId);
                    widget.onSelected(p.participantId);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? goldColor.withValues(alpha: isDark ? 0.20 : 0.14)
                          : (isDark
                              ? AppColors.darkCardElevated
                              : AppColors.lightSecondaryBg),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? goldColor
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              isSelected ? goldColor : AppColors.espressoDark,
                          child: Text(
                            p.displayName.isNotEmpty
                                ? p.displayName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            p.displayName,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: greenColor,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),

          // Guest Option
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedId = 'guest');
                widget.onSelected('guest');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedId == 'guest'
                      ? goldColor.withValues(alpha: isDark ? 0.20 : 0.14)
                      : (isDark
                          ? AppColors.darkCardElevated
                          : AppColors.lightSecondaryBg),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedId == 'guest'
                        ? goldColor
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: _selectedId == 'guest' ? 1.8 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person_outline_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Guest / ضيف إضافي',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: _selectedId == 'guest'
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_selectedId == 'guest')
                      Icon(
                        Icons.check_circle_rounded,
                        color: greenColor,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Add New Name Button
          OutlinedButton.icon(
            onPressed: _showAddNameDialog,
            icon: Icon(Icons.add_rounded, color: goldColor),
            label: Text(
              'Add New Name / إضافة شخص جديد',
              style: TextStyle(color: goldColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
