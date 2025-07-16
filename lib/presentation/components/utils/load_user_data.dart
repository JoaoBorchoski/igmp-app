import 'package:igmp/data/store.dart';

class UserData {
  String? name;
  String? login;
  String? avatar;

  UserData({
    this.name,
    this.login,
    this.avatar,
  });
}

Future<UserData> loadUserData() async {
  Map userData = await Store.getMap('userData');

  return UserData(
    name: userData['name'],
    login: userData['login'],
    avatar: userData['avatar'],
  );
}
