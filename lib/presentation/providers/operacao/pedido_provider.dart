import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/data/repositories/operacao/pedido_repository.dart';

var pedidoProvider = [
  ChangeNotifierProxyProvider<Authentication, PedidoRepository>(create: (_) => PedidoRepository(),
    update: (ctx, auth, previous) {
      return PedidoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
