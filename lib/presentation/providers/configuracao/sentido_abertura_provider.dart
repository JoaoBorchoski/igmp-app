import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/sentido_abertura_repository.dart';

var sentidoAberturaProvider = [
  ChangeNotifierProxyProvider<Authentication, SentidoAberturaRepository>(create: (_) => SentidoAberturaRepository(),
    update: (ctx, auth, previous) {
      return SentidoAberturaRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
