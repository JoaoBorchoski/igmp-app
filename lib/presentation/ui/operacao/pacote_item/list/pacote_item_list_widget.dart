import 'package:igmp/data/repositories/operacao/pacote_item_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_list_dismissible_card.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:igmp/domain/models/operacao/pacote_item.dart';
import 'package:provider/provider.dart';

class PacoteItemListWidget extends StatelessWidget {
  final PacoteItem pacoteItem;

  const PacoteItemListWidget(
    this.pacoteItem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(direction: authentication.permitUpdateDelete('/pacotes-items'),
      endToStart: () async {
        await Provider.of<PacoteItemRepository>(context, listen: false).delete(pacoteItem).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': pacoteItem.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/pacotes-items-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': pacoteItem.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/pacotes-items-form', arguments: data);
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
            child: ListTile(title: Text((pacoteItem.pacoteId ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
              subtitle: Text((pacoteItem.quantidade ?? '').toString(),
                  style: TextStyle(color: AppColors.cardTextColor,)),
            ),
          ),
        ],
      ),
    );
  }
}
