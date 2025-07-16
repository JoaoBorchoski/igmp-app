import 'package:flutter/cupertino.dart';

class TipoPorta {
  String? id;
  String? nome;
  String? descricao;

  TipoPorta({
    this.id,
    this.nome,
    this.descricao,
  });
}

class TipoPortaController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;

  TipoPortaController({
    this.id,
    this.nome,
    this.descricao,
  });
}
