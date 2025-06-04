import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.backgroundColor = Colors.black,
    this.icon,
  });

  final void Function() onTap;
  final String text;
  final bool loading;
  final Color backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: whiteColor,
        fixedSize: Size(Get.width, 60),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: loading
          ? Center(child: CircularProgressIndicator(color: whiteColor))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  // Ensure text doesn't overflow
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (icon != null) const SizedBox(width: 10),
                if (icon != null) Icon(icon, size: 20),
              ],
            ),
    );
  }
}
