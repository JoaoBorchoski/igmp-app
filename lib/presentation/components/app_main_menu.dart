import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AppMainMenu extends StatefulWidget {
  const AppMainMenu({super.key});

  @override
  State<AppMainMenu> createState() {
    return AppMainMenuState();
  }
}

class MainMenuBody extends StatelessWidget {
  const MainMenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Provider.of(context, listen: false);
    final menu = authentication.getMenusOption();
    return Scrollbar(
      thickness: 3,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: menu.length - 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return (Card(
                    color: AppColors.cardColor,
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(menu[index + 1].route);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            menu[index + 1].icon,
                            size: 70,
                            color: AppColors.cardTextColor,
                          ),
                          SizedBox(height: 10),
                          Text(
                            menu[index + 1].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: AppColors.background),
                          ),
                        ],
                      ),
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppMainMenuState extends State<AppMainMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBar get buildBottomNavigationBar {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuracao',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primary,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuBody(),
    );
  }
}
