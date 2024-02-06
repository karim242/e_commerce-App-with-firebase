import 'package:e_commerce_app_with_firebase/models/user_model.dart';
import 'package:e_commerce_app_with_firebase/providers/user_provider.dart';
import 'package:e_commerce_app_with_firebase/screens/auth/login_screen.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/viewed_recently.dart';
import 'package:e_commerce_app_with_firebase/screens/inner_screen/wish_list.dart';
import 'package:e_commerce_app_with_firebase/screens/loading_manager.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../helper/app_methods.dart';
import '../helper/assets_manager.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/shimmer_text.dart';
import 'inner_screen/order/orders_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
//   User? user = FirebaseAuth.instance.currentUser;
//   UserModel? userModel;
//   Future<void> fetchUserInfo() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     try {
//       userModel = await userProvider.fetchUserInfo();
//     } catch (error) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await MyAppMethod.showErrorORWariningDailog(
//           context: context,
//           subtitle: "An error has been occured $error",
//           fct: () {},
//         );
//       });
//     }
//   }
//   @override
//   void initState() {
//     fetchUserInfo();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           leading: Image.asset(
//             AssetsManager.shoppingCart,
//           ),
//           title: const ShimmerTitleText(label: "ShopSmart"),
//         ),
//         body: ListView(
//           children: [
//             if (user == null) ...[
//               const Visibility(
//                 // visible: false, //
//                 child: Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: SubtitleTextWidget(
//                       label: " Please login to have ultimate access"),
//                 ),
//               ),
//             ] else ...[
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     child: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Theme.of(context).cardColor,
//                         border: Border.all(
//                           color: Colors.blue,
//                           width: 3,
//                         ),
//                         // image: DecorationImage(
//                         //   image: NetworkImage(
//                         //   userModel!.userImage??"",
//                         // ),
//                         //  fit: BoxFit.fill,
//                         //  ),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TitlesTextWidget(label: userModel!.userName),
//                       SubtitleTextWidget(
//                         label: userModel!.userEmail,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const TitlesTextWidget(label: "General"),
//                   user == null
//                       ? const SizedBox.shrink()
//                       : CustomListTile(
//                           imagePath: AssetsManager.orderSvg,
//                           text: "All orders",
//                           function: () async {
//                             await Navigator.pushNamed(
//                                 context, OrdersScreenFree.routeName);
//                           },
//                         ),
//                   user == null
//                       ? const SizedBox.shrink()
//                       : CustomListTile(
//                           imagePath: AssetsManager.wishlistSvg,
//                           text: "Wishlist",
//                           function: () async {
//                             await Navigator.pushNamed(context, WishList.id);
//                           },
//                         ),
//                   CustomListTile(
//                     imagePath: AssetsManager.recent,
//                     text: "Viewed recently",
//                     function: () async {
//                       await Navigator.pushNamed(context, ViewedRecently.id);
//                     },
//                   ),
//                   CustomListTile(
//                     imagePath: AssetsManager.address,
//                     text: "Address",
//                     function: () {},
//                   ),
//                   const Divider(
//                     thickness: 1,
//                   ),
//                   const TitlesTextWidget(label: "Settings"),
//                   SwitchListTile(
//                       secondary: Image.asset(
//                         AssetsManager.theme,
//                         height: 30,
//                       ),
//                       title: themeProvider.getIsDarkTheme
//                           ? const Text("Dark Mode")
//                           : const Text(" Light Mode"),
//                       value: themeProvider.getIsDarkTheme,
//                       onChanged: (value) {
//                         themeProvider.setDarkTheme(themeValue: value);
//                       }),
//                   const Divider(
//                     thickness: 1,
//                   ),
//                 ],
//               ),
//             ),
//             Center(
//               child: CustomButton(
//                 label: user == null ? 'login' : "logout",
//                 color: Colors.white,
//                 icon: user == null ? IconlyLight.login : IconlyLight.logout,
//                 function: () async {
//                   user == null
//                       ? await Navigator.pushNamed(context, LoginScreen.id)
//                       : await MyAppMethod.showErrorORWariningDailog(
//                           context: context,
//                           subtitle: "Are you sure?",
//                           fct: () async {
//                             await FirebaseAuth.instance.signOut();
//                             WidgetsBinding.instance
//                                 .addPostFrameCallback((_) async {
//                               await Navigator.pushNamed(
//                                   context, LoginScreen.id);
//                             });
//                           },
//                           isError: false);
//                 },
//               ),
//             ),
//             const Gap(10)
//           ],
//         ));
//   }
// }

  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await MyAppMethod.showErrorORWariningDailog(
          context: context,
          subtitle: "An error has been occured $error",
          fct: () {},
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const ShimmerTitleText(
            fontSize: 20,
            label: 'ShopSmart',
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TitlesTextWidget(
                        label: "Please login to have ultimate access"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                userModel == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 3),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userModel!.userImage,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitlesTextWidget(label: userModel!.userName),
                                SubtitleTextWidget(
                                  label: userModel!.userEmail,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitlesTextWidget(label: "General"),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.orderSvg,
                              text: "All orders",
                              function: () async {
                                await Navigator.pushNamed(
                                  context,
                                  OrdersScreenFree.routeName,
                                );
                              },
                            ),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.wishlistSvg,
                              text: "Wishlist",
                              function: () async {
                                await Navigator.pushNamed(
                                  context,
                                  WishList.id,
                                );
                              },
                            ),
                      CustomListTile(
                        imagePath: AssetsManager.recent,
                        text: "Viewed recently",
                        function: () async {
                          await Navigator.pushNamed(
                            context,
                            ViewedRecently.id,
                          );
                        },
                      ),
                      CustomListTile(
                        imagePath: AssetsManager.address,
                        text: "Address",
                        function: () {},
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const TitlesTextWidget(label: "Settings"),
                      const SizedBox(
                        height: 7,
                      ),
                      SwitchListTile(
                        secondary: Image.asset(
                          AssetsManager.theme,
                          height: 30,
                        ),
                        title: Text(themeProvider.getIsDarkTheme
                            ? "Dark mode"
                            : "Light mode"),
                        value: themeProvider.getIsDarkTheme,
                        onChanged: (value) {
                          themeProvider.setDarkTheme(themeValue: value);
                        },
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: CustomButton(
                    label: user == null ? 'login' : "logout",
                    color: Colors.white,
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    function: () async {
                      if (user == null) {
                        await Navigator.pushNamed(
                          context,
                          LoginScreen.id,
                        );
                      } else {
                        await MyAppMethod.showErrorORWariningDailog(
                          context: context,
                          subtitle: "Are you sure?",
                          fct: () async {
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            await Navigator.pushNamed(
                              context,
                              LoginScreen.id,
                            );
                          },
                          isError: false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.function});
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: SubtitleTextWidget(label: text),
      trailing: const Icon(IconlyLight.arrow_right_2),
    );
  }
}
