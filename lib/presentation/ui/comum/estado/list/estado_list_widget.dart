import 'package:igmp/data/repositories/comum/estado_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/comum/estado.dart';
import 'package:provider/provider.dart';

class EstadoListWidget extends StatelessWidget {
  final Estado estado;

  const EstadoListWidget(
    this.estado, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/estados'),
      endToStart: () async {
        await Provider.of<EstadoRepository>(context, listen: false).delete(estado).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': estado.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/estados-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': estado.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/estados-form', arguments: data);
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
            child: ListTile(title: Text((estado.uf ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((estado.nomeEstado ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
