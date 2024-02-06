import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];
  List<OrdersModelAdvanced> get getorders => orders;

  Future<List<OrdersModelAdvanced>> fetchOrder() async {
    //final auth = FirebaseAuth.instance;
    //User? user = auth.currentUser;
    // if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .get()
          .then((ordersSnapshot) {
        orders.clear();
        for (var element in ordersSnapshot.docs) {
          orders.insert(
            0,
            OrdersModelAdvanced(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              price: element.get('price').toString(),
              productTitle: element.get('productTitle').toString(),
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}
