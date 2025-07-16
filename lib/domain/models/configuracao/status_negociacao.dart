import 'package:flutter/cupertino.dart';

class StatusNegociacao {
  String? id;
  String? nome;
  String? descricao;

  StatusNegociacao({
    this.id,
    this.nome,
    this.descricao,
  });
}

class StatusNegociacaoController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  StatusNegociacaoController({
    this.id,
    this.nome,
    this.descricao,
  });
}
