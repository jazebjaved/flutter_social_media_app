import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final Icon iconType;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      required this.textInputType,
      required this.hintText,
      this.isPass = false,
      required this.iconType});

  @override
  Widget build(BuildContext context) {
    final InputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPass,
      decoration: InputDecoration(
        icon: Padding(
          padding: EdgeInsets.all(1),
          child: iconType,
        ),
        hintText: hintText,
        border: InputBorder,
        focusedBorder: InputBorder,
      ),
    );
  }
}
