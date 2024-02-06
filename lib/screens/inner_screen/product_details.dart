import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../helper/app_methods.dart';
import '../../providers/product_provider.dart';
import '../../widgets/products/heart_btn.dart';
import '../../widgets/shimmer_text.dart';

class ProductDetailes extends StatefulWidget {
  const ProductDetailes({super.key});
  static String id = "ProductDetailes";
  @override
  State<ProductDetailes> createState() => _ProductDetailesState();
}

class _ProductDetailesState extends State<ProductDetailes> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProductId(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const ShimmerTitleText(label: "ShopSmart"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Badge(
              label: Text(getCurrentProduct!.productQuantity),
              child: const Icon(IconlyLight.bag_2),
            ),
          ),
        ],
      ),
      body:
      //  getCurrentProduct == null
      //     ? const SizedBox.shrink()
      //     :
           SingleChildScrollView(
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.productImage,
                    width: double.infinity,
                    height: size.height * 0.38,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              getCurrentProduct.productTitle,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Gap(10),
                          SubtitleTextWidget(
                            label: "\$${getCurrentProduct.productPrice}",
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        children: [
                          HeartButtonWidget(
                            color: Colors.blue.shade300,
                            productId: getCurrentProduct.productId,
                          ),
                          const Gap(10),
                          Expanded(
                            child: SizedBox(
                              height: kBottomNavigationBarHeight - 10,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
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
                                icon: Icon(
                                  cartProvider.isProductInCart(
                                          productId:
                                              getCurrentProduct.productId)
                                      ? Icons.check
                                      : Icons.shopping_cart_checkout_outlined,
                                ),
                                label: Text(
                                  cartProvider.isProductInCart(
                                          productId:
                                              getCurrentProduct.productId)
                                      ? "In Cart"
                                      : "Add to Cart",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitlesTextWidget(label: "About this item"),
                          SubtitleTextWidget(
                              label: "In ${getCurrentProduct.productCategory}")
                        ],
                      ),
                      const Gap(20),
                      SubtitleTextWidget(
                          label: getCurrentProduct.productDescription),
                    ],
                  ),
                )
              ]),
            ),
    );
  }
}
