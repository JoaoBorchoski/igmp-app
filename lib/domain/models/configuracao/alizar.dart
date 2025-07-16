import 'package:flutter/cupertino.dart';

class Alizar {
  String? id;
  String? nome;
  String? descricao;

  Alizar({
    this.id,
    this.nome,
    this.descricao,
  });
}

class AlizarController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  AlizarController({
    this.id,
    this.nome,
    this.descricao,
  });
}
