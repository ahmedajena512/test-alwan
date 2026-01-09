import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/custom_scale_button.dart';

class CustomInkWell extends StatelessWidget {
  final double? radius;
  final Widget child;
  final Function? onTap;
  final Color? highlightColor;
  final EdgeInsetsGeometry? padding;
  const CustomInkWell(
      {super.key,
      this.radius,
      required this.child,
      required this.onTap,
      this.highlightColor,
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return CustomScaleButton(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}
