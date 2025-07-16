import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/negociacao_repository.dart';

var negociacaoProvider = [
  ChangeNotifierProxyProvider<Authentication, NegociacaoRepository>(create: (_) => NegociacaoRepository(),
    update: (ctx, auth, previous) {
      return NegociacaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
