import 'package:igmp/data/repositories/operacao/pedido_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/operacao/pedido.dart';
import 'package:provider/provider.dart';

class PedidoListWidget extends StatelessWidget {
  final Pedido pedido;

  const PedidoListWidget(
    this.pedido, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/pedidos'),
      endToStart: () async {
        await Provider.of<PedidoRepository>(context, listen: false).delete(pedido).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': pedido.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/pedidos-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': pedido.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/pedidos-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.cardColor,
            elevation: 5,
            child: ListTile(title: Text((pedido.sequencial ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((pedido.cliente ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
