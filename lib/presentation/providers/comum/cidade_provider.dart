import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/comum/cidade_repository.dart';

var cidadeProvider = [
  ChangeNotifierProxyProvider<Authentication, CidadeRepository>(create: (_) => CidadeRepository(),
    update: (ctx, auth, previous) {
      return CidadeRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
