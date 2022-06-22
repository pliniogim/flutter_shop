import "package:flutter/material.dart";
import '../widgets/products_grid.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  // const ProductDetailScreen({Key? key, required this.title, required this.price}) : super(key: key);
  // final String title;
  // final double price;



  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text(' '),
      ),
      body: ProductsGrid(),
    );
  }
}
