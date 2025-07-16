import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/comum/cep_repository.dart';

var cepProvider = [
  ChangeNotifierProxyProvider<Authentication, CepRepository>(create: (_) => CepRepository(),
    update: (ctx, auth, previous) {
      return CepRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
