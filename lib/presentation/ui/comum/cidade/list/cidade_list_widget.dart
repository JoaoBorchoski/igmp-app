import 'package:igmp/data/repositories/comum/cidade_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/comum/cidade.dart';
import 'package:provider/provider.dart';

class CidadeListWidget extends StatelessWidget {
  final Cidade cidade;

  const CidadeListWidget(
    this.cidade, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/cidades'),
      endToStart: () async {
        await Provider.of<CidadeRepository>(context, listen: false).delete(cidade).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': cidade.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/cidades-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': cidade.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/cidades-form', arguments: data);
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
            child: ListTile(title: Text((cidade.estadoUf ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((cidade.nomeCidade ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
