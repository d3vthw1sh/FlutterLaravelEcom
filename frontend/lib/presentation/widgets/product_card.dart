import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/utils.dart';
import '../../core/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 150),
      child: Card(
        elevation: 2,
        shadowColor: cs.shadow.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------
              // Product Image
              // -------------------------------
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withOpacity(0.25),
                      ),
                      child: product.images.isNotEmpty
                          ? _buildImage(
                              product.images.first,
                              cs.onSurfaceVariant,
                            )
                          : Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                    ),

                    // Soft gradient fade (Japanese UI style)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                cs.surface.withOpacity(0.18),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // NEW Badge (MUJI minimalist)
                    if (product.productIsNew)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "NEW",
                            style: tt.labelSmall?.copyWith(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // -------------------------------
              // Product Info
              // -------------------------------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand (minimal, soft grey)
                    Text(
                      product.brand.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        color: cs.outline,
                        fontSize: 10.5,
                        letterSpacing: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Name
                    Text(
                      product.name,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Price (Japanese mall style)
                    Text(
                      AppUtils.formatPrice(product.price),
                      style: tt.titleLarge?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath, Color fallbackIconColor) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _errorIcon(fallbackIconColor),
      );
    }

    return Image.network(
      ApiConstants.resolveImageUrl(imagePath),
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _errorIcon(fallbackIconColor),
    );
  }

  Widget _errorIcon(Color color) => Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: color,
        ),
      );
}
