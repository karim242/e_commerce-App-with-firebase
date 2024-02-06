import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final Color color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          // wishlistProvider.addOrRemoveFromWishlist(productId: widget.productId);
          // log("wishlist Map is: ${wishlistProvider.getWishlistItems} ");
          setState(() {
            isLoading = true;
          });
          try {
            if (wishListProvider.getWishListItems
                .containsKey(widget.productId)) {
              wishListProvider.removeWishlistItemFromFirebase(
                wishlistId: wishListProvider
                    .getWishListItems[widget.productId]!.wishListId,
                productId: widget.productId,
              );
            } else {
              wishListProvider.addToWishlistFirebase(
                  productId: widget.productId, context: context);
            }
            await wishListProvider.fetchWishlist();
          } catch (e) {
            if (!mounted) return;
            MyAppMethod.showErrorORWariningDailog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        icon: isLoading
            ? const CircularProgressIndicator()
            : Icon(
                wishListProvider.isProductInWishList(
                        productId: widget.productId)
                    ? IconlyBold.heart
                    : IconlyLight.heart,
          size: widget.size,
          color:
              wishListProvider.isProductInWishList(productId: widget.productId)
                  ? Colors.red
                  : Colors.grey,
        ),
      ),
    );
  }
}
