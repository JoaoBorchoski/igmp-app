import 'package:igmp/data/repositories/configuracao/altura_vaos_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/configuracao/altura_vaos.dart';
import 'package:provider/provider.dart';

class AlturaVaosListWidget extends StatelessWidget {
  final AlturaVaos alturaVaos;

  const AlturaVaosListWidget(
    this.alturaVaos, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/alturas-vaos'),
      endToStart: () async {
        await Provider.of<AlturaVaosRepository>(context, listen: false).delete(alturaVaos).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': alturaVaos.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/alturas-vaos-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': alturaVaos.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/alturas-vaos-form', arguments: data);
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
            child: ListTile(title: Text((alturaVaos.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((alturaVaos.descricao ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
