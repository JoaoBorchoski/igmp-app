import 'package:flutter/cupertino.dart';

class Cep {
  String? id;
  String? codigoCep;
  String? logradouro;
  String? bairro;
  String? estadoId;
  String? estadoUf;
  String? cidadeId;
  String? cidadeNomeCidade;

  Cep({
    this.id,
    this.codigoCep,
    this.logradouro,
    this.bairro,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
  });
}

class CepController {
  TextEditingController? id;
  TextEditingController? codigoCep;
  TextEditingController? logradouro;
  TextEditingController? bairro;
  TextEditingController? estadoId;
  TextEditingController? estadoUf;
  TextEditingController? cidadeId;
  TextEditingController? cidadeNomeCidade;

  CepController({
    this.id,
    this.codigoCep,
    this.logradouro,
    this.bairro,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
  });
}
