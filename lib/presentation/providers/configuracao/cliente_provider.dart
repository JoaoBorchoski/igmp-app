import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/cliente_repository.dart';

var clienteProvider = [
  ChangeNotifierProxyProvider<Authentication, ClienteRepository>(create: (_) => ClienteRepository(),
    update: (ctx, auth, previous) {
      return ClienteRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
