import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/styles.dart';

class CustomToast extends StatelessWidget {
  final String text;
  final bool isError;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;

  const CustomToast({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isError
            ? const LinearGradient(
                colors: [Color(0xFFef4444), Color(0xFFb91c1c)],
              )
            : AppColors.mainGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Flexible(
            child: Text(text,
                style: robotoRegular.copyWith(color: textColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
