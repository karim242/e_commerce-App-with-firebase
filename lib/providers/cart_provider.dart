import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/models/cart_model.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {}; //1
  Map<String, CartModel> get getItems => _cartItems; //2

  bool isProductInCart({required String productId}) {
    //3
    return _cartItems.containsKey(productId);
  }

  void addToCart({required String productId}) {
    //4
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartModel(
            cartId: const Uuid().v4(), productId: productId, quantity: 1),
      );
    }
    notifyListeners(); //5
  }

  //Firebase

  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Future<void> addToCartFirebase(
      {required String productId,
      required int qty,
      required BuildContext context}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethod.showErrorORWariningDailog(
          context: context, subtitle: "No user found", fct: () {});
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            "cartId": cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(msg: "Item has been added to cart");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log("the function has been called and the user is null");
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        _cartItems.putIfAbsent(
          userDoc.get('userCart')[index]['productId'],
          () => CartModel(
            cartId: userDoc.get('userCart')[index]['cartId'],
            productId: userDoc.get('userCart')[index]['productId'],
            quantity: userDoc.get('userCart')[index]['quantity'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearCartFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"userCart": []});
      _cartItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeItemFromFirebase(
      {required String cartId,
      required String productId,
      required int qty}) async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            "cartId": cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });

      _cartItems.remove(productId);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  //local Data

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
          cartId: item.cartId, productId: productId, quantity: quantity),
    );
    notifyListeners(); //5
  }

  double getTotal({required ProductProvider product}) {
    double total = 0;
    _cartItems.forEach(
      (key, value) {
        final ProductModel? getCurrProudect =
            product.findByProductId(value.productId);
        if (getCurrProudect == null) {
          total += 0;
        } else {
          total += double.parse(getCurrProudect.productPrice) * value.quantity;
        }
      },
    );
    return total;
  }

  int getQuantity() {
    int qty = 0;
    _cartItems.forEach((key, value) {
      qty += value.quantity;
    });
    return qty;
  }

  void removeOneTtem({
    required String productId,
  }) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }
}
