import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/order/widgets/order_shimmer_widget.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';
import 'package:sixam_mart/features/order/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderViewWidget extends StatelessWidget {
  final bool isRunning;
  const OrderViewWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GetBuilder<OrderController>(builder: (orderController) {
        PaginatedOrderModel? paginatedOrderModel;
        if (isRunning) {
          paginatedOrderModel = orderController.runningOrderModel;
        } else {
          paginatedOrderModel = orderController.historyOrderModel;
        }

        return paginatedOrderModel != null
            ? paginatedOrderModel.orders!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      if (isRunning) {
                        await orderController.getRunningOrders(1,
                            isUpdate: true);
                      } else {
                        await orderController.getHistoryOrders(1,
                            isUpdate: true);
                      }
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: FooterView(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: ResponsiveHelper.isDesktop(context)
                                    ? 0
                                    : 100),
                            child: PaginatedListView(
                              scrollController: scrollController,
                              onPaginate: (int? offset) async {
                                if (isRunning) {
                                  await orderController.getRunningOrders(
                                      offset!,
                                      isUpdate: true);
                                } else {
                                  await orderController.getHistoryOrders(
                                      offset!,
                                      isUpdate: true);
                                }
                              },
                              totalSize: isRunning
                                  ? orderController.runningOrderModel?.totalSize
                                  : orderController
                                      .historyOrderModel?.totalSize,
                              offset: isRunning
                                  ? orderController.runningOrderModel?.offset
                                  : orderController.historyOrderModel?.offset,
                              itemView: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing:
                                      ResponsiveHelper.isDesktop(context)
                                          ? Dimensions.paddingSizeExtremeLarge
                                          : Dimensions.paddingSizeLarge,
                                  mainAxisSpacing:
                                      ResponsiveHelper.isDesktop(context)
                                          ? Dimensions.paddingSizeExtremeLarge
                                          : 0,
                                  mainAxisExtent:
                                      ResponsiveHelper.isDesktop(context)
                                          ? 130
                                          : 125,
                                  crossAxisCount:
                                      ResponsiveHelper.isMobile(context)
                                          ? 1
                                          : 2,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: ResponsiveHelper.isDesktop(context)
                                    ? const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeLarge)
                                    : const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall),
                                itemCount: paginatedOrderModel.orders!.length,
                                itemBuilder: (context, index) {
                                  bool isParcel = paginatedOrderModel!
                                          .orders![index].orderType ==
                                      'parcel';
                                  bool isPrescription = paginatedOrderModel
                                      .orders![index].prescriptionOrder!;

                                  return Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    margin: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusLarge),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CustomInkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteHelper.getOrderDetailsRoute(
                                              paginatedOrderModel!
                                                  .orders![index].id),
                                          arguments: OrderDetailsScreen(
                                            orderId: paginatedOrderModel
                                                .orders![index].id,
                                            orderModel: paginatedOrderModel
                                                .orders![index],
                                          ),
                                        );
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Stack(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  child: CustomImage(
                                                    image: isParcel
                                                        ? '${paginatedOrderModel.orders![index].parcelCategory != null ? paginatedOrderModel.orders![index].parcelCategory!.imageFullUrl : ''}'
                                                        : '${paginatedOrderModel.orders![index].store != null ? paginatedOrderModel.orders![index].store!.logoFullUrl : ''}',
                                                    height:
                                                        isDesktop ? 100 : 80,
                                                    width: isDesktop ? 100 : 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                isParcel
                                                    ? Positioned(
                                                        left: 0,
                                                        top: 10,
                                                        child: Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        Dimensions
                                                                            .radiusSmall)),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          child: Text(
                                                              'parcel'.tr,
                                                              style:
                                                                  robotoMedium
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraSmall,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ))
                                                    : const SizedBox(),
                                                isPrescription
                                                    ? Positioned(
                                                        left: 0,
                                                        top: 10,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        Dimensions
                                                                            .radiusSmall)),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          child: Text(
                                                              'prescription'.tr,
                                                              style:
                                                                  robotoMedium
                                                                      .copyWith(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ))
                                                    : const SizedBox(),
                                              ]),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(children: [
                                                        Text(
                                                          '${isParcel ? 'delivery_id'.tr : 'order_id'.tr}:',
                                                          style: robotoRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                            '#${paginatedOrderModel.orders![index].id}',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall)),
                                                      ]),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeSmall),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeSmall,
                                                            vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.05),
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1)),
                                                        ),
                                                        child: Text(
                                                            paginatedOrderModel
                                                                .orders![index]
                                                                .orderStatus!
                                                                .tr,
                                                            style: robotoMedium
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeSmall),
                                                      Text(
                                                        DateConverter
                                                            .dateTimeStringToDateTime(
                                                                paginatedOrderModel
                                                                    .orders![
                                                                        index]
                                                                    .createdAt!),
                                                        style: robotoRegular.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                      ),
                                                    ]),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    isRunning
                                                        ? InkWell(
                                                            onTap: () => Get.toNamed(
                                                                RouteHelper.getOrderTrackingRoute(
                                                                    paginatedOrderModel!
                                                                        .orders![
                                                                            index]
                                                                        .id,
                                                                    null)),
                                                            child: Container(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall,
                                                                  vertical: 8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient: AppColors
                                                                    .mainGradient,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusSmall),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: AppColors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.2),
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                  children: [
                                                                    Image.asset(
                                                                        Images
                                                                            .tracking,
                                                                        height:
                                                                            15,
                                                                        width:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                    Text(
                                                                        isParcel
                                                                            ? 'track_delivery'
                                                                                .tr
                                                                            : 'track_order'
                                                                                .tr,
                                                                        style: robotoMedium
                                                                            .copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraSmall,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ]),
                                                            ),
                                                          )
                                                        : isParcel
                                                            ? const SizedBox()
                                                            : Text(
                                                                '${paginatedOrderModel.orders![index].detailsCount} ${paginatedOrderModel.orders![index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                                                style: robotoRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall),
                                                              ),
                                                  ]),
                                            ]),
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : NoDataScreen(text: 'no_order_found'.tr, showFooter: true)
            : OrderShimmerWidget(orderController: orderController);
      }),
    );
  }
}
