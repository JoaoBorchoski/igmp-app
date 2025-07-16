import 'package:flutter/cupertino.dart';

class Cidade {
  String? id;
  String? estadoId;
  String? estadoUf;
  String? codigoIbge;
  String? nomeCidade;

  Cidade({
    this.id,
    this.estadoId,
    this.estadoUf,
    this.codigoIbge,
    this.nomeCidade,
  });
}

class CidadeController {
  TextEditingController? id;
  TextEditingController? estadoId;
  TextEditingController? estadoUf;
  TextEditingController? codigoIbge;
  TextEditingController? nomeCidade;

  CidadeController({
    this.id,
    this.estadoId,
    this.estadoUf,
    this.codigoIbge,
    this.nomeCidade,
  });
}
