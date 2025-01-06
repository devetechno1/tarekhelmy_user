import 'package:flutter/services.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Function iconPressed;
  final Color? filledColor;
  final Color? iconColor;
  final Function? onSubmit;
  final Function? onChanged;
  final double? radius;
  const SearchFieldWidget({
    super.key, required this.controller, required this.hint, required this.suffixIcon,
    required this.iconPressed, this.filledColor, this.onSubmit, this.onChanged, this.iconColor, this.radius, this.prefixIcon,
  });

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      autofocus: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[!@#$%^&*(),.?":{}|<>_+-/~`•√π÷×§∆£¢€¥°=©®™✓;]')),
      ],
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.radius ?? Dimensions.radiusSmall), borderSide: BorderSide.none),
        filled: true, fillColor: widget.filledColor ?? Theme.of(context).cardColor,
        isDense: true,
        suffixIcon: widget.suffixIcon != null ? IconButton(
          onPressed: widget.iconPressed as void Function()?,
          icon: Icon(widget.suffixIcon, color: widget.iconColor ?? Theme.of(context).textTheme.bodyLarge!.color),
        ) : null,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, size: 24, color: Theme.of(context).disabledColor) : null,
      ),
      onSubmitted: widget.onSubmit as void Function(String)?,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
