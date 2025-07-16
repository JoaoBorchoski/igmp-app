class User {
  String? id;
  String? userGroupId;
  String? nome;
  String? login;
  String? avatar;
  bool? isAdmin;
  bool? isSuperUser;
  bool? isBlocked;
  bool? blockReasonId;
  bool? changePassword;
  bool? twoFactor;
  bool? isDisabled;

  User({
    this.id,
    this.userGroupId,
    this.nome,
    this.login,
    this.isAdmin,
    this.isSuperUser,
    this.isBlocked,
    this.blockReasonId,
    this.changePassword,
    this.twoFactor,
    this.avatar,
    this.isDisabled,
  });

  User.vazio({
    this.id = '',
    this.userGroupId = '',
    this.nome = '',
    this.login = '',
    this.isAdmin = false,
    this.isSuperUser = false,
    this.isBlocked = false,
    this.blockReasonId = false,
    this.changePassword = false,
    this.twoFactor = false,
    this.avatar = '',
    this.isDisabled = false,
  });
}
