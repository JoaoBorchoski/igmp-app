import 'package:igmp/data/repositories/common/user_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:provider/provider.dart';

var userProvider = [
  ChangeNotifierProxyProvider<Authentication, UserRepository>(create: (_) => UserRepository(),
    update: (ctx, auth, previous) {
      return UserRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
