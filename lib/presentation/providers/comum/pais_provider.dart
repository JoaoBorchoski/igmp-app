import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/comum/pais_repository.dart';

var paisProvider = [
  ChangeNotifierProxyProvider<Authentication, PaisRepository>(create: (_) => PaisRepository(),
    update: (ctx, auth, previous) {
      return PaisRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
