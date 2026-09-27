import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/core/di/injection.dart';
import 'package:product_store/core/theme/app_theme.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';
import 'package:product_store/features/products/presentation/screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependecies();
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
      home: BlocProvider(
        create: (context) => getIt<ProductCubit>()..loadProducts(),
        child: const ProductListScreen(),
      ),
    );
  }
}
