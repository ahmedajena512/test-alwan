import 'package:sixam_mart/features/search/controllers/search_controller.dart'
    as search;
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/search/widgets/filter_widget.dart';
import 'package:sixam_mart/features/search/widgets/item_view_widget.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  final TabController? tabController;
  const SearchResultWidget(
      {super.key, required this.searchText, this.tabController});

  @override
  SearchResultWidgetState createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.tabController != null) {
      _tabController = widget.tabController;
    } else {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<search.SearchController>(builder: (searchController) {
        bool isNull = true;
        int length = 0;
        if (searchController.isStore) {
          isNull = searchController.searchStoreList == null;
          if (!isNull) {
            length = searchController.searchStoreList!.length;
          }
        } else {
          isNull = searchController.searchItemList == null;
          if (!isNull) {
            length = searchController.searchItemList!.length;
          }
        }
        return isNull ? const SizedBox() : const SizedBox();
      }),
      ResponsiveHelper.isDesktop(context)
          ? const SizedBox()
          : Center(
              child: Container(
              width: Dimensions.webMaxWidth,
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  gradient: AppColors.mainGradient,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).disabledColor,
                unselectedLabelStyle:
                    robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                labelStyle:
                    robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
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
            )),
      Expanded(
          child: NotificationListener(
        onNotification: (dynamic scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<search.SearchController>()
                .setStore(_tabController!.index == 1);
            Get.find<search.SearchController>()
                .searchData(widget.searchText, false);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: const [
            ItemViewWidget(isItem: false),
            ItemViewWidget(isItem: true),
          ],
        ),
      )),
    ]);
  }
}
