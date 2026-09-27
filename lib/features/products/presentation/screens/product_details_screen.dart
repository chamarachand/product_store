import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/core/constants/app_constants.dart';
import 'package:product_store/features/products/data/models/product_model.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';
import 'package:product_store/features/products/presentation/cubit/product_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              final isFavourite =
                  state is ProductsLoaded &&
                  state.favouriteIds.contains(product.id);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<ProductCubit>().toggleFavourite(product.id);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;

                if (isWideScreen) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _ProductImage(
                          product: product,
                          isWideScreen: isWideScreen,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProductInfo(product: product),
                            const Divider(height: 48),
                            _SpecificationsSection(product: product),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductImage(product: product, isWideScreen: false),
                      const SizedBox(height: 24),
                      _ProductInfo(product: product),
                      const SizedBox(height: 24),
                      _SpecificationsSection(product: product),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;
  final bool isWideScreen;

  const _ProductImage({required this.product, required this.isWideScreen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'product-image-${product.id}',
        child: CachedNetworkImage(
          imageUrl: product.images.isNotEmpty
              ? product.images.first
              : product.thumbnail,
          height: isWideScreen ? 400 : 300,
          fit: BoxFit.contain,
          fadeInDuration: Duration.zero,
          placeholder: (context, url) => CachedNetworkImage(
            imageUrl: product.thumbnail,
            fit: BoxFit.contain,
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image_not_supported, size: 80),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '${AppConstants.currency}${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Chip(label: Text(product.category.toUpperCase())),
          const SizedBox(height: 24),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _SpecificationsSection extends StatelessWidget {
  final Product product;

  const _SpecificationsSection({required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // _SpecRow(label: 'Brand', value: product.brand),
        _SpecRow(label: 'SKU', value: product.sku),
        _SpecRow(label: 'Weight', value: '${product.weight} Kg'),
        //_SpecRow(label: 'Dimensions', value: product.dimensions),
        _SpecRow(label: 'Availability', value: product.availabilityStatus),
        _SpecRow(label: 'Warranty', value: product.warrantyInformation),
        _SpecRow(label: 'Shipping', value: product.shippingInformation),
        _SpecRow(label: 'Returns', value: product.returnPolicy),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: Colors.grey.shade700, fontSize: 14);

    final valueStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: labelStyle)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }
}
