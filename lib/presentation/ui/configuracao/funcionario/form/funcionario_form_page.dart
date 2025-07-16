import 'package:igmp/data/repositories/comum/pais_repository.dart';
import 'package:igmp/data/repositories/comum/estado_repository.dart';
import 'package:igmp/data/repositories/comum/cidade_repository.dart';
import 'package:igmp/data/repositories/configuracao/funcionario_repository.dart';
import 'package:igmp/domain/models/configuracao/funcionario.dart';
import 'package:igmp/domain/models/shared/text_input_types.dart';
import 'package:igmp/presentation/components/app_confirm_action.dart';
import 'package:igmp/presentation/components/app_form_button.dart';
import 'package:igmp/presentation/components/app_scaffold.dart';
import 'package:igmp/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:igmp/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:igmp/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:igmp/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FuncionarioFormPage extends StatefulWidget {
  const FuncionarioFormPage({super.key});

  @override
  State<FuncionarioFormPage> createState() => _FuncionarioFormPageState();
}

class _FuncionarioFormPageState extends State<FuncionarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = FuncionarioController(
    id: TextEditingController(),
    nome: TextEditingController(),
    cpf: TextEditingController(),
    rg: TextEditingController(),
    email: TextEditingController(),
    cep: TextEditingController(),
    paisId: TextEditingController(),
    paisNomePais: TextEditingController(),
    estadoId: TextEditingController(),
    estadoUf: TextEditingController(),
    cidadeId: TextEditingController(),
    cidadeNomeCidade: TextEditingController(),
    bairro: TextEditingController(),
    endereco: TextEditingController(),
    numero: TextEditingController(),
    complemento: TextEditingController(),
    telefone: TextEditingController(),
    observacoes: TextEditingController(),
    desabilitado: false,
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context)
                .pushNamedAndRemoveUntil('/funcionarios', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmActionWidget(
                    message: 'Deseja mesmo sair sem salvar as alteracoes?',
                    cancelButtonText: 'Nao',
                    confirmButtonText: 'Sim',
                  );
                },
              ).then((value) => value
                ? Navigator.of(context)
                    .pushNamedAndRemoveUntil('/funcionarios', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Funcionarios Form'),
        showDrawer: false,
        body: formFields(context),
      ),
    );
  }

  Form formFields(context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _nomeField,
              _cpfField,
              _rgField,
              _emailField,
              _cepField,
              _paisIdField,
              _estadoIdField,
              _cidadeIdField,
              _bairroField,
              _enderecoField,
              _numeroField,
              _complementoField,
              _telefoneField,
              _observacoesField,
              _desabilitadoField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: _isViewPage,
      controller: _controllers.nome!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _cpfField {
    return FormTextInput(
      label: 'CPF',
      isDisabled: _isViewPage,
      controller: _controllers.cpf!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _rgField {
    return FormTextInput(
      label: 'RG',
      isDisabled: _isViewPage,
      controller: _controllers.rg!,
    );
  }

  Widget get _emailField {
    return FormTextInput(
      label: 'EMail',
      isDisabled: _isViewPage,
      controller: _controllers.email!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _cepField {
    return FormTextInput(
      label: 'CEP',
      isDisabled: _isViewPage,
      controller: _controllers.cep!,
    );
  }

  Widget get _paisIdField {
    return FormSelectInput(
      label: 'País',
      isDisabled: _isViewPage,
      controllerValue: _controllers.paisId!,
      controllerLabel: _controllers.paisNomePais!,
      itemsCallback: (pattern) async =>
          Provider.of<PaisRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _estadoIdField {
    return FormSelectInput(
      label: 'UF',
      isDisabled: _isViewPage,
      controllerValue: _controllers.estadoId!,
      controllerLabel: _controllers.estadoUf!,
      itemsCallback: (pattern) async =>
          Provider.of<EstadoRepository>(context, listen: false).select(pattern),
      onSaved: (suggestion) {
        setState(() {
          _controllers.estadoId!.text = suggestion['value']!;
          _controllers.estadoUf!.text = suggestion['label']!;
        });
      },
    );
  }

  Widget get _cidadeIdField {
    return FormSelectInput(
      label: 'Cidade',
      isDisabled: _isViewPage,
      controllerValue: _controllers.cidadeId!,
      controllerLabel: _controllers.cidadeNomeCidade!,
      itemsCallback: (pattern) async =>
          Provider.of<CidadeRepository>(context, listen: false)
              .select(pattern, _controllers.estadoId!.text),
    );
  }

  Widget get _bairroField {
    return FormTextInput(
      label: 'Bairro',
      isDisabled: _isViewPage,
      controller: _controllers.bairro!,
    );
  }

  Widget get _enderecoField {
    return FormTextInput(
      label: 'Endereco',
      isDisabled: _isViewPage,
      controller: _controllers.endereco!,
    );
  }

  Widget get _numeroField {
    return FormTextInput(
      label: 'Número',
      type: TextInputTypes.integer,
      isDisabled: _isViewPage,
      controller: _controllers.numero!,
    );
  }

  Widget get _complementoField {
    return FormTextInput(
      label: 'Complemento',
      isDisabled: _isViewPage,
      controller: _controllers.complemento!,
    );
  }

  Widget get _telefoneField {
    return FormTextInput(
      label: 'Telefone',
      isDisabled: _isViewPage,
      controller: _controllers.telefone!,
    );
  }

  Widget get _observacoesField {
    return FormTextInput(
      label: 'Observacoes',
      isDisabled: _isViewPage,
      controller: _controllers.observacoes!,
    );
  }

  Widget get _desabilitadoField {
    return AppCheckbox(
      label: 'Desabilitado',
      controller: _controllers.desabilitado!,
      onChanged: (value) {
        setState(() {
          _controllers.desabilitado = value;
        });
      },
    );
  }

  Widget get _actionButtons {
    return _isViewPage
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                  child: AppFormButton(submit: _cancel, label: 'Cancelar')),
              SizedBox(width: 10),
              Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
            ],
          );
  }

  // Functions

  Future<void> _loadData(String id) async {
    await Provider.of<FuncionarioRepository>(context, listen: false)
        .get(id)
        .then((funcionario) => _populateController(funcionario));
  }

  Future<void> _populateController(Funcionario funcionario) async {
    setState(() {
      _controllers.id!.text = funcionario.id ?? '';
      _controllers.nome!.text = funcionario.nome ?? '';
      _controllers.cpf!.text = funcionario.cpf ?? '';
      _controllers.rg!.text = funcionario.rg ?? '';
      _controllers.email!.text = funcionario.email ?? '';
      _controllers.cep!.text = funcionario.cep ?? '';
      _controllers.paisId!.text = funcionario.paisId ?? '';
      _controllers.paisNomePais!.text = funcionario.paisNomePais ?? '';
      _controllers.estadoId!.text = funcionario.estadoId ?? '';
      _controllers.estadoUf!.text = funcionario.estadoUf ?? '';
      _controllers.cidadeId!.text = funcionario.cidadeId ?? '';
      _controllers.cidadeNomeCidade!.text = funcionario.cidadeNomeCidade ?? '';
      _controllers.bairro!.text = funcionario.bairro ?? '';
      _controllers.endereco!.text = funcionario.endereco ?? '';
      _controllers.numero!.text = (funcionario.numero ?? '').toString();
      _controllers.complemento!.text = funcionario.complemento ?? '';
      _controllers.telefone!.text = funcionario.telefone ?? '';
      _controllers.observacoes!.text = funcionario.observacoes ?? '';
      _controllers.desabilitado = funcionario.desabilitado ?? false;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, dynamic?> payload = {
        'id': _controllers.id!.text,
        'nome': _controllers.nome!.text,
        'cpf': _controllers.cpf!.text,
        'rg': _controllers.rg!.text,
        'email': _controllers.email!.text,
        'cep': _controllers.cep!.text,
        'paisId': _controllers.paisId!.text,
        'estadoId': _controllers.estadoId!.text,
        'cidadeId': _controllers.cidadeId!.text,
        'bairro': _controllers.bairro!.text,
        'endereco': _controllers.endereco!.text,
        'numero': _controllers.numero!.text,
        'complemento': _controllers.complemento!.text,
        'telefone': _controllers.telefone!.text,
        'observacoes': _controllers.observacoes!.text,
        'desabilitado': _controllers.desabilitado!,
      };

      await Provider.of<FuncionarioRepository>(context, listen: false)
          .save(payload)
          .then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(
                message: _controllers.id!.text == ''
                    ? 'Registro criado com sucesso!'
                    : 'Registro atualizado com sucesso!',
                cancelButtonText: 'Ok',
              );
            },
          ).then((value) =>
              Navigator.of(context).pushReplacementNamed('/funcionarios'));
        }
      });
    } on AuthException catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return ConfirmActionWidget(
              message: error.toString(), cancelButtonText: 'Ok');
        },
      );
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return ConfirmActionWidget(
              message: 'Ocorreu um erro inesperado!', cancelButtonText: 'Ok');
        },
      );
    }
  }

  Future<void> _cancel() async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmActionWidget(
          message: 'Tem certeza que deseja sair?',
          cancelButtonText: 'Nao',
          confirmButtonText: 'Sim',
        );
      },
    ).then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed('/funcionarios');
      }
    });
  }
}
