import 'package:igmp/data/repositories/operacao/pacote_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/operacao/espelho_carga.dart';
import 'package:provider/provider.dart';

class EspelhoCargaListWidget extends StatelessWidget {
  final EspelhoCarga espelhoCarga;

  const EspelhoCargaListWidget(
    this.espelhoCarga, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/espelhos-carga'),
      endToStart: () async {
        // await Provider.of<PacoteRepository>(context, listen: false).delete(espelhoCarga).then((message) {
        //   return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
        //     duration: Duration(seconds: AppConstants.snackBarDuration),
        //   ));
        // });
      },
      startToEnd: () {
        // Map data = {'id': espelhoCarga.id, 'view': false};
        // Navigator.of(context).pushReplacementNamed('/espelhos-carga-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': espelhoCarga.id, 'view': true};
        Navigator.of(context)
            .pushReplacementNamed('/pacotes-form', arguments: data);
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
            child: ListTile(
              title: Text('${(espelhoCarga.descricao ?? '').toString()}',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (espelhoCarga.placa != null &&
                      espelhoCarga.placa!.isNotEmpty)
                    Text('Placa: ${espelhoCarga.placa}',
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                        )),
                  if (espelhoCarga.descricao != null &&
                      espelhoCarga.descricao!.isNotEmpty)
                    Text('Lote: ${espelhoCarga.lote}',
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
