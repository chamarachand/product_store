import 'package:flutter/material.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

class SpecificationsSection extends StatelessWidget {
  final Product product;

  const SpecificationsSection({super.key, required this.product});

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
        if (product.brand != null)
          _SpecRow(label: 'Brand', value: product.brand!),
        _SpecRow(label: 'SKU', value: product.sku),
        _SpecRow(label: 'Weight', value: '${product.weight} Kg'),
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
    const valueStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

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
