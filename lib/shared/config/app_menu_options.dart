import 'package:flutter/material.dart';

class MenuData {
  MenuData(this.icon, this.title, this.route, this.showOnMainMenu, this.url);
  final IconData icon;
  final String title;
  final String route;
  final bool showOnMainMenu;
  final String url;
}

final List<MenuData> menu = [
  MenuData(Icons.home, 'Home', '/home', false, ''),
  MenuData(Icons.question_mark, 'Estados', '/estados', true, ''),
  MenuData(Icons.question_mark, 'Cidades', '/cidades', true, ''),
  MenuData(Icons.question_mark, 'Clientes', '/clientes', true, ''),
  MenuData(Icons.exit_to_app, 'Sair', '/', false,''),
];
