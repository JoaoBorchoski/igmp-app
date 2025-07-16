import 'package:igmp/data/repositories/comum/pais_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/comum/pais.dart';
import 'package:provider/provider.dart';

class PaisListWidget extends StatelessWidget {
  final Pais pais;

  const PaisListWidget(
    this.pais, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/paises'),
      endToStart: () async {
        await Provider.of<PaisRepository>(context, listen: false).delete(pais).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': pais.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/paises-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': pais.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/paises-form', arguments: data);
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
            child: ListTile(title: Text((pais.codigoPais ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((pais.nomePais ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
