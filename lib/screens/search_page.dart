import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:e_commerce_app_with_firebase/models/product_model.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/widgets/products/products_widget.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../helper/assets_manager.dart';
import '../widgets/shimmer_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const routeName = 'SearchPage';
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    String? categoryName =
        ModalRoute.of(context)!.settings.arguments as String?;
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> ctgList = categoryName == null
        ? productProvider.getProducts
        : productProvider.findByCategoryName(ctgName: categoryName);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: Image.asset(
              AssetsManager.shoppingCart,
            ),
            title: ShimmerTitleText(label: categoryName ?? "Store Products"),
          ),
          body: ctgList.isEmpty
              ? const Center(
                  child: TitlesTextWidget(label: "No Proudect Founded"),
                )
              : StreamBuilder<List<ProductModel>>(
                  stream: productProvider.fetchProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child:
                            TitlesTextWidget(label: snapshot.error.toString()),
                      );
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: TitlesTextWidget(
                            label: "No Products has been added"),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(15),
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: "searh",
                                filled: true,
                                prefixIcon: const Icon(IconlyLight.search),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.clear();
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    )),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  productListSearch =
                                      productProvider.searchQuery(
                                    searchText: controller.text,
                                  );
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  productListSearch =
                                      productProvider.searchQuery(
                                    searchText: controller.text,
                                  );
                                });
                              },
                            ),
                            const Gap(15),
                            if (controller.text.isNotEmpty &&
                                productListSearch.isEmpty) ...[
                              const Center(
                                child: TitlesTextWidget(
                                  label: "No Result Found ",
                                  fontSize: 40,
                                ),
                              )
                            ],
                            DynamicHeightGridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.text.isNotEmpty
                                    ? productListSearch.length
                                    : ctgList.length,
                                builder: (context, index) {
                                  return ProductsWidget(
                                    productId: controller.text.isNotEmpty
                                        ? productListSearch[index].productId
                                        : ctgList[index].productId,
                                  );
                                },
                                crossAxisCount: 2)
                          ],
                        ),
                      ),
                    );
                  })),
    );
  }
}
