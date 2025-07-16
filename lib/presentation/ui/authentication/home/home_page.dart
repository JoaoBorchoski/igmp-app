import 'package:flutter/material.dart';
import 'package:igmp/presentation/components/app_main_menu.dart';
import 'package:igmp/presentation/components/app_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
        bool retorno = true;

        Navigator.of(context).pushReplacementNamed('/');

        return retorno;
      },
      child: AppScaffold(title: const Text('igmp'),
        showDrawer: true,
        body: AppMainMenu(),
      ),
    );
  }
}
