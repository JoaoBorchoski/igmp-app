import 'package:igmp/data/repositories/configuracao/largura_vaos_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/configuracao/largura_vaos.dart';
import 'package:provider/provider.dart';

class LarguraVaosListWidget extends StatelessWidget {
  final LarguraVaos larguraVaos;

  const LarguraVaosListWidget(
    this.larguraVaos, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/larguras-vaos'),
      endToStart: () async {
        await Provider.of<LarguraVaosRepository>(context, listen: false).delete(larguraVaos).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': larguraVaos.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/larguras-vaos-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': larguraVaos.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/larguras-vaos-form', arguments: data);
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
            child: ListTile(title: Text((larguraVaos.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((larguraVaos.descricao ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
