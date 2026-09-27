class Review {
  final int rating;
  final String comment;
  final DateTime? date;
  final String reviewerName;
  final String reviewerEmail;

  const Review({
    required this.rating,
    required this.comment,
    this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String)
          : null,
      reviewerName: json['reviewerName'] as String? ?? '',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }
}
