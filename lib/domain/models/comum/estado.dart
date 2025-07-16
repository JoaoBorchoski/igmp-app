import 'package:flutter/cupertino.dart';

class Estado {
  String? id;
  String? codigoIbge;
  String? uf;
  String? nomeEstado;

  Estado({
    this.id,
    this.codigoIbge,
    this.uf,
    this.nomeEstado,
  });
}

class EstadoController {
  TextEditingController? id;
  TextEditingController? codigoIbge;
  TextEditingController? uf;
  TextEditingController? nomeEstado;

  EstadoController({
    this.id,
    this.codigoIbge,
    this.uf,
    this.nomeEstado,
  });
}
