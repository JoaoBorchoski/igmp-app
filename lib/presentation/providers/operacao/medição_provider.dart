import 'package:igmp/data/repositories/operacao/medi%C3%A7%C3%A3o_repository.dart';
import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';

var medicaoProvider = [
  ChangeNotifierProxyProvider<Authentication, MedicaoRepository>(
    create: (_) => MedicaoRepository(),
    update: (ctx, auth, previous) {
      return MedicaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
