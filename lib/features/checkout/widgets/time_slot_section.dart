import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/checkout/widgets/time_slot_bottom_sheet.dart';

class TimeSlotSection extends StatelessWidget {
  final int? storeId;
  final CheckoutController checkoutController;
  final List<CartModel?>? cartList;
  final JustTheController tooltipController2;
  final bool tomorrowClosed;
  final bool todayClosed;
  final Module? module;
  const TimeSlotSection({
    super.key,
    this.storeId,
    required this.checkoutController,
    this.cartList,
    required this.tooltipController2,
    required this.tomorrowClosed,
    required this.todayClosed,
    this.module,
  });

  @override
  Widget build(BuildContext context) {
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    bool showTimeSlot = !isGuestLoggedIn &&
        storeId == null &&
        checkoutController.store!.scheduleOrder! &&
        cartList!.isNotEmpty &&
        cartList![0]!.item!.availableDateStarts == null;

    return showTimeSlot
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: [
                BoxShadow(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    blurRadius: 10)
              ],
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Column(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('preference_time'.tr,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  JustTheTooltip(
                    backgroundColor: Colors.black87,
                    controller: tooltipController2,
                    preferredDirection: AxisDirection.right,
                    tailLength: 14,
                    tailBaseWidth: 20,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('schedule_time_tool_tip'.tr,
                          style: robotoRegular.copyWith(color: Colors.white)),
                    ),
                    child: InkWell(
                      onTap: () => tooltipController2.showTooltip(),
                      child: const Icon(Icons.info_outline, size: 18),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                InkWell(
                  onTap: () {
                    if (ResponsiveHelper.isDesktop(context)) {
                      showDialog(
                          context: context,
                          builder: (con) => Dialog(
                                child: TimeSlotBottomSheet(
                                  tomorrowClosed: tomorrowClosed,
                                  todayClosed: todayClosed,
                                  module: module,
                                ),
                              ));
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => TimeSlotBottomSheet(
                          tomorrowClosed: tomorrowClosed,
                          todayClosed: todayClosed,
                          module: module,
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.05),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.3),
                            width: 0.5),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault)),
                    height: 50,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                      Expanded(
                        child: ((checkoutController.selectedDateSlot == 0 &&
                                    todayClosed) ||
                                (checkoutController.selectedDateSlot == 1 &&
                                    tomorrowClosed))
                            ? Center(
                                child: Text(
                                    module!.showRestaurantText!
                                        ? 'restaurant_is_closed'.tr
                                        : 'store_is_closed'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error)))
                            : Text(
                                checkoutController.preferableTime.isNotEmpty
                                    ? checkoutController.preferableTime
                                    : 'instance'.tr,
                                style: robotoMedium.copyWith(
                                    color: checkoutController
                                            .preferableTime.isNotEmpty
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                              ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 28),
                      Icon(Icons.access_time_rounded,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    ]),
                  ),
                ),
              ]),
            ]),
          )
        : const SizedBox();
  }
}
