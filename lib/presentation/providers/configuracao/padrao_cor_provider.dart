import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/padrao_cor_repository.dart';

var padraoCorProvider = [
  ChangeNotifierProxyProvider<Authentication, PadraoCorRepository>(create: (_) => PadraoCorRepository(),
    update: (ctx, auth, previous) {
      return PadraoCorRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
