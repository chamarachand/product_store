import 'package:flutter/material.dart';
import 'package:product_store/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
