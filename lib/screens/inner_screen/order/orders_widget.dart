import 'package:e_commerce_app_with_firebase/models/order_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class OrdersWidgetFree extends StatelessWidget {
  const OrdersWidgetFree({
    super.key, required this.ordersModelAdvanced,
  });
  final OrdersModelAdvanced ordersModelAdvanced;

  @override
  Widget build(BuildContext context) {
  
    final size = MediaQuery.of(context).size;
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                    imageUrl: ordersModelAdvanced.imageUrl,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TitlesTextWidget(
                                label: ordersModelAdvanced.productTitle,
                                maxLines: 2,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const TitlesTextWidget(
                              label: 'Price:  ',
                              fontSize: 15,
                            ),
                            Flexible(
                              child: SubtitleTextWidget(
                                label: "\$${ordersModelAdvanced.price}",
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SubtitleTextWidget(
                          label: "Qty: ${ordersModelAdvanced.quantity}",
                          fontSize: 15,
                        ),
                        // const Row(
                        //   children: [
                        //     Flexible(
                        //       child: TitlesTextWidget(
                        //         label: 'Qty:  ',
                        //         fontSize: 15,
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: SubtitleTextWidget(
                        //         label: "10",
                        //         fontSize: 15,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
