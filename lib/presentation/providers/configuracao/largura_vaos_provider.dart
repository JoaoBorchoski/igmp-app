import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/largura_vaos_repository.dart';

var larguraVaosProvider = [
  ChangeNotifierProxyProvider<Authentication, LarguraVaosRepository>(create: (_) => LarguraVaosRepository(),
    update: (ctx, auth, previous) {
      return LarguraVaosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
