import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as od;

class OrderItem extends StatefulWidget {
  final od.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(3.0),
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            SizedBox(
              height: min(widget.order.products.length * 20.0 + 10, 180.0),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantity}x \$${prod.price}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
