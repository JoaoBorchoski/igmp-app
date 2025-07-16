import 'package:igmp/domain/models/shared/text_input_types.dart';
import 'package:brasil_fields/brasil_fields.dart';

String? textInputTypesValidator(String value, TextInputTypes? type) {
  switch (type) {
    case TextInputTypes.cpf:
      if (!UtilBrasilFields.isCPFValido(value)) {
        return 'CPF inválido';
      }
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      return null;
    case TextInputTypes.cnpj:
      if (!UtilBrasilFields.isCNPJValido(value)) {
        return 'CPF inválido';
      }
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      return null;
    case TextInputTypes.cep:
      if (value.length < 10) {
        return 'CPF inválido';
      }
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      return null;
    case TextInputTypes.phone:
      if (value.length < 14) {
        return 'Telefone inválido!';
      }
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      return null;
    case TextInputTypes.email:
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      if (!value.contains('@') || !value.contains('.')) {
        return 'Email inválido!';
      }
      return null;
    default:
      if (value.isEmpty) {
        return 'Campo Obrigatório';
      }
      return null;
  }
}
