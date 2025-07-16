import 'dart:async';
import 'dart:convert';

import 'package:igmp/data/store.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/shared/config/app_menu_icons.dart';
import 'package:igmp/shared/config/app_menu_options.dart';
import 'package:igmp/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  String? _token;
  String? _login;
  // ignore: unused_field
  String? _name;
  String? _avatar;
  // ignore: unused_field
  bool _isAdmin = false;
  String _mustChangePassword = '';
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  List<dynamic>? _permissions;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get loginField {
    return isAuth ? _login : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<String> _authenticate(
    String login,
    String password,
    String urlFragment,
  ) async {
    const url = '${AppConstants.apiUrl}/sessions';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': login,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    String defaultMessage = 'Fale com o Administrador.';

    if (response.statusCode != 200) {
      throw AuthException(body['message']);
    } else {
      if (body['user']['isBlocked'] != null) {
        throw AuthException(
            'Usuário bloqueado!\n${body['user']['blockReasonId'] != null ? body['user']['blockReasonId']['description'] : defaultMessage}');
      }
      if (body['user']['isDisabled'] != null) {
        throw AuthException('Usuário desabilitado!\n$defaultMessage');
      }
      _token = body['token'];
      _name = body['user']['name'];
      _login = body['user']['login'];
      _isAdmin = body['user']['isAdmin'] ?? false;
      _userId = body['user']['login'];
      _avatar = body['user']['avatar'] ?? '';
      _mustChangePassword = body['user']['mustChangePassword'] ?? '';

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse('28800'),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'name': _name,
        'login': _login,
        'userId': _userId,
        'avatar': _avatar,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
    return _mustChangePassword;
  }

  Future<void> updateAvatar(String avatar) async {
    final data = await Store.getMap('userData');
    data['avatar'] = avatar;
    await Store.remove('userData');
    await Store.saveMap('userData', data);
  }

  Future<void> getMenu() async {
    const url = '${AppConstants.apiUrl}/users-security/get-menu';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw AuthException(body['message']);
    } else {
      _permissions = body['data']['menus'];

      Store.saveMap('permissons', {'permissons': _permissions});

      notifyListeners();
    }
  }

  bool isPermitted(String route, String permission) {
    Map<String, dynamic> permissionsPage = {};

    _permissions?.forEach((e) {
      final List<dynamic> subMenuOptions = e['subMenuOptions'];

      final int indexOfPermissionsPage =
          subMenuOptions.indexWhere((element) => element['route'] == route);

      if (indexOfPermissionsPage != -1) {
        permissionsPage = subMenuOptions.elementAt(indexOfPermissionsPage);
      }
    });

    final bool isPermitted = (permissionsPage['permitAll'] ?? false) ||
        (permissionsPage[permission] ?? false);

    return isPermitted;
  }

  DismissDirection permitUpdateDelete(String route) {
    Map<String, dynamic> permissionsPage = {};

    _permissions?.forEach((e) {
      final List<dynamic> subMenuOptions = e['subMenuOptions'];

      final int indexOfPermissionsPage =
          subMenuOptions.indexWhere((element) => element['route'] == route);

      if (indexOfPermissionsPage != -1) {
        permissionsPage = subMenuOptions.elementAt(indexOfPermissionsPage);
      }
    });

    final bool isPermitted =
        permissionsPage['permitUpdate'] && permissionsPage['permitDelete'];

    if (permissionsPage['permitAll'] || isPermitted) {
      return DismissDirection.horizontal;
    }

    if (permissionsPage['permitUpdate']) {
      return DismissDirection.startToEnd;
    }

    if (permissionsPage['permitDelete']) {
      return DismissDirection.endToStart;
    }

    return DismissDirection.none;
  }

  List<MenuData> getMenusOption() {
    List<MenuData> menu = [MenuData(Icons.home, 'Home', '/home', false, '')];

    _permissions?.forEach((menuOption) {
      final List<dynamic> subMenuOptions = menuOption['subMenuOptions'];

      for (var subMenuOption in subMenuOptions) {
        if (subMenuOption['route'] != '/pacotes') {
          continue;
        }

        int indexIcon = icons
            .indexWhere((element) => element.iconName == subMenuOption['icon']);

        menu.add(MenuData(
            indexIcon != -1 ? icons[indexIcon].icon : icons[0].icon,
            subMenuOption['text'],
            subMenuOption['route'],
            true,
            ''));
      }
    });
    menu.add(
      MenuData(Icons.exit_to_app, 'Sair', '/', false, ''),
    );

    return menu;
  }

  // Future<void> signup(String login, String password) async {
  //   return _authenticate(login, password, 'signUp');
  // }

  Future<String> login(String login, String password) async {
    final response = await _authenticate(login, password, 'signInWithPassword');
    await getMenu();
    return response;
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _login = userData['login'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _login = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
