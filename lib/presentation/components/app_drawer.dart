// ignore_for_file: unnecessary_null_comparison

import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/utils/load_user_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:igmp/presentation/components/app_confirm_action.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  String nome = '';
  String email = '';
  String avatar = '';

  Future<void> loadUser() async {
    UserData userData = await loadUserData();
    nome = userData.name ?? '';
    email = userData.login ?? '';
    avatar = userData.avatar ?? '';
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadUser();
    Authentication authentication = Provider.of(context, listen: false);
    final menu = authentication.getMenusOption();
    return Drawer(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/avatar'),
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.background),
                      child: Image.network(
                        fit: BoxFit.cover,
                        avatar,
                        errorBuilder: (context, error, stackTrace) {
                          return FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.account_circle,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                accountName: Text(nome),
                accountEmail: Text(email),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: menu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(menu[index].icon),
                      title: Text(menu[index].title),
                      onTap: () async {
                        if (menu[index].url != null) {
                          final uri = Uri.parse(menu[index].url!);
                          if (!uri.hasEmptyPath) {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmActionWidget(
                                    message:
                                        'Pagina fora do ar ou dispositivo sem internet.',
                                    cancelButtonText: 'Ok',
                                  );
                                },
                              );
                            }
                          }
                        }
                        if (menu[index].url == '' || menu[index].url == null) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context)
                              .pushReplacementNamed(menu[index].route);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Versao: ${_packageInfo.version}',
                style: TextStyle(
                  color: AppColors.body,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
