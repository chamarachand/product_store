import 'package:flutter/material.dart';
import 'package:product_store/features/products/data/models/review.dart';

class ReviewsSection extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews (${reviews.length})',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String? formattedDate;
    if (review.date != null) {
      formattedDate =
          '${review.date!.year}-${review.date!.month.toString().padLeft(2, '0')}-${review.date!.day.toString().padLeft(2, '0')}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                review.reviewerName,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (formattedDate != null)
              Text(
                formattedDate,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < review.rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 16,
            ),
          ),
        ),
        if (review.comment.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(review.comment, style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}
