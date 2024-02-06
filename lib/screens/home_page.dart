import 'package:card_swiper/card_swiper.dart';
import 'package:e_commerce_app_with_firebase/helper/assets_manager.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/widgets/products/ctg_rounded_widget.dart';
import 'package:e_commerce_app_with_firebase/widgets/shimmer_text.dart';

import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../const/app_const.dart';
import '../widgets/products/latest_arrival.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            AssetsManager.shoppingCart,
          ),
          title: const ShimmerTitleText(label: "ShopSmart"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.28,
                child: Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      AppConstant.bannersImage[index],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: AppConstant.bannersImage.length,
                  pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: Color(0xFFBBA2E7),
                        activeColor: Colors.deepPurple,
                      )),
                ),
              ),
              const Gap(10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const TitlesTextWidget(label: "Latest arrival"),
                const Gap(6),
                SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.getProducts.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productProvider.getProducts[index],
                            child:  LatestArrivalProductsWidget(
                              productId: productProvider.getProducts[index].productId,

                            ));
                      }),
                ),
                const Gap(10),
                const TitlesTextWidget(
                  label: "Categories",
                  fontSize: 22,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children:
                      List.generate(AppConstant.categoriesList.length, (index) {
                    return CategoryRoundedWidget(
                        image: AppConstant.categoriesList[index].image,
                        name: AppConstant.categoriesList[index].name);
                  }),
                )
              ]),
            ],
          ),
        ));
  }
}
