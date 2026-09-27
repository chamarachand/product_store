import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/features/products/data/models/product_model.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';
import 'package:product_store/features/products/presentation/cubit/product_state.dart';
import 'package:product_store/features/products/presentation/screens/product_details_screen.dart';
import 'package:product_store/features/products/presentation/widgets/product_card.dart';
import 'package:product_store/features/products/presentation/widgets/search_box.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const SearchBox(),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (prev, curr) {
                if (prev is ProductsLoaded && curr is ProductsLoaded) {
                  return prev.products != curr.products ||
                      prev.searchQuery != curr.searchQuery ||
                      prev.isLast != curr.isLast ||
                      prev.isLoadingMore != curr.isLoadingMore;
                }
                return true;
              },
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsError) {
                  return _ProductErrorView(
                    msg: state.message,
                    onRetry: () => context.read<ProductCubit>().getProducts(),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    final isSearchResultsEmpty = state.searchQuery.isNotEmpty;

                    return _ProductEmptyView(
                      isSearchResultEmpty: isSearchResultsEmpty,
                    );
                  }

                  return _ProductsGridView(
                    displayProducts: state.products,
                    favouriteIds: state.favouriteIds,
                    isLoadingMore: state.isLoadingMore,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductEmptyView extends StatelessWidget {
  final bool isSearchResultEmpty;

  const _ProductEmptyView({required this.isSearchResultEmpty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchResultEmpty
                  ? Icons.search_off
                  : Icons.inventory_2_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              isSearchResultEmpty
                  ? "No products match your search."
                  : "No products available.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorView extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;

  const _ProductErrorView({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsGridView extends StatefulWidget {
  final List<Product> displayProducts;
  final Set<int> favouriteIds;
  final bool isLoadingMore;

  const _ProductsGridView({
    required this.displayProducts,
    required this.favouriteIds,
    required this.isLoadingMore,
  });

  @override
  State<_ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<_ProductsGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProductCubit>().getProducts(isRefresh: true);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.63,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = widget.displayProducts[index];

                return BlocSelector<ProductCubit, ProductState, bool>(
                  selector: (state) => state is ProductsLoaded
                      ? state.favouriteIds.contains(product.id)
                      : false,
                  builder: (context, isFavourite) {
                    return ProductCard(
                      product: product,
                      isFavourite: isFavourite,
                      onFavouriteToggle: () {
                        context.read<ProductCubit>().toggleFavourite(
                          product.id,
                        );
                      },
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                    );
                  },
                );
              }, childCount: widget.displayProducts.length),
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
