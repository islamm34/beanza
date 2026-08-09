import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? titleColor;
  final TextStyle? titleStyle;

  const AppAppBar({
    Key? key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.onBackPressed,
    this.leading,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.titleColor,
    this.titleStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkCardBg : AppColors.lightCardBg);

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: titleStyle ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: titleColor ??
                            AppColors.getTextColor(Theme.of(context).brightness),
                        fontWeight: FontWeight.w600,
                      ),
            )
          : null,
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      elevation: elevation,
      actions: actions,
      leading: leading ??
          (Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.getTextColor(Theme.of(context).brightness),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      bottom: bottom,
    );
  }
}
