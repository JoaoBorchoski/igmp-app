import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/pedido_item_repository.dart';

var pedidoItemProvider = [
  ChangeNotifierProxyProvider<Authentication, PedidoItemRepository>(create: (_) => PedidoItemRepository(),
    update: (ctx, auth, previous) {
      return PedidoItemRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
