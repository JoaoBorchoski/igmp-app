import 'package:igmp/data/repositories/comum/estado_repository.dart';
import 'package:igmp/data/repositories/comum/cidade_repository.dart';
import 'package:igmp/data/repositories/operacao/pedido_repository.dart';
import 'package:igmp/domain/models/operacao/pedido.dart';
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

class PedidoFormPage extends StatefulWidget {
  const PedidoFormPage({super.key});

  @override
  State<PedidoFormPage> createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = PedidoController(
    id: TextEditingController(),
    sequencial: TextEditingController(),
    cliente: TextEditingController(),
    telefone: TextEditingController(),
    cep: TextEditingController(),
    endereco: TextEditingController(),
    numero: TextEditingController(),
    complemento: TextEditingController(),
    bairro: TextEditingController(),
    estadoId: TextEditingController(),
    estadoUf: TextEditingController(),
    cidadeId: TextEditingController(),
    cidadeNome: TextEditingController(),
    status: TextEditingController(),
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
                .pushNamedAndRemoveUntil('/pedidos', (route) => false)
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
                    .pushNamedAndRemoveUntil('/pedidos', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Pedidos Form'),
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
              _sequencialField,
              _clienteField,
              _telefoneField,
              _cepField,
              _enderecoField,
              _numeroField,
              _complementoField,
              _bairroField,
              _estadoIdField,
              _cidadeIdField,
              _statusField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _sequencialField {
    return FormTextInput(
      label: 'Sequencial',
      type: TextInputTypes.number,
      isDisabled: _isViewPage,
      controller: _controllers.sequencial!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _clienteField {
    return FormTextInput(
      label: 'Cliente',
      isDisabled: _isViewPage,
      controller: _controllers.cliente!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _telefoneField {
    return FormTextInput(
      label: 'Telefone',
      isDisabled: _isViewPage,
      controller: _controllers.telefone!,
    );
  }

  Widget get _cepField {
    return FormTextInput(
      label: 'CEP',
      isDisabled: _isViewPage,
      controller: _controllers.cep!,
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

  Widget get _bairroField {
    return FormTextInput(
      label: 'Bairro',
      isDisabled: _isViewPage,
      controller: _controllers.bairro!,
    );
  }

  Widget get _estadoIdField {
    return FormSelectInput(
      label: 'UF',
      isDisabled: _isViewPage,
      controllerValue: _controllers.estadoId!,
      controllerLabel: _controllers.estadoUf!,
      isRequired: true,
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
      controllerLabel: _controllers.cidadeNome!,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<CidadeRepository>(context, listen: false)
              .select(pattern, _controllers.estadoId!.text),
    );
  }

  Widget get _statusField {
    return FormTextInput(
      label: 'Status do Pedido',
      isDisabled: _isViewPage,
      controller: _controllers.status!,
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
    await Provider.of<PedidoRepository>(context, listen: false)
        .get(id)
        .then((pedido) => _populateController(pedido));
  }

  Future<void> _populateController(Pedido pedido) async {
    setState(() {
      _controllers.id!.text = pedido.id ?? '';
      _controllers.sequencial!.text = (pedido.sequencial ?? '').toString();
      _controllers.cliente!.text = pedido.cliente ?? '';
      _controllers.telefone!.text = pedido.telefone ?? '';
      _controllers.cep!.text = pedido.cep ?? '';
      _controllers.endereco!.text = pedido.endereco ?? '';
      _controllers.numero!.text = pedido.numero ?? '';
      _controllers.complemento!.text = pedido.complemento ?? '';
      _controllers.bairro!.text = pedido.bairro ?? '';
      _controllers.estadoId!.text = pedido.estadoId ?? '';
      _controllers.estadoUf!.text = pedido.estadoUf ?? '';
      _controllers.cidadeId!.text = pedido.cidadeId ?? '';
      _controllers.cidadeNome!.text = pedido.cidadeNome ?? '';
      _controllers.status!.text = pedido.status ?? '';
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
        'sequencial': _controllers.sequencial!.text,
        'cliente': _controllers.cliente!.text,
        'telefone': _controllers.telefone!.text,
        'cep': _controllers.cep!.text,
        'endereco': _controllers.endereco!.text,
        'numero': _controllers.numero!.text,
        'complemento': _controllers.complemento!.text,
        'bairro': _controllers.bairro!.text,
        'estadoId': _controllers.estadoId!.text,
        'cidadeId': _controllers.cidadeId!.text,
        'status': _controllers.status!.text,
      };

      await Provider.of<PedidoRepository>(context, listen: false)
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
              Navigator.of(context).pushReplacementNamed('/pedidos'));
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
        Navigator.of(context).pushReplacementNamed('/pedidos');
      }
    });
  }
}
