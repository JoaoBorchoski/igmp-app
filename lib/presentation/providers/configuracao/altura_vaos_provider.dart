import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/altura_vaos_repository.dart';

var alturaVaosProvider = [
  ChangeNotifierProxyProvider<Authentication, AlturaVaosRepository>(create: (_) => AlturaVaosRepository(),
    update: (ctx, auth, previous) {
      return AlturaVaosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
