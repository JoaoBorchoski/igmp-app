import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/fechadura_repository.dart';

var fechaduraProvider = [
  ChangeNotifierProxyProvider<Authentication, FechaduraRepository>(create: (_) => FechaduraRepository(),
    update: (ctx, auth, previous) {
      return FechaduraRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
