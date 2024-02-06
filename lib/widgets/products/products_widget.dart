import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/providers/viewed_product.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/product_details.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import 'heart_btn.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key, required this.productId});
  final String productId;
  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProductId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              viewedListProvider.addProductToHistory(
                  productId: getCurrentProduct.productId);
              Navigator.pushNamed(context, ProductDetailes.id,
                  arguments: getCurrentProduct.productId);
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * 0.22,
                      width: double.infinity),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      //  flex: 1,
                      child: TitlesTextWidget(
                        label: getCurrentProduct.productTitle,
                        maxLines: 2,
                        fontSize: 16,
                      ),
                    ),
                    Flexible(
                        child: HeartButtonWidget(
                      size: 28,
                      productId: getCurrentProduct.productId,
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      //  flex: 1,
                      child: SubtitleTextWidget(
                        label: "\$${getCurrentProduct.productPrice}",
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                    Flexible(
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        // color: Theme.of(context).secondaryHeaderColor,
                        color: const Color(0xFFC66868),
                        child: InkWell(
                          onTap: () async {
                            if (cartProvider.isProductInCart(
                                productId: getCurrentProduct.productId)) {
                              return;
                            }
                            // cartProvider.addProductToCart(
                            //     productId: getCurrProduct.productId);
                            try {
                              await cartProvider.addToCartFirebase(
                                  productId: getCurrentProduct.productId,
                                  qty: 1,
                                  context: context);
                            } catch (error) {
                              if (!mounted) return;
                              MyAppMethod.showErrorORWariningDailog(
                                  context: context,
                                  subtitle: error.toString(),
                                  fct: () {});
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? Icons.check
                                  : Icons.shopping_cart_checkout_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(10)
              ],
            ),
          );
  }
}
