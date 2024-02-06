import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key, required this.function});
  final Function function;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // final getCurrentProduct =
    // productProvider.findByProductId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: TitlesTextWidget(
                      label:
                          "Total (${cartProvider.getItems.length} products/${cartProvider.getQuantity()} Items)",
                      fontSize: 14,
                    ),
                  ),
                  SubtitleTextWidget(
                    label:
                        "\$${cartProvider.getTotal(product: productProvider)}",
                    color: Colors.blue,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  function();
                },
                child: const Text("Checkout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
