import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
        true);
  }

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: 'newProduct');
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting ? const Center(
            child:  CircularProgressIndicator(),
            ) : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) =>
                    Column(
                      children: [
                        UserProductItem(
                          id: productsData.items[i].id,
                          title: productsData.items[i].title,
                          imageUrl: productsData.items[i].imageUrl,
                        ),
                        const Divider(),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
