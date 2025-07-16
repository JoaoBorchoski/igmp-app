import 'package:igmp/data/repositories/comum/cep_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/comum/cep.dart';
import 'package:provider/provider.dart';

class CepListWidget extends StatelessWidget {
  final Cep cep;

  const CepListWidget(
    this.cep, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/ceps'),
      endToStart: () async {
        await Provider.of<CepRepository>(context, listen: false).delete(cep).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': cep.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/ceps-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': cep.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/ceps-form', arguments: data);
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
            child: ListTile(title: Text((cep.codigoCep ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((cep.logradouro ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
