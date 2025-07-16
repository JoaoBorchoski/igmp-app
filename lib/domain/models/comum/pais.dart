import 'package:flutter/cupertino.dart';

class Pais {
  String? id;
  String? codigoPais;
  String? nomePais;

  Pais({
    this.id,
    this.codigoPais,
    this.nomePais,
  });
}

class PaisController {
  TextEditingController? id;
  TextEditingController? codigoPais;
  TextEditingController? nomePais;

  PaisController({
    this.id,
    this.codigoPais,
    this.nomePais,
  });
}
