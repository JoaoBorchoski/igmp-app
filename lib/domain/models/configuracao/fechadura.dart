import 'package:flutter/cupertino.dart';

class Fechadura {
  String? id;
  String? nome;
  String? descricao;

  Fechadura({
    this.id,
    this.nome,
    this.descricao,
  });
}

class FechaduraController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  FechaduraController({
    this.id,
    this.nome,
    this.descricao,
  });
}
