import 'package:flutter/cupertino.dart';

class PedidoItem {
  String? id;
  String? pedidoId;
  String? pedidoSequencial;
  String? produto;
  double? quantidade;
  String? corEtiqueta;

  PedidoItem({
    this.id,
    this.pedidoId,
    this.pedidoSequencial,
    this.produto,
    this.quantidade,
    this.corEtiqueta,
  });
}

class PedidoItemController {
  TextEditingController? id;
  TextEditingController? pedidoId;
  TextEditingController? pedidoSequencial;
  TextEditingController? produto;
  TextEditingController? quantidade;
  TextEditingController? corEtiqueta;

  PedidoItemController({
    this.id,
    this.pedidoId,
    this.pedidoSequencial,
    this.produto,
    this.quantidade,
    this.corEtiqueta,
  });
}
