import 'package:flutter/cupertino.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/item_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool showDivider;
  const CartItemWidget(
      {super.key,
      required this.cart,
      required this.cartIndex,
      required this.isAvailable,
      required this.addOns,
      required this.showDivider});

  @override
  Widget build(BuildContext context) {
    double? discount = cart.item!.discount;
    String? discountType = cart.item!.discountType;

    double totalPrice = _calculatePriceWithVariation(
        cartModel: cart, discount: discount, discountType: discountType);
    double originalPrice = _calculatePriceWithVariation(
        cartModel: cart, discount: 0, discountType: 'amount');

    double unitPrice = totalPrice / cart.quantity!;
    double unitOriginalPrice = originalPrice / cart.quantity!;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: CustomInkWell(
          onTap: () {
            ResponsiveHelper.isMobile(context)
                ? showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => ItemBottomSheet(
                        itemId: cart.item!.id!,
                        cartIndex: cartIndex,
                        cart: cart),
                  )
                : showDialog(
                    context: context,
                    builder: (con) => Dialog(
                          child: ItemBottomSheet(
                              itemId: cart.item!.id!,
                              cartIndex: cartIndex,
                              cart: cart),
                        ));
          },
          radius: Dimensions.radiusDefault,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            // Item Image on the RIGHT (First in Row children for RTL right alignment)
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImage(
                  image: '${cart.item!.imageFullUrl}',
                  height: 65,
                  width: 65,
                  fit: BoxFit.cover,
                ),
              ),
              isAvailable
                  ? const SizedBox()
                  : Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            color: Colors.black.withValues(alpha: 0.6)),
                        child: Text('not_available_now_break'.tr,
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                            )),
                      ),
                    ),
            ]),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            // Item Details in the MIDDLE
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cart.item!.name!,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(children: [
                      unitOriginalPrice > unitPrice
                          ? Text(
                              PriceConverter.convertPrice(unitOriginalPrice),
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).disabledColor,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : const SizedBox(),
                      SizedBox(
                          width: unitOriginalPrice > unitPrice
                              ? Dimensions.paddingSizeExtraSmall
                              : 0),
                      Text(
                        PriceConverter.convertPrice(unitPrice),
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      PriceConverter.convertPrice(totalPrice),
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColor),
                    ),
                  ]),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            // Quantity buttons on the LEFT
            GetBuilder<CartController>(builder: (cartController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: Row(children: [
                  _quantityButton(
                    context: context,
                    icon: Icons.remove,
                    onTap: cartController.isLoading
                        ? null
                        : () {
                            if (cart.quantity! > 1) {
                              Get.find<CartController>().setQuantity(false,
                                  cartIndex, cart.stock, cart.quantityLimit);
                            } else {
                              Get.find<CartController>()
                                  .removeFromCart(cartIndex, item: cart.item);
                            }
                          },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      cart.quantity.toString(),
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                  _quantityButton(
                    context: context,
                    icon: Icons.add,
                    isColor: true,
                    onTap: cartController.isLoading
                        ? null
                        : () {
                            Get.find<CartController>().forcefullySetModule(
                                Get.find<CartController>()
                                    .cartList[0]
                                    .item!
                                    .moduleId!);
                            Get.find<CartController>().setQuantity(true,
                                cartIndex, cart.stock, cart.quantityLimit);
                          },
                  ),
                ]),
              );
            }),
          ]),
        ),
      ),
    );
  }

  Widget _quantityButton(
      {required BuildContext context,
      required IconData icon,
      required VoidCallback? onTap,
      bool isColor = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isColor ? null : Theme.of(context).cardColor,
          gradient: isColor ? AppColors.mainGradient : null,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)
          ],
        ),
        child: Icon(icon,
            size: 18,
            color: isColor ? Colors.white : Theme.of(context).primaryColor),
      ),
    );
  }

  double _calculatePriceWithVariation(
      {required CartModel cartModel,
      required double? discount,
      required String? discountType}) {
    bool newVariation = Get.find<SplashController>()
            .getModuleConfig(cartModel.item!.moduleType)
            .newVariation ??
        false;
    double price = 0;
    if (newVariation) {
      for (int index = 0;
          index < cartModel.item!.foodVariations!.length;
          index++) {
        for (int i = 0;
            i < cartModel.item!.foodVariations![index].variationValues!.length;
            i++) {
          if (cartModel.foodVariations![index][i]!) {
            price += (PriceConverter.convertWithDiscount(
                    cartModel.item!.foodVariations![index].variationValues![i]
                        .optionPrice!,
                    discount,
                    discountType,
                    isFoodVariation: true)! *
                cartModel.quantity!);
          }
        }
      }
      price = price +
          _calculateAddonPrice(cartModel) +
          (PriceConverter.convertWithDiscount(
                  cartModel.item!.price!, discount, discountType,
                  isFoodVariation: true)! *
              cartModel.quantity!);
    } else {
      String variationType = '';
      for (int i = 0; i < cartModel.variation!.length; i++) {
        variationType = cartModel.variation![i].type!;
      }
      if (variationType.isNotEmpty) {
        for (Variation variation in cartModel.item!.variations!) {
          if (variation.type == variationType) {
            price = (PriceConverter.convertWithDiscount(
                    variation.price!, discount, discountType)! *
                cartModel.quantity!);
            break;
          }
        }
      } else {
        price = (PriceConverter.convertWithDiscount(
                cartModel.item!.price!, discount, discountType)! *
            cartModel.quantity!);
      }
    }
    return price;
  }

  double _calculateAddonPrice(CartModel cartModel) {
    List<AddOns> addOnList = [];
    double addonPrice = 0;
    for (var addOnId in cartModel.addOnIds!) {
      for (AddOns addOns in cartModel.item!.addOns!) {
        if (addOns.id == addOnId.id) {
          addOnList.add(addOns);
          break;
        }
      }
    }
    for (int index = 0; index < addOnList.length; index++) {
      addonPrice = addonPrice +
          (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
    }
    return addonPrice;
  }
}
