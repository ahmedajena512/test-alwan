import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/images.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function? onTap;
  final bool fromSheet;
  final bool showRemoveIcon;
  final Color? color;
  const QuantityButton(
      {super.key,
      required this.isIncrement,
      required this.onTap,
      this.fromSheet = false,
      this.showRemoveIcon = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: fromSheet ? 32 : 28,
        width: fromSheet ? 32 : 28,
        margin:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: showRemoveIcon
              ? null
              : (isIncrement ? AppColors.mainGradient : null),
          color: showRemoveIcon
              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
              : isIncrement
                  ? null
                  : Theme.of(context).disabledColor.withValues(alpha: 0.2),
          boxShadow: isIncrement && !showRemoveIcon
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: showRemoveIcon
            ? Image.asset(Images.delete,
                height: 15, color: Theme.of(context).colorScheme.error)
            : Icon(
                isIncrement ? Icons.add : Icons.remove,
                size: fromSheet ? 20 : 18,
                color: showRemoveIcon
                    ? Theme.of(context).colorScheme.error
                    : isIncrement
                        ? Colors.white
                        : Theme.of(context).disabledColor,
              ),
      ),
    );
  }
}
