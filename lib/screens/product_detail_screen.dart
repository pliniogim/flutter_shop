import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/products.dart';


class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  // const ProductDetailScreen({Key? key, required this.title, required this.price}) : super(key: key);
  // final String title;
  // final double price;



  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)?.settings.arguments as String;
    //final loadedProduct = Provider.of<Products>(context).items.firstWhere((prod) => prod.id == productId);
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId);


    debugPrint(productId);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title),
      ),
      body: const Text(''),
    );
  }
}
