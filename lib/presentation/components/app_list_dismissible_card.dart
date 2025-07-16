// ignore_for_file: file_names

import 'package:igmp/presentation/components/app_confirm_action.dart';
import 'package:flutter/material.dart';

class AppDismissible extends StatelessWidget {
  final Widget body;
  final DismissDirection? direction;
  final void Function() endToStart;
  final void Function() startToEnd;
  final void Function() onDoubleTap;

  const AppDismissible({
    super.key,
    required this.body,
    this.direction,
    required this.endToStart,
    required this.startToEnd,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: direction ?? DismissDirection.none,
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.amber[900],
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) {
        String acao = '';
        switch (direction) {
          case DismissDirection.endToStart:
            acao = 'excluir';
            break;
          case DismissDirection.startToEnd:
            acao = 'editar';
            break;
          default:
            false;
        }
        return showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              title: 'Edicao',
              message: 'Deseja realmente $acao esse registro?',
              confirmButtonText: 'Sim',
              cancelButtonText: 'Nao',
            );
          },
        );
      },
      onDismissed: (direction) {
        switch (direction) {
          case DismissDirection.endToStart:
            endToStart();
            break;
          case DismissDirection.startToEnd:
            startToEnd();
            break;
          default:
        }
      },
      key: UniqueKey(),
      child: GestureDetector(
        onDoubleTap: () {
          onDoubleTap();
        },
        child: body,
      ),
    );
  }
}
