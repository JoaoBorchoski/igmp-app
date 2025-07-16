import 'package:flutter/cupertino.dart';

class LarguraVaos {
  String? id;
  String? nome;
  String? descricao;

  LarguraVaos({
    this.id,
    this.nome,
    this.descricao,
  });
}

class LarguraVaosController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  LarguraVaosController({
    this.id,
    this.nome,
    this.descricao,
  });
}
