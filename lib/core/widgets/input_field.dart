import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../values/colors.dart';

class CommonInputField {
  static inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    List<TextInputFormatter>? formatters,
    Widget? suffixIcon,
    bool? isObSecure,
    FocusNode? focusNode,
    bool? autoFocus,
    Function()? onTap,
    int? maxLine,
  }) =>
      Container(
        height: maxLine == null ? 50 : 50.0 * 2,
        padding: EdgeInsets.only(
          left: 24,
          right: 8,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppColors.onSurfaceColor.withOpacity(.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 3),
              )
            ]),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: inputType ?? TextInputType.name,
                obscureText: isObSecure ?? false,
                autofocus: autoFocus ?? false,
                inputFormatters: formatters ?? [],
                onTap: onTap,
                maxLines: maxLine ?? 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceColor.withOpacity(.4),
                  ),
                  // contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
            ),
            suffixIcon ?? Container(),
          ],
        ),
      );

  static inputFieldForLogin({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    Widget? suffixIcon,
    bool? isObSecure,
    FocusNode? focusNode,
    bool? autoFocus,
    Function()? onTap,
    int? maxLine,
  }) =>
      Container(
        height: maxLine == null ? 50 : 50.0 * 2,
        padding: EdgeInsets.only(
          left: 24,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.onSurfaceColor.withOpacity(.1),
            width: 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade300,
          //     blurRadius: 2,
          //     spreadRadius: 1,
          //     offset: Offset(0, 3),
          //   )
          // ]
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: inputType ?? TextInputType.name,
                obscureText: isObSecure ?? false,
                autofocus: autoFocus ?? false,
                onTap: onTap,
                maxLines: maxLine ?? 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceColor.withOpacity(.4),
                  ),
                  // contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
            ),
            suffixIcon ?? Container(),
          ],
        ),
      );
}
