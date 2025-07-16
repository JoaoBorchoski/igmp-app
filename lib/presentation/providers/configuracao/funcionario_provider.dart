import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/configuracao/funcionario_repository.dart';

var funcionarioProvider = [
  ChangeNotifierProxyProvider<Authentication, FuncionarioRepository>(create: (_) => FuncionarioRepository(),
    update: (ctx, auth, previous) {
      return FuncionarioRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
