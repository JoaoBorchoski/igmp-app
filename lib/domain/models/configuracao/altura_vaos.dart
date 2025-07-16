import 'package:flutter/cupertino.dart';

class AlturaVaos {
  String? id;
  String? nome;
  String? descricao;

  AlturaVaos({
    this.id,
    this.nome,
    this.descricao,
  });
}

class AlturaVaosController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  AlturaVaosController({
    this.id,
    this.nome,
    this.descricao,
  });
}
