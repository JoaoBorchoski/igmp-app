import 'package:flutter/cupertino.dart';

class TipoEnchimento {
  String? id;
  String? nome;
  String? descricao;

  TipoEnchimento({
    this.id,
    this.nome,
    this.descricao,
  });
}

class TipoEnchimentoController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  TipoEnchimentoController({
    this.id,
    this.nome,
    this.descricao,
  });
}
