import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/status_negociacao_repository.dart';

var statusNegociacaoProvider = [
  ChangeNotifierProxyProvider<Authentication, StatusNegociacaoRepository>(create: (_) => StatusNegociacaoRepository(),
    update: (ctx, auth, previous) {
      return StatusNegociacaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
