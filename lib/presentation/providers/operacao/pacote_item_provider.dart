import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/pacote_item_repository.dart';

var pacoteItemProvider = [
  ChangeNotifierProxyProvider<Authentication, PacoteItemRepository>(create: (_) => PacoteItemRepository(),
    update: (ctx, auth, previous) {
      return PacoteItemRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
