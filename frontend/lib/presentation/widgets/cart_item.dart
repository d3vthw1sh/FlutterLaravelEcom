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
    const neonGreen = Color(0xFFCCFF00); // neon lime
    const black = Colors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: neonGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  AppUtils.formatPrice(item.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),

                const SizedBox(height: 12),

                // Quantity Controls
                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove_rounded,
                      enabled: item.qty > 1,
                      onPressed: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.qty}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: black,
                        ),
                      ),
                    ),
                    _qtyButton(
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
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black54,
                  size: 20,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                AppUtils.formatPrice(item.price * item.qty),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quantity Button
  Widget _qtyButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    const neonGreen = Color(0xFFCCFF00);
    const black = Colors.black;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: neonGreen.withValues(alpha: 0.8),
        border: Border.all(color: enabled ? black : Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: enabled ? black : Colors.black38),
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
