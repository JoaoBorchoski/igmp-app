import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/obra_repository.dart';

var obraProvider = [
  ChangeNotifierProxyProvider<Authentication, ObraRepository>(create: (_) => ObraRepository(),
    update: (ctx, auth, previous) {
      return ObraRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
