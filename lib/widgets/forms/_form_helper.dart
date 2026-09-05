import 'package:flutter/material.dart';

Widget buildFormWidget({
  Key? key,
  GlobalKey<FormState>? formKey,
  AutovalidateMode? autovalidateMode,
  required Widget child,
}) =>
    Form(
      key: key,
      autovalidateMode: autovalidateMode,
      child: child,
    );
