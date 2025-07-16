import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/pacote_repository.dart';

var pacoteProvider = [
  ChangeNotifierProxyProvider<Authentication, PacoteRepository>(create: (_) => PacoteRepository(),
    update: (ctx, auth, previous) {
      return PacoteRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
