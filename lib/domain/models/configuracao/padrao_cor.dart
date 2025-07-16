import 'package:flutter/cupertino.dart';

class PadraoCor {
  String? id;
  String? nome;
  String? descricao;

  PadraoCor({
    this.id,
    this.nome,
    this.descricao,
  });
}

class PadraoCorController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  PadraoCorController({
    this.id,
    this.nome,
    this.descricao,
  });
}
