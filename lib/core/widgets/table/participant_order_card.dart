import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/cart_item_model.dart';
import '../../../core/models/table_session_model.dart';

class ParticipantOrderCard extends StatefulWidget {
  final TableParticipant participant;
  final List<CartItem> items;
  final double subtotal;
  final bool isCurrentUser;
  final Color accentColor;
  final bool isSplitBillView;
  final bool isSessionSubmitted;
  final VoidCallback? onToggleDone;
  final Function(String itemId)? onIncrement;
  final Function(String itemId)? onDecrement;
  final Function(String itemId)? onRemove;

  const ParticipantOrderCard({
    Key? key,
    required this.participant,
    required this.items,
    required this.subtotal,
    required this.isCurrentUser,
    required this.accentColor,
    this.isSplitBillView = false,
    this.isSessionSubmitted = false,
    this.onToggleDone,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  }) : super(key: key);

  @override
  State<ParticipantOrderCard> createState() => _ParticipantOrderCardState();
}

class _ParticipantOrderCardState extends State<ParticipantOrderCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isCurrentUser || widget.items.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalItems = widget.items.fold<int>(0, (sum, i) => sum + i.quantity);
    final isDone = widget.participant.isDone;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181816) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.isCurrentUser
              ? const Color(0xFF00D98B)
              : (isDark
                  ? const Color(0xFF3A2B18)
                  : AppColors.caramel.withValues(alpha: 0.3)),
          width: widget.isCurrentUser ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: widget.accentColor.withValues(alpha: 0.2),
                    child: Text(
                      widget.participant.displayName[0].toUpperCase(),
                      style: TextStyle(
                        color: widget.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.isCurrentUser
                                    ? 'Your Order'
                                    : '${widget.participant.displayName}\'s Order',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textLight
                                      : AppColors.textDark,
                                ),
                              ),
                            ),
                            if (widget.isCurrentUser) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00D98B),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'YOU',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 6),
                            // Status Badge
                            if (isDone)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00D98B)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF00D98B)
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 10,
                                      color: Color(0xFF00D98B),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'DONE / تم',
                                      style: TextStyle(
                                        color: Color(0xFF00D98B),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.softSand.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Choosing / يختار',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textLightMuted
                                        : AppColors.textMuted,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$totalItems items • ${widget.subtotal.toStringAsFixed(0)} EGP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: widget.isSplitBillView
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: widget.isSplitBillView
                                ? widget.accentColor
                                : (isDark
                                    ? AppColors.textLightMuted
                                    : AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.subtotal.toStringAsFixed(0)} EGP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: widget.accentColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color:
                        isDark ? AppColors.textLightMuted : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Product Items & Actions
          if (_isExpanded) ...[
            const Divider(height: 1, indent: 14, endIndent: 14),
            if (widget.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      'No items yet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textLightMuted
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'لم يحدد طلبه بعد',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textLightMuted.withValues(alpha: 0.7)
                            : AppColors.textMuted.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: widget.items.map((item) {
                    final isEditable = widget.isCurrentUser &&
                        !widget.isSessionSubmitted &&
                        !isDone;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.product.image.startsWith('assets/')
                                ? Image.asset(
                                    item.product.image,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 44,
                                      height: 44,
                                      color: AppColors.softSand,
                                      child: const Icon(Icons.local_cafe,
                                          size: 20, color: AppColors.caramel),
                                    ),
                                  )
                                : Image.network(
                                    item.product.image,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 44,
                                      height: 44,
                                      color: AppColors.softSand,
                                      child: const Icon(Icons.local_cafe,
                                          size: 20, color: AppColors.caramel),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.textLight
                                        : AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.selectedSize.name} • ${item.selectedMilk.name}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textLightMuted
                                        : AppColors.textMuted,
                                  ),
                                ),
                                if (item.selectedExtras.isNotEmpty)
                                  Text(
                                    '+ ${item.selectedExtras.map((e) => e.name).join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.caramel,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2B2420)
                                  : AppColors.softSand.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '×${item.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${item.totalPrice.toStringAsFixed(0)} EGP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.accentColor,
                            ),
                          ),
                          if (isEditable &&
                              widget.onIncrement != null &&
                              widget.onDecrement != null) ...[
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  size: 18),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => widget.onDecrement!(item.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  size: 18),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => widget.onIncrement!(item.id),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // "I'm Done" / "Edit Order" Action Button for Current User
            if (widget.isCurrentUser &&
                !widget.isSessionSubmitted &&
                widget.onToggleDone != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: widget.items.isEmpty && !isDone
                        ? null
                        : widget.onToggleDone,
                    icon: Icon(
                      isDone
                          ? Icons.edit_note_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isDone
                          ? 'Edit My Order (تعديل الطلب)'
                          : 'I\'m Done (انتهيت من طلبي)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDone
                          ? (isDark
                              ? const Color(0xFF2B2420)
                              : AppColors.softSand)
                          : const Color(0xFF00D98B),
                      foregroundColor: isDone
                          ? (isDark ? AppColors.textLight : AppColors.textDark)
                          : Colors.black,
                      elevation: isDone ? 0 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
