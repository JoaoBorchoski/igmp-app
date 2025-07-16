import 'package:flutter/cupertino.dart';

class SentidoAbertura {
  String? id;
  String? nome;
  String? descricao;

  SentidoAbertura({
    this.id,
    this.nome,
    this.descricao,
  });
}

class SentidoAberturaController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  SentidoAberturaController({
    this.id,
    this.nome,
    this.descricao,
  });
}
