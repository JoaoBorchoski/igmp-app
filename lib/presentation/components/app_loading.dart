import 'package:igmp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: no_logic_in_create_state
class LoadWidget extends StatelessWidget {
  const LoadWidget({super.key, this.opacity});

  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(opacity ?? 1),
            Color.fromARGB(255, 2, 116, 153).withOpacity(opacity ?? 1),
          ],
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.background,),
      ),
    );
  }
}
