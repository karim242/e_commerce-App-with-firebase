import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:e_commerce_app_with_firebase/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_methods.dart';
import '../../helper/assets_manager.dart';
import '../../widgets/empty_page.dart';
import '../../widgets/products/products_widget.dart';
import '../../widgets/shimmer_text.dart';

class WishList extends StatelessWidget {
  const WishList({super.key});
  static String id = "WishList";

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return wishListProvider.getWishListItems.isEmpty
        ? Scaffold(
            body: EmptyPage(
              image: AssetsManager.bagWish,
              title: '"Your cart is empty"',
              subtitle:
                  '"looks Like you have not added anything to your cart. Go ahead explore top category"',
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: ShimmerTitleText(
                  label:
                      "WishList(${wishListProvider.getWishListItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethod.showErrorORWariningDailog(
                        isError: false,
                        context: context,
                        subtitle: "remove Items ?",
                        fct: () {});
                    wishListProvider.clear();
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: wishListProvider.getWishListItems.length,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductsWidget(
                    productId: wishListProvider.getWishListItems.values
                        .toList()[index]
                        .productId,
                  ),
                );
              },
              crossAxisCount: 2,
            ),
          );
  }
}
