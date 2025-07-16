import 'package:flutter/material.dart';

// ignore: no_logic_in_create_state
class ConfirmActionWidget extends StatelessWidget {
  final String? title;
  final String message;
  final String? confirmButtonText;
  final String cancelButtonText;

  const ConfirmActionWidget({
    Key? key,
    this.confirmButtonText,
    this.title,
    required this.message,
    required this.cancelButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: title == null ? null : Text(title!),
      content: Text(message, textAlign: TextAlign.justify),
      actions: [
        TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(cancelButtonText),
        ),
        confirmButtonText == null
            ? SizedBox.shrink()
            : ElevatedButton(onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(confirmButtonText!),
              )
      ],
    );
  }
}
