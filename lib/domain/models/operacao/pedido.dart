import 'package:flutter/cupertino.dart';

class Pedido {
  String? id;
  double? sequencial;
  String? cliente;
  String? telefone;
  String? cep;
  String? endereco;
  String? numero;
  String? complemento;
  String? bairro;
  String? estadoId;
  String? estadoUf;
  String? cidadeId;
  String? cidadeNome;
  String? status;

  Pedido({
    this.id,
    this.sequencial,
    this.cliente,
    this.telefone,
    this.cep,
    this.endereco,
    this.numero,
    this.complemento,
    this.bairro,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNome,
    this.status,
  });
}

class PedidoController {
  TextEditingController? id;
  TextEditingController? sequencial;
  TextEditingController? cliente;
  TextEditingController? telefone;
  TextEditingController? cep;
  TextEditingController? endereco;
  TextEditingController? numero;
  TextEditingController? complemento;
  TextEditingController? bairro;
  TextEditingController? estadoId;
  TextEditingController? estadoUf;
  TextEditingController? cidadeId;
  TextEditingController? cidadeNome;
  TextEditingController? status;

  PedidoController({
    this.id,
    this.sequencial,
    this.cliente,
    this.telefone,
    this.cep,
    this.endereco,
    this.numero,
    this.complemento,
    this.bairro,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNome,
    this.status,
  });
}
