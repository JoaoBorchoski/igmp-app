import 'package:flutter/material.dart';
import 'package:igmp/presentation/components/app_drawer.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:upgrader/upgrader.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    Key? key,
    required this.title,
    required this.body,
    required this.showDrawer,
    this.route,
    this.args,
    this.actions,
  }) : super(key: key);

  final Widget title;
  final Widget body;
  final bool showDrawer;
  final String? route;
  final Map? args;
  final List<Widget>? actions;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final appcastConfig = AppcastConfiguration(supportedOS: ['android', 'ios']);
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(durationUntilAlertAgain: const Duration(microseconds: 1),
        canDismissDialog: false,
        showIgnore: false,
        showLater: false,
        languageCode: 'pt',
        appcastConfig: appcastConfig,
      ),
      child: Scaffold(
        appBar: AppBar(leading: !widget.showDrawer ? BackButton(color: AppColors.background) : null,
          title: widget.title,
          backgroundColor: AppColors.primary,
          actions: widget.actions,
        ),
        body: widget.body,
        drawer: widget.showDrawer ? AppDrawer() : null,
        floatingActionButton: widget.route == null
            ? null
            : FloatingActionButton(onPressed: () {
                  Navigator.of(context).pushReplacementNamed(widget.route!, arguments: widget.args);
                },
                backgroundColor: AppColors.secondDegrade,
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
