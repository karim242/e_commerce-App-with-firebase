import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:e_commerce_app_with_firebase/providers/viewed_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_methods.dart';
import '../../helper/assets_manager.dart';
import '../../widgets/empty_page.dart';
import '../../widgets/products/products_widget.dart';
import '../../widgets/shimmer_text.dart';

class ViewedRecently extends StatelessWidget {
  const ViewedRecently({super.key});
  static String id = "ViewedRecently";

  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    return viewedListProvider.getViewedistItems.isEmpty
        ? Scaffold(
            body: EmptyPage(
              image: AssetsManager.orderBag,
              title: '"Your ViewedRecently is empty"',
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
                      "Viewed Recently(${viewedListProvider.getViewedistItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethod.showErrorORWariningDailog(
                        isError: false,
                        context: context,
                        subtitle: "Remove Items ?",
                        fct: () {
                          viewedListProvider.clear();
                        });
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
              itemCount: viewedListProvider.getViewedistItems.length,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductsWidget(
                    productId: viewedListProvider.getViewedistItems.values
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
