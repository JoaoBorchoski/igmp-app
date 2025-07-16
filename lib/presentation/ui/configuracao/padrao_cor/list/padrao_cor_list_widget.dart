import 'package:igmp/data/repositories/configuracao/padrao_cor_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/configuracao/padrao_cor.dart';
import 'package:provider/provider.dart';

class PadraoCorListWidget extends StatelessWidget {
  final PadraoCor padraoCor;

  const PadraoCorListWidget(
    this.padraoCor, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/padroes-cores'),
      endToStart: () async {
        await Provider.of<PadraoCorRepository>(context, listen: false).delete(padraoCor).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': padraoCor.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/padroes-cores-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': padraoCor.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/padroes-cores-form', arguments: data);
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
            child: ListTile(title: Text((padraoCor.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((padraoCor.descricao ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
