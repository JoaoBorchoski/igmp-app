import 'package:igmp/data/repositories/operacao/pacote_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';
import 'package:provider/provider.dart';

class PacoteListWidget extends StatelessWidget {
  final Pacote pacote;

  const PacoteListWidget(
    this.pacote, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/pacotes'),
      endToStart: () async {
        // await Provider.of<PacoteRepository>(context, listen: false).delete(pacote).then((message) {
        //   return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
        //     duration: Duration(seconds: AppConstants.snackBarDuration),
        //   ));
        // });
      },
      startToEnd: () {
        // Map data = {'id': pacote.id, 'view': false};
        // Navigator.of(context).pushReplacementNamed('/pacotes-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': pacote.id, 'view': true};
        Navigator.of(context)
            .pushReplacementNamed('/pacotes-form', arguments: data);
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
            child: ListTile(
              title: Text('Pacote: ${(pacote.sequencial ?? '').toString()}',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${(pacote.descricao ?? '').toString()}',
                      style: TextStyle(
                        color: AppColors.cardTextColor,
                      )),
                  if (pacote.pedidoSequencial != null &&
                      pacote.pedidoSequencial!.isNotEmpty)
                    Text(
                      'Pedido: ${pacote.pedidoSequencial}',
                      style: TextStyle(
                        color: AppColors.cardTextColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
