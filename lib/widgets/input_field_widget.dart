import 'package:flutter/material.dart';

class TextFieldShow extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldShow(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.validator,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator != null ? validator : null,
          controller: controller != null ? controller : null,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 13, 5),
              //prefixIcon: fieldIC,
              suffix: fieldIC,
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}