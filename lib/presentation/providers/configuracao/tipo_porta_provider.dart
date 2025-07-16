import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/tipo_porta_repository.dart';

var tipoPortaProvider = [
  ChangeNotifierProxyProvider<Authentication, TipoPortaRepository>(create: (_) => TipoPortaRepository(),
    update: (ctx, auth, previous) {
      return TipoPortaRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
