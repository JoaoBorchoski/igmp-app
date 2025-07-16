import 'package:igmp/data/repositories/operacao/obra_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/operacao/obra.dart';
import 'package:provider/provider.dart';

class ObraListWidget extends StatelessWidget {
  final Obra obra;

  const ObraListWidget(
    this.obra, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/obras'),
      endToStart: () async {
        await Provider.of<ObraRepository>(context, listen: false).delete(obra).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': obra.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/obras-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': obra.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/obras-form', arguments: data);
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
            child: ListTile(title: Text((obra.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((obra.cnpj ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
