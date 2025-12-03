import 'package:flutter/material.dart';
import '../../data/models/cart_item_model.dart';
import '../../core/utils.dart';
import '../../core/constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),

          const SizedBox(width: 14),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.brand.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    fontSize: 10,
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  AppUtils.formatPrice(item.price),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.primary, // Royal Blue
                  ),
                ),

                const SizedBox(height: 12),

                // Quantity Controls
                Row(
                  children: [
                    _qtyButton(
                      context,
                      icon: Icons.remove_rounded,
                      enabled: item.qty > 1,
                      onPressed: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.qty}',
                        style: tt.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _qtyButton(
                      context,
                      icon: Icons.add_rounded,
                      enabled: item.qty < item.stock,
                      onPressed: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete + Total Price
          Column(
            children: [
              IconButton(
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close_rounded,
                  color: cs.onSurfaceVariant,
                  size: 20,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                AppUtils.formatPrice(item.price * item.qty),
                style: tt.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quantity Button
  Widget _qtyButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: enabled ? primary : Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: enabled ? primary : Colors.white24),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  // Product Image Loader
  Widget _buildImage() {
    final double size = 90;

    if (item.image.startsWith('assets/')) {
      return Image.asset(
        item.image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      ApiConstants.resolveImageUrl(item.image),
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          color: Colors.black12,
          child: const Icon(
            Icons.image_not_supported,
            size: 28,
            color: Colors.black54,
          ),
        );
      },
    );
  }
}
