import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      //header: Text(title),
      footer: GridTileBar(
        leading: const IconButton(
          icon: Icon(Icons.favorite),
          onPressed: null,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black54,
        trailing: const IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: null,
        ),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}