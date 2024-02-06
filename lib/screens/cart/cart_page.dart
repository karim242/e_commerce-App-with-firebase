import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/helper/assets_manager.dart';
import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/screens/cart/bottom_checkout.dart';
import 'package:e_commerce_app_with_firebase/screens/cart/cart_widget.dart';
import 'package:e_commerce_app_with_firebase/screens/loading_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import '../../providers/user_provider.dart';
import '../../widgets/empty_page.dart';
import '../../widgets/shimmer_text.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return cartProvider.getItems.isEmpty
        ? Scaffold(
            body: EmptyPage(
              image: AssetsManager.shoppingBasket,
              title: '"Your cart is empty"',
              subtitle:
                  '"looks Like you have not added anything to your cart. Go ahead explore top category"',
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomCheckout(
              function: () async {
                await placeOrder(
                    cartProvider: cartProvider,
                    userProvider: userProvider,
                    productProvider: productProvider);
              },
            ),
            appBar: AppBar(
              leading: Image.asset(
                AssetsManager.shoppingCart,
              ),
              title: ShimmerTitleText(
                  label: "Cart (${cartProvider.getItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethod.showErrorORWariningDailog(
                        isError: false,
                        context: context,
                        subtitle: "remove Items ?",
                        fct: () async {
                          await cartProvider.clearCartFromFirebase();
                          // cartProvider.clear();
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.getItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartProvider.getItems.values
                                .toList()
                                .reversed
                                .toList()[index],
                            child: const CartWidget());
                      },
                    ),
                  ),
                  const Gap(kBottomNavigationBarHeight + 10),
                ],
              ),
            ),
          );
  }

  Future<void> placeOrder(
      {required ProductProvider productProvider,
      required CartProvider cartProvider,
      required UserProvider userProvider}) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser!;
    //if (user == null) return;

    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getItems.forEach((key, value) async {
        final orderId = const Uuid().v4();
        final getCurrentId = productProvider.findByProductId(value.productId);
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .doc(orderId)
            .set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          "productTitle": getCurrentId!.productTitle,
          'price': double.parse(getCurrentId.productPrice) * value.quantity,
          'totalPrice': cartProvider.getTotal(product: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrentId.productImage,
          'userName': userProvider.getUser!.userName,
          'orderDate': Timestamp.now(),
        });
        cartProvider.clearCartFromFirebase();
        cartProvider.clear();
        Fluttertoast.showToast(msg: "Done !");
      });
    } catch (e) {
      MyAppMethod.showErrorORWariningDailog(
          context: context, subtitle: e.toString(), fct: () {});
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
