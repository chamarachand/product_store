import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/features/products/data/models/product_model.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';
import 'package:product_store/features/products/presentation/cubit/product_state.dart';
import 'package:product_store/features/products/presentation/widgets/product_info.dart';
import 'package:product_store/features/products/presentation/widgets/product_reviews.dart';
import 'package:product_store/features/products/presentation/widgets/product_specifications.dart';

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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _ProductImage(
                              product: product,
                              isWideScreen: isWideScreen,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 6,
                            child: ProductInfo(product: product),
                          ),
                        ],
                      )
                    else ...[
                      _ProductImage(product: product, isWideScreen: false),
                      const SizedBox(height: 24),
                      ProductInfo(product: product),
                    ],

                    const Divider(height: 48),
                    SpecificationsSection(product: product),

                    if (product.reviews.isNotEmpty) ...[
                      const Divider(height: 48),
                      ReviewsSection(reviews: product.reviews),
                    ],
                  ],
                );
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
          height: isWideScreen ? 450 : 300,
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
