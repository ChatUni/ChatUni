import 'package:flutter/material.dart';

enum InputStyle { outline, underline }

TextField input(
  void Function(String) onChanged, {
  String? error,
  Widget? prefixIcon,
  Widget? suffixIcon,
  void Function()? suffixAction,
  String? labelText,
  Widget? suffix,
  TextInputType? keyboardType,
  InputStyle style = InputStyle.outline,
  bool isDense = false,
}) =>
    TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: _inputStyles[style],
        filled: true,
        fillColor: Colors.white,
        isDense: isDense,
        hintText: labelText,
        errorText: error,
        prefixIcon: prefixIcon, // Icon(prefixIcon),
        suffixIcon: suffixIcon is Icon
            ? IconButton(
                color: Colors.green,
                icon: suffixIcon,
                onPressed: suffixAction,
              )
            : suffixIcon,
      ),
      keyboardType: keyboardType,
    );

var _inputStyles = {
  InputStyle.outline: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
    borderRadius: BorderRadius.circular(12),
  ),
  InputStyle.underline: const UnderlineInputBorder(),
};
