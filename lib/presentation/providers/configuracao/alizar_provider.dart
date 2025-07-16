import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/alizar_repository.dart';

var alizarProvider = [
  ChangeNotifierProxyProvider<Authentication, AlizarRepository>(create: (_) => AlizarRepository(),
    update: (ctx, auth, previous) {
      return AlizarRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
