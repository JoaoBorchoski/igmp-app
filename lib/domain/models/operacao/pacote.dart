import 'package:flutter/cupertino.dart';
import 'package:igmp/domain/models/operacao/pacote_item.dart';

class Pacote {
  String? id;
  String? pedidoId;
  String? pedidoSequencial;
  String? descricao;
  int? sequencial;
  String? pedidoLabel;
  List<PacoteItem>? items;

  Pacote({
    this.id,
    this.pedidoId,
    this.pedidoSequencial,
    this.descricao,
    this.sequencial,
    this.pedidoLabel,
    this.items,
  });
}

class PacoteController {
  TextEditingController? id;
  TextEditingController? pedidoId;
  TextEditingController? pedidoSequencial;
  TextEditingController? descricao;
  TextEditingController? sequencial;
  TextEditingController? pedidoLabel;
  List<PacoteItem>? items;

  PacoteController({
    this.id,
    this.pedidoId,
    this.pedidoSequencial,
    this.descricao,
    this.sequencial,
    this.pedidoLabel,
    this.items,
  });
}
