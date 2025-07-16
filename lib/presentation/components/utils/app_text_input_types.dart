import 'package:igmp/domain/models/shared/text_input_types.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';

List<TextInputFormatter> filterTextInputFormatterByType(TextInputTypes? type) {
  switch (type) {
    case TextInputTypes.integer:
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    case TextInputTypes.cpf:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ];
    case TextInputTypes.cnpj:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ];
    case TextInputTypes.cep:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ];
    case TextInputTypes.phone:
      return [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ];
    case TextInputTypes.date:
      return [
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter(),
      ];
    case TextInputTypes.hour:
      return [
        FilteringTextInputFormatter.digitsOnly,
        HoraInputFormatter(),
      ];
    default:
      return [];
  }
}
