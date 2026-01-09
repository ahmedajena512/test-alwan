import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/rental_module/rental_order/controllers/taxi_order_controller.dart';
import 'package:sixam_mart/features/rental_module/rental_order/widgets/trip_order_view_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/taxi_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/order/widgets/guest_track_order_input_view_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  final int? index;
  const OrderScreen({super.key, this.index = 0});

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = AuthHelper.isLoggedIn();
  List<String> type = ['orders', 'trips'];
  int selectTypeIndex = 0;
  bool haveTaxiModule = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    selectTypeIndex = widget.index!;
    haveTaxiModule = TaxiHelper.haveTaxiModule();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      if (selectTypeIndex == 0) {
        Get.find<OrderController>().getRunningOrders(1);
        Get.find<OrderController>().getHistoryOrders(1);
      } else {
        Get.find<TaxiOrderController>().getTripList(1, isRunning: true);
        Get.find<TaxiOrderController>().getTripList(1, isRunning: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // Removed CustomAppBar for mobile to match FavouriteScreen style
      appBar: haveTaxiModule && !ResponsiveHelper.isDesktop(context)
          ? null
          : (ResponsiveHelper.isDesktop(context)
              ? CustomAppBar(title: 'my_orders'.tr, backButton: true)
              : null),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<OrderController>(
          builder: (orderController) {
            return Column(
              children: [
                // Custom Header Section (Matching FavouriteScreen)
                if (!ResponsiveHelper.isDesktop(context))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'my_orders'.tr,
                          style: robotoBold.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                haveTaxiModule && !ResponsiveHelper.isDesktop(context)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 10))
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeSmall),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              // Text('my_orders'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)), // Removed redundant title
                              // const SizedBox(height: Dimensions.paddingSizeDefault),

                              SizedBox(
                                height: 30,
                                child: ListView.builder(
                                    itemCount: type.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      bool selected = index == selectTypeIndex;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusLarge),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 0.3),
                                        ),
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            right: Dimensions.paddingSizeSmall),
                                        child: CustomInkWell(
                                          onTap: () {
                                            setState(() {
                                              selectTypeIndex = index;
                                            });
                                            initCall();
                                          },
                                          radius: Dimensions.radiusLarge,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeDefault),
                                          child: Text(type[index].tr,
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: selected
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color!
                                                          .withValues(
                                                              alpha: 0.7))),
                                        ),
                                      );
                                    }),
                              ),
                            ]),
                      )
                    : const SizedBox(),

                _isLoggedIn
                    ? Expanded(
                        child: Column(children: [
                          ResponsiveHelper.isDesktop(context)
                              ? Container(
                                  color: ResponsiveHelper.isDesktop(context)
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  child: Column(children: [
                                    ResponsiveHelper.isDesktop(context)
                                        ? Center(
                                            child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeSmall),
                                            child: Text('my_orders'.tr,
                                                style: robotoMedium),
                                          ))
                                        : const SizedBox(),
                                    Center(
                                      child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: Align(
                                          alignment: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? Alignment.centerLeft
                                              : Alignment.center,
                                          child: Container(
                                            width: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? 300
                                                : Dimensions.webMaxWidth,
                                            color: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? Colors.transparent
                                                : Theme.of(context).cardColor,
                                            child: TabBar(
                                              controller: _tabController,
                                              indicatorColor: Theme.of(context)
                                                  .primaryColor,
                                              indicatorWeight: 3,
                                              labelColor: Theme.of(context)
                                                  .primaryColor,
                                              unselectedLabelColor:
                                                  Theme.of(context)
                                                      .disabledColor,
                                              unselectedLabelStyle:
                                                  robotoRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                              labelStyle: robotoBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              tabs: [
                                                Tab(text: 'running'.tr),
                                                Tab(text: 'history'.tr),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )
                              : Column(children: [
                                  // Modern TabBar (Matching FavouriteScreen)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                      vertical: Dimensions.paddingSizeSmall,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withValues(alpha: 0.1),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TabBar(
                                        controller: _tabController,
                                        isScrollable:
                                            haveTaxiModule ? true : false,
                                        padding: EdgeInsets.zero,
                                        tabAlignment: haveTaxiModule
                                            ? TabAlignment.start
                                            : null,
                                        indicator: BoxDecoration(
                                          gradient: AppColors.mainGradient,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.green
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        dividerColor: Colors.transparent,
                                        labelColor: Colors.white,
                                        unselectedLabelColor:
                                            Theme.of(context).disabledColor,
                                        labelStyle: robotoBold.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                        unselectedLabelStyle:
                                            robotoBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                        tabs: [
                                          Tab(text: 'running'.tr),
                                          Tab(text: 'history'.tr),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          selectTypeIndex == 0
                              ? Expanded(
                                  child: TabBarView(
                                  controller: _tabController,
                                  children: const [
                                    OrderViewWidget(isRunning: true),
                                    OrderViewWidget(isRunning: false),
                                  ],
                                ))
                              : Expanded(
                                  child: TabBarView(
                                  controller: _tabController,
                                  children: const [
                                    TripOrderViewWidget(isRunning: true),
                                    TripOrderViewWidget(isRunning: false),
                                  ],
                                )),
                        ]),
                      )
                    : GuestTrackOrderInputViewWidget(
                        selectType: selectTypeIndex),
              ],
            );
          },
        ),
      ),
    );
  }
}
