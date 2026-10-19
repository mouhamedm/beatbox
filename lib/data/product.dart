import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.colors = const [Colors.black, Color(0xFFC8C8CC), Color(0xFF4F7CFF), Color(0xFFF2705A)],
  });

  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final List<Color> colors;

  String get priceLabel => '\$${price.toStringAsFixed(2)}';
  String get shortPrice => '\$${price.toStringAsFixed(0)}';
  String get reviewsLabel => reviews
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}
