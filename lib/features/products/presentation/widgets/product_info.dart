import 'package:flutter/material.dart';
import 'package:product_store/core/constants/app_constants.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.discountPercentage > 0;

    final originalPrice = hasDiscount
        ? product.price / (1 - (product.discountPercentage / 100))
        : product.price;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '${AppConstants.currency}${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (hasDiscount) ...[
                Text(
                  '${AppConstants.currency}${originalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${product.discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Chip(label: Text(product.category.toUpperCase())),
          const SizedBox(height: 24),
          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(product.description, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
