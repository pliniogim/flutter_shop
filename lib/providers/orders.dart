import 'package:flutter/foundation.dart';

import '../widgets/cart_item.dart';

class OrderItem {
  late final String id;
  late final double amount;
  late final List<CartItem> products;
  late final DateTime dateTime;

  OrderItem(
      {required String id,
      required double amount,
      required DateTime Function() datetime,
      required List<CartItem> products});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now.toString(),
          amount: total,
          datetime: DateTime.now,
          products: cartProducts),
    );
    notifyListeners();
  }
}
