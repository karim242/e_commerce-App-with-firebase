import 'package:e_commerce_app_with_firebase/providers/cart_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/user_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';

import 'screens/cart/cart_page.dart';

import 'screens/home_page.dart';
import 'screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'screens/profile_page.dart';

class RootScreens extends StatefulWidget {
  const RootScreens({super.key});
  static String id = 'RootScreens';

  @override
  State<RootScreens> createState() => _RootScreensState();
}

class _RootScreensState extends State<RootScreens> {
  int currentScreen = 0;
  bool isloadingProds = true;

  late PageController controller;
  List<Widget> screens = const [
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage(),
  ];

  Future<void> fetchFCT() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final wishlistProvider =
        Provider.of<WishListProvider>(context, listen: false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Future.wait({
        productProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
        wishlistProvider.fetchWishlist(),
      });
    } catch (e) {
     // print(e.toString());
    } finally {
      setState(() {
        isloadingProds = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (isloadingProds) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: 'home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: 'search',
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag_2),
            icon: Badge(
              label: Text("${cartProvider.getItems.length}"),
              child: const Icon(IconlyLight.bag_2),
            ),
            label: 'cart',
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
