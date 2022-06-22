import 'package:flutter/material.dart';
import './screens/product_detail_screen.dart';
import 'package:flutter_shop/screens/products_overview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.deepOrange),
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
      routes: {
    ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
    },
    );
  }
}