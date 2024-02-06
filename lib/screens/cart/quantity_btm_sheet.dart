import 'package:e_commerce_app_with_firebase/models/cart_model.dart';
import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class QuentityBottomSheet extends StatelessWidget {
  const QuentityBottomSheet({super.key, required this.cartModel});
  final CartModel cartModel;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        const Gap(16),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const Gap(10),
        Expanded(
          child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    cartProvider.updateQuantity(
                        productId: cartModel.productId, quantity: index + 1);
                    Navigator.pop(context);
                    // log((index + 1) as String);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: SubtitleTextWidget(label: "${index + 1}")),
                  ),
                );
              }),
        )
      ],
    );
  }
}
