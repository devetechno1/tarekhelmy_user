import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

class CheckoutScreenShimmerView extends StatelessWidget {
  const CheckoutScreenShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: ResponsiveHelper.isMobile(context) ? const CheckoutShimmerView() : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const Expanded(
              flex: 6,
              child: CheckoutShimmerView(),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraLarge),

            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).shadowColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            height: 15, width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),

                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),


                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),

                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),

                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),

                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),

                            Container(
                              height: 15, width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),

                        ]),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(children: [
                          Row(children: [

                            Container(
                              height: 15, width: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                            const Spacer(),

                            Container(
                              height: 15, width: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Icon(Icons.add, color: Theme.of(context).cardColor),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            child: Row(children: [

                              Icon(Icons.countertops, color: Theme.of(context).cardColor),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Container(
                                height: 10, width: 120,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                              ),
                              const Spacer(),

                              Container(
                                height: 40, width: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15, width: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              height: 120, width: context.width,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }
}

class CheckoutShimmerView extends StatelessWidget {
  const CheckoutShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        width: context.width,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).shadowColor),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(
                height: 20, width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),

                    child: Row(children: [
                      Radio(activeColor: Theme.of(context).cardColor, value: 0, groupValue: 0, onChanged: (value) {}),

                      Container(
                        height: 20, width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),

                    child: Row(children: [
                      Radio(activeColor: Theme.of(context).cardColor, value: 0, groupValue: 0, onChanged: (value) {}),

                      Container(
                        height: 20, width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Shimmer(
            child: Container(
              height: 20, width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
          ),
        ),
      ),

      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).shadowColor),
        ),
        child: Column(children: [
          Row(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),
            ),
            const Spacer(),

            Icon(Icons.add, color: Theme.of(context).shadowColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Shimmer(
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Row(children: [

                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Row(children: [
                      Icon(Icons.menu, color: Theme.of(context).cardColor),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Container(
                        height: 10, width: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                    ]),

                    Container(
                      height: 10, width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),

                  ]),
                  const Spacer(),

                  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).cardColor),

                ]),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Shimmer(
              child: Container(
                height: 50,
                width: context.width,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Shimmer(
                    child: Container(
                      height: 50,
                      width: context.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Shimmer(
                    child: Container(
                      height: 50,
                      width: context.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 15, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),

            Icon(Icons.add, color: Theme.of(context).cardColor),

          ]),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).shadowColor),
        ),
        child: Column(children: [
          Row(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),
            ),
            const Spacer(),

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Icon(Icons.add, color: Theme.of(context).shadowColor),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Shimmer(
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Row(children: [

                  Icon(Icons.countertops, color: Theme.of(context).cardColor),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Container(
                    height: 10, width: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                  const Spacer(),

                  Container(
                    height: 40, width: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        width: context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).shadowColor),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(
                    child: Container(
                      height: 20, width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Icon(Icons.info_outline, color: Theme.of(context).shadowColor),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Shimmer(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Shimmer(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Shimmer(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Shimmer(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Shimmer(
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 15, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),

            Icon(Icons.add, color: Theme.of(context).cardColor),

          ]),
        ),
      ),

    ]);
  }
}
