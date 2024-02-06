import 'package:flutter/material.dart';

class WishListModel  with ChangeNotifier{
  final String wishListId, productId;


  WishListModel(
      {required this.wishListId, required this.productId, });
}
