import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 20.0)),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleLarge
                                ?.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 5.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                      },
                      child: const Text(
                        'Order Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) => CartItems(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price),
            ),
          )
        ],
      ),
    );
  }
}
