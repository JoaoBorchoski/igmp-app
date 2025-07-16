import 'package:igmp/data/repositories/configuracao/status_negociacao_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/configuracao/status_negociacao.dart';
import 'package:provider/provider.dart';

class StatusNegociacaoListWidget extends StatelessWidget {
  final StatusNegociacao statusNegociacao;

  const StatusNegociacaoListWidget(
    this.statusNegociacao, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/status-negociacoes'),
      endToStart: () async {
        await Provider.of<StatusNegociacaoRepository>(context, listen: false).delete(statusNegociacao).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': statusNegociacao.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/status-negociacoes-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': statusNegociacao.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/status-negociacoes-form', arguments: data);
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
            child: ListTile(title: Text((statusNegociacao.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((statusNegociacao.descricao ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
