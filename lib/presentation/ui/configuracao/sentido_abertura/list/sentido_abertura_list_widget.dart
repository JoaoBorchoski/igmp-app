import 'package:igmp/data/repositories/configuracao/sentido_abertura_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/configuracao/sentido_abertura.dart';
import 'package:provider/provider.dart';

class SentidoAberturaListWidget extends StatelessWidget {
  final SentidoAbertura sentidoAbertura;

  const SentidoAberturaListWidget(
    this.sentidoAbertura, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/sentidos-abertura'),
      endToStart: () async {
        await Provider.of<SentidoAberturaRepository>(context, listen: false).delete(sentidoAbertura).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': sentidoAbertura.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/sentidos-abertura-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': sentidoAbertura.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/sentidos-abertura-form', arguments: data);
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
            child: ListTile(title: Text((sentidoAbertura.nome ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((sentidoAbertura.descricao ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
