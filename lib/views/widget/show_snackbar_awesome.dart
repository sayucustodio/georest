import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSnackBarAwesome(BuildContext context, String title, String message, ContentType contenttype){

  final snackBar = SnackBar(
    duration: const Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message:message,
      contentType: contenttype,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}