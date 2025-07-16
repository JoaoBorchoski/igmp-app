import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/tipo_enchimento_repository.dart';

var tipoEnchimentoProvider = [
  ChangeNotifierProxyProvider<Authentication, TipoEnchimentoRepository>(create: (_) => TipoEnchimentoRepository(),
    update: (ctx, auth, previous) {
      return TipoEnchimentoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
