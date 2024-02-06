import 'package:flutter/material.dart';

class CartModel  with ChangeNotifier{
  final String cartId, productId;
  final int quantity;

  CartModel(
      {required this.cartId, required this.productId, required this.quantity});
}
