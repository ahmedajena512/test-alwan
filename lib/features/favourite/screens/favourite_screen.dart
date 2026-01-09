import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/favourite/widgets/clear_all_bottom_sheet.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/features/favourite/widgets/fav_item_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<FavouriteController>().getFavouriteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: AuthHelper.isLoggedIn()
          ? SafeArea(
              child: Column(children: [
                WebScreenTitleWidget(title: 'favourite'.tr),

                // Custom Header Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'favourite'.tr,
                        style: robotoBold.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GetBuilder<FavouriteController>(
                        builder: (favouriteController) {
                          bool hasItems =
                              (favouriteController.wishItemList != null &&
                                      favouriteController
                                          .wishItemList!.isNotEmpty) ||
                                  (favouriteController.wishStoreList != null &&
                                      favouriteController
                                          .wishStoreList!.isNotEmpty);

                          if (!hasItems) return const SizedBox();

                          return InkWell(
                            onTap: () {
                              if (ResponsiveHelper.isDesktop(context)) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const Dialog(
                                    child: ClearAllBottomSheet(),
                                  ),
                                );
                              } else {
                                Get.bottomSheet(
                                  const ClearAllBottomSheet(),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              }
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppColors.mainGradient.createShader(bounds),
                              child: Text(
                                'clear_all'.tr,
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // TabBar Section
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
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppColors.mainGradient,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      labelStyle: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      unselectedLabelStyle: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      tabs: [
                        Tab(text: 'item'.tr),
                        Tab(
                            text: Get.find<SplashController>()
                                    .configModel!
                                    .moduleConfig!
                                    .module!
                                    .showRestaurantText!
                                ? 'restaurants'.tr
                                : 'stores'.tr),
                      ],
                    ),
                  ),
                ),

                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: const [
                    FavItemViewWidget(isStore: false),
                    FavItemViewWidget(isStore: true),
                  ],
                )),
              ]),
            )
          : NotLoggedInScreen(callBack: (value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
