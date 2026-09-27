import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    context.read<ProductCubit>().searchProducts('');
    setState(() {});
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final trimmed = value.trim();

      if (trimmed.isNotEmpty) {
        context.read<ProductCubit>().searchProducts(value);
      } else {
        context.read<ProductCubit>().getProducts(clearQuery: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search Products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear),
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.primary, width: 1),
          ),
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: _onSearchChanged,
      ),
    );
  }
}
