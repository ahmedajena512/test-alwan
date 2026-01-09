import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_scale_button.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String? selectedIcon;
  final String? unSelectedIcon;
  final String title;
  final Function? onTap;
  final bool isSelected;
  final IconData? selectedIconData;
  final IconData? unSelectedIconData;

  const BottomNavItemWidget(
      {super.key,
      this.onTap,
      this.isSelected = false,
      required this.title,
      this.selectedIcon,
      this.unSelectedIcon,
      this.selectedIconData,
      this.unSelectedIconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap as void Function()?,
        behavior: HitTestBehavior.opaque,
        child: CustomScaleButton(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            isSelected
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return AppColors.mainGradient.createShader(bounds);
                    },
                    child: selectedIconData != null
                        ? Icon(selectedIconData, size: 25, color: Colors.white)
                        : Image.asset(
                            selectedIcon!,
                            height: 25,
                            width: 25,
                            color: Colors.white,
                          ),
                  )
                : unSelectedIconData != null
                    ? Icon(unSelectedIconData,
                        size: 25,
                        color: Theme.of(context).textTheme.bodyMedium!.color!)
                    : Image.asset(
                        unSelectedIcon!,
                        height: 25,
                        width: 25,
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
            SizedBox(
                height: isSelected
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall),
            isSelected
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return AppColors.mainGradient.createShader(bounds);
                    },
                    child: Text(
                      title,
                      style: robotoRegular.copyWith(
                          color: Colors.white, fontSize: 12),
                    ),
                  )
                : Text(
                    title,
                    style: robotoRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                        fontSize: 12),
                  ),
          ]),
        ),
      ),
    );
  }
}
