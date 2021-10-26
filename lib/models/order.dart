import 'package:flutter/material.dart';
import 'package:flutter_app_my_shop/providers/cart_provider.dart';

class OrderItem {
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  final double amount;
  final DateTime dateTime;
  final String id;
  final List<CartItem> products;
}
