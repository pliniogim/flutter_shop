import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //first way of using provider
    //final product =  Provider.of<Product>(context);

    final cart= Provider.of<Cart>(context, listen:false);

    // another way of using provider
    //with the use of consumer
    //only in the area that needs to be updated
    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          //header: Text(title),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(product.isFavorite ?
                Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: (){
                product.toggleFavoriteStatus();
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
              },
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName, //arguments: id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
