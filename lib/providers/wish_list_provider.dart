import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/models/wish_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItem = {};    //1
  Map<String, WishListModel> get getWishListItems => _wishListItem;    //2

  bool isProductInWishList({required String productId}) {     //3
    return _wishListItem.containsKey(productId);
  }
  //Firebase
 // Firebase
  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Future<void> addToWishlistFirebase(
      {required String productId, required BuildContext context}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethod.showErrorORWariningDailog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            "wishlistId": wishlistId,
            'productId': productId,
          }
        ])
      });
      // await fetchWishlist();
      Fluttertoast.showToast(msg: "Item has been added to Wishlist");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // log("the function has been called and the user is null");
      _wishListItem.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final leng = userDoc.get("userWish").length;
      for (int index = 0; index < leng; index++) {
        _wishListItem.putIfAbsent(
          userDoc.get('userWish')[index]['productId'],
          () => WishListModel(
            wishListId: userDoc.get('userWish')[index]['wishlistId'],
            productId: userDoc.get('userWish')[index]['productId'], 
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirebase({
    required String wishlistId,
    required String productId,
  }) async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      _wishListItem.remove(productId);
      // await fetchWishlist();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearWishlistFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"userWish": []});
      _wishListItem.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//local data 
  void addAndRemoveImWishList({required String productId}) {         //4

    if (_wishListItem.containsKey(productId)) {
      _wishListItem.remove(productId);
    } else {
      _wishListItem.putIfAbsent(
        productId,
        () =>
            WishListModel(wishListId: const Uuid().v4(), productId: productId),
      );
    }
    notifyListeners();
  }

  void clear() {              //5
    _wishListItem.clear();
    notifyListeners();
  }
}
