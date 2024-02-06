import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/viewed_product.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/product_details.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/products/heart_btn.dart';
import '../../widgets/subtitle_text.dart';
import 'quantity_btm_sheet.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct =
        productProvider.findByProductId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);

    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () {
              viewedListProvider.addProductToHistory(
                  productId: getCurrentProduct.productId);
              Navigator.pushNamed(context, ProductDetailes.id);
            },
            child: FittedBox(
              child: IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FancyShimmerImage(
                          imageUrl: getCurrentProduct.productImage,
                          height: size.height * 0.2,
                          width: size.height * 0.2,
                        ),
                      ),
                      IntrinsicWidth(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TitlesTextWidget(
                                      label: getCurrentProduct.productTitle,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await cartProvider
                                            .removeItemFromFirebase(
                                          cartId: cartModel.cartId,
                                          productId:
                                              getCurrentProduct.productId,
                                          qty: cartModel.quantity,
                                        );
                                        // cartProvider.removeOneTtem(
                                        //     productId:
                                        //         getCurrentProduct.productId);
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                    ),
                                    HeartButtonWidget(
                                      size: 28,
                                      productId: getCurrentProduct.productId,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SubtitleTextWidget(
                                  label: " \$${getCurrentProduct.productPrice}",
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(12))),
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        context: context,
                                        builder: (context) {
                                          return QuentityBottomSheet(
                                            cartModel: cartModel,
                                          );
                                        });
                                  },
                                  icon: const Icon(IconlyLight.arrow_down_2),
                                  label: Text("Qty: ${cartModel.quantity} "),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
