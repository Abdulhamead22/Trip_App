// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/core/constants/app_colors.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData? prefixIcon;
//   final Widget? suffixIcon;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final ValueChanged<String>? onChange;
//   final String? errorText;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.readOnly = false,
//     this.onTap,
//     this.onChange,
//     this.errorText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       readOnly: readOnly,
//       onTap: onTap,
//       onChanged: onChange,
//       style: const TextStyle(
//         fontSize: 15,
//         color: AppColors.darkText,
//       ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(
//           color: AppColors.mutedText,
//           fontSize: 15,
//         ),
//         errorText: errorText,
//         filled: true,
//         fillColor: Colors.white,
//         prefixIcon: prefixIcon != null
//             ? Icon(
//                 prefixIcon,
//                 color: AppColors.mutedText,
//                 size: 20,
//               )
//             : null,
//         suffixIcon: suffixIcon,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: AppColors.border,
//             width: 1,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: AppColors.green, width: 1.5),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final double fontSize;
  final FontWeight? fontWeight;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.suffixText,
      this.readOnly = false,
      this.onTap,
      this.onChange,
      this.errorText,
      this.keyboardType,
      this.textAlign = TextAlign.start,
      this.fillColor,
      this.contentPadding,
      this.borderRadius = 14,
      this.fontSize = 15,
      this.fontWeight,
      this.inputFormatters,
      this.obscureText = false,
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      onChanged: onChange,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.darkText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixText: suffixText,
        hintStyle: TextStyle(
          color: AppColors.mutedText,
          fontSize: fontSize,
        ),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: AppColors.mutedText,
                size: 20,
              )
            : null,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: AppColors.green,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
