import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/models/product_model.dart';
import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/viewed_product.dart';

import 'package:e_commerce_app_with_firebase/screens/inner_screen/product_details.dart';
import 'package:e_commerce_app_with_firebase/widgets/products/heart_btn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../subtitle_text.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final productModel = Provider.of<ProductModel>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          viewedListProvider.addProductToHistory(
              productId: productModel.productId);
          Navigator.pushNamed(context, ProductDetailes.id,
              arguments: productModel.productId);
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productModel.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            HeartButtonWidget(
                                size: 26, productId: productModel.productId),
                            IconButton(
                              onPressed: () async {
                                if (cartProvider.isProductInCart(
                                    productId: productModel.productId)) {
                                  return;
                                }
                                // cartProvider.addProductToCart(
                                //     productId: getCurrProduct.productId);
                                try {
                                  await cartProvider.addToCartFirebase(
                                      productId: productModel.productId,
                                      qty: 1,
                                      context: context);
                                } catch (error) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    MyAppMethod.showErrorORWariningDailog(
                                        context: context,
                                        subtitle: error.toString(),
                                        fct: () {});
                                  });
                                }
                              },
                              icon: Icon(
                                cartProvider.isProductInCart(
                                        productId: productModel.productId)
                                    ? Icons.check
                                    : Icons.shopping_cart_checkout_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: SubtitleTextWidget(
                          label: "\$${productModel.productPrice}",
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
