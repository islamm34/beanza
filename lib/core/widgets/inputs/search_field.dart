import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';


class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final VoidCallback? onFilterPressed;

  const SearchField({
    Key? key,
    this.controller,
    this.hintText = 'Search cafes, products...',
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.onFilterPressed,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCardBg : AppColors.cream;

    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadows.cardShadow,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: bgColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.largeRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.largeRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.largeRadius,
            borderSide: const BorderSide(
              color: AppColors.coffeeBrown,
              width: 1.5,
            ),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: AppSpacing.base, right: AppSpacing.sm),
            child: Icon(
              Icons.search,
              color: AppColors.coffeeBrown,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20),
          suffixIcon: _controller.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        widget.onClear?.call();
                        setState(() {});
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
                        child: Icon(
                          Icons.close,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    if (widget.onFilterPressed != null)
                      GestureDetector(
                        onTap: widget.onFilterPressed,
                        child: const Padding(
                          padding: EdgeInsets.only(right: AppSpacing.base),
                          child: Icon(
                            Icons.tune,
                            color: AppColors.coffeeBrown,
                          ),
                        ),
                      ),
                  ],
                )
              : (widget.onFilterPressed != null
                  ? GestureDetector(
                      onTap: widget.onFilterPressed,
                      child: const Padding(
                        padding: EdgeInsets.only(right: AppSpacing.base),
                        child: Icon(
                          Icons.tune,
                          color: AppColors.coffeeBrown,
                        ),
                      ),
                    )
                  : null),
        ),
      ),
    );
  }
}
