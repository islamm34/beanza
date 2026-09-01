import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../buttons/cart_badge_icon_button.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final bool showCartAction;

  const AppAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.centerTitle = false,
    this.actions,
    this.onBackPressed,
    this.leading,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.titleColor,
    this.titleStyle,
    this.showCartAction = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.darkBg : AppColors.lightBg);

    final mergedActions = <Widget>[
      if (actions != null) ...actions!,
      if (showCartAction) const CartBadgeIconButton(),
    ];

    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: titleStyle ??
                      TextStyle(
                        color: titleColor ??
                            (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                )
              : null),
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      actions: mergedActions.isNotEmpty ? mergedActions : null,
      leading: leading ??
          (Navigator.of(context).canPop()
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardElevated
                          : AppColors.lightSecondaryBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      bottom: bottom,
    );
  }
}
