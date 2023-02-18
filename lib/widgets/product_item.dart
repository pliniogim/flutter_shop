import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //first way of using provider
    //final product =  Provider.of<Product>(context);

    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

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
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
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
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added item to cart!'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id, //arguments: id,
              );
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/product_placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
