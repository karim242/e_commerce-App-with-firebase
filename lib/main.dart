import 'package:e_commerce_app_with_firebase/firebase_options.dart';
import 'package:e_commerce_app_with_firebase/providers/order_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/product_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/theme_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/user_provider.dart';
import 'package:e_commerce_app_with_firebase/providers/viewed_product.dart';
import 'package:e_commerce_app_with_firebase/providers/wish_list_provider.dart';
import 'package:e_commerce_app_with_firebase/root_screens.dart';
import 'package:e_commerce_app_with_firebase/screens/auth/register_screen.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/product_details.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/viewed_recently.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/wish_list.dart';
import 'package:e_commerce_app_with_firebase/screens/search_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'const/theme_data.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login_screen.dart';
import 'screens/inner_screen/order/orders_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Firebase.initializeApp(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         const Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       } else if (snapshot.hasError) {
    //         return Scaffold(
    //           body: Center(
    //             child: SelectableText(
    //                 "An error has been occured ${snapshot.error}"),
    //           ),
    //         );
    //  }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewedListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
         ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (
        context,
        themeProvider,
        child,
      ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const RootScreens(),
          // home: const LoginScreen(),
          routes: {
            ProductDetailes.id: (context) => const ProductDetailes(),
            WishList.id: (context) => const WishList(),
            RootScreens.id: (context) => const RootScreens(),
            ViewedRecently.id: (context) => const ViewedRecently(),
            LoginScreen.id: (context) => const LoginScreen(),
            RegisterScreen.id: (context) => const RegisterScreen(),
            OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            ForgotPasswordScreen.routeName: (context) =>
                const ForgotPasswordScreen(),
            SearchPage.routeName: (context) => const SearchPage(),
          },
        );
      }),
    );
  }
}
