import 'package:flutter/material.dart';

TextField input(
  void Function(String) onChanged, {
  Widget? prefixIcon,
  Widget? suffixIcon,
  void Function()? suffixAction,
  String? labelText,
  Widget? suffix,
  TextInputType? keyboardType,
}) =>
    TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: labelText,
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
