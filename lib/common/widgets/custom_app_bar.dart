import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/veg_filter_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final bool showCart;
  final Function(String value)? onVegFilterTap;
  final String? type;
  final String? leadingIcon;
  final Widget? menuWidget;
  final Color? bgColor; // Added bgColor

  const CustomAppBar({
    super.key,
    required this.title,
    this.backButton = true,
    this.onBackPressed,
    this.showCart = false,
    this.leadingIcon,
    this.onVegFilterTap,
    this.type,
    this.menuWidget,
    this.bgColor, // Added bgColor
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : AppBar(
            title: Text(
              title,
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: bgColor == null
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).cardColor,
              ),
            ),
            centerTitle: true,
            leading: backButton
                ? IconButton(
                    icon: leadingIcon != null
                        ? Image.asset(leadingIcon!, height: 22, width: 22)
                        : const Icon(Icons.arrow_back_ios),
                    color: bgColor == null
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : Theme.of(context).cardColor,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.pop(context),
                  )
                : const SizedBox(),
            backgroundColor: bgColor ?? Theme.of(context).cardColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            actions: showCart || onVegFilterTap != null
                ? [
                    showCart
                        ? IconButton(
                            onPressed: () =>
                                Get.toNamed(RouteHelper.getCartRoute()),
                            icon: CartWidget(
                              color: bgColor == null
                                  ? Theme.of(context).textTheme.bodyLarge!.color
                                  : Theme.of(context).cardColor,
                              size: 25,
                            ),
                          )
                        : const SizedBox(),
                    onVegFilterTap != null
                        ? VegFilterWidget(
                            type: type,
                            onSelected: onVegFilterTap,
                            fromAppBar: true,
                            iconColor: bgColor == null
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                          )
                        : const SizedBox(),
                  ]
                : [menuWidget ?? const SizedBox()],
          );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 100 : 50);
}
