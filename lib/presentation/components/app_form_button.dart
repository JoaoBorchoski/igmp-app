import 'package:igmp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppFormButton extends StatelessWidget {
  const AppFormButton({
    super.key,
    required this.submit,
    required this.label,
  });

  final Function() submit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
          foregroundColor: MaterialStateProperty.all<Color>(AppColors.background),
        ),
        onPressed: submit,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
