import 'package:igmp/data/repositories/configuracao/padrao_cor_repository.dart';
import 'package:igmp/data/repositories/operacao/obra_repository.dart';
import 'package:igmp/domain/models/operacao/obra.dart';
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

class ObraFormPage extends StatefulWidget {
  const ObraFormPage({super.key});

  @override
  State<ObraFormPage> createState() => _ObraFormPageState();
}

class _ObraFormPageState extends State<ObraFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = ObraController(
    id: TextEditingController(),
    nome: TextEditingController(),
    cnpj: TextEditingController(),
    endereco: TextEditingController(),
    responsavelObra: TextEditingController(),
    contato: TextEditingController(),
    previsaoEntrega: TextEditingController(),
    tipoObra: TextEditingController(),
    plantasIguais: false,
    qtdCasas: TextEditingController(),
    grupoCasas: TextEditingController(),
    estruturaPredio: TextEditingController(),
    qtdAptoPorAndar: TextEditingController(),
    andares: TextEditingController(),
    qtdAptos: TextEditingController(),
    grupoAndares: TextEditingController(),
    padraoCorId: TextEditingController(),
    padraoCorNome: TextEditingController(),
    solidaMadeirada: TextEditingController(),
    coresTiposId: TextEditingController(),
    Descricao: TextEditingController(),
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
                .pushNamedAndRemoveUntil('/obras', (route) => false)
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
                    .pushNamedAndRemoveUntil('/obras', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Obras Form'),
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
              _cnpjField,
              _enderecoField,
              _responsavelObraField,
              _contatoField,
              _previsaoEntregaField,
              _tipoObraField,
              _plantasIguaisField,
              _qtdCasasField,
              _grupoCasasField,
              _estruturaPredioField,
              _qtdAptoPorAndarField,
              _andaresField,
              _qtdAptosField,
              _grupoAndaresField,
              _padraoCorIdField,
              _solidaMadeiradaField,
              _coresTiposIdField,
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

  Widget get _cnpjField {
    return FormTextInput(
      label: 'CNPJ',
      isDisabled: _isViewPage,
      controller: _controllers.cnpj!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _enderecoField {
    return FormTextInput(
      label: 'Endereco',
      isDisabled: _isViewPage,
      controller: _controllers.endereco!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _responsavelObraField {
    return FormTextInput(
      label: 'Responsável Obra',
      isDisabled: _isViewPage,
      controller: _controllers.responsavelObra!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _contatoField {
    return FormTextInput(
      label: 'Contato',
      isDisabled: _isViewPage,
      controller: _controllers.contato!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _previsaoEntregaField {
    return FormTextInput(
      label: 'Previsao Entrega',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.previsaoEntrega!,
    );
  }

  Widget get _tipoObraField {
    return FormTextInput(
      label: 'Tipo Obra (Casa/Prédio)',
      isDisabled: _isViewPage,
      controller: _controllers.tipoObra!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _plantasIguaisField {
    return AppCheckbox(
      label: 'Plantas Iguais?',
      controller: _controllers.plantasIguais!,
      onChanged: (value) {
        setState(() {
          _controllers.plantasIguais = value;
        });
      },
    );
  }

  Widget get _qtdCasasField {
    return FormTextInput(
      label: 'Quantidade Casas',
      type: TextInputTypes.integer,
      isDisabled: _isViewPage,
      controller: _controllers.qtdCasas!,
    );
  }

  Widget get _grupoCasasField {
    return FormTextInput(
      label: 'Grupos de Casas',
      isDisabled: _isViewPage,
      controller: _controllers.grupoCasas!,
    );
  }

  Widget get _estruturaPredioField {
    return FormTextInput(
      label: 'Estrutura (Torre/Bloco)',
      isDisabled: _isViewPage,
      controller: _controllers.estruturaPredio!,
    );
  }

  Widget get _qtdAptoPorAndarField {
    return FormTextInput(
      label: 'Qtde Apto/Andar',
      type: TextInputTypes.integer,
      isDisabled: _isViewPage,
      controller: _controllers.qtdAptoPorAndar!,
    );
  }

  Widget get _andaresField {
    return FormTextInput(
      label: 'Andares',
      type: TextInputTypes.integer,
      isDisabled: _isViewPage,
      controller: _controllers.andares!,
    );
  }

  Widget get _qtdAptosField {
    return FormTextInput(
      label: 'Qtde Aptos',
      type: TextInputTypes.integer,
      isDisabled: _isViewPage,
      controller: _controllers.qtdAptos!,
    );
  }

  Widget get _grupoAndaresField {
    return FormTextInput(
      label: 'Grupo de Andares',
      isDisabled: _isViewPage,
      controller: _controllers.grupoAndares!,
    );
  }

  Widget get _padraoCorIdField {
    return FormSelectInput(
      label: 'Padrao Cor',
      isDisabled: _isViewPage,
      controllerValue: _controllers.padraoCorId!,
      controllerLabel: _controllers.padraoCorNome!,
      itemsCallback: (pattern) async =>
          Provider.of<PadraoCorRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _solidaMadeiradaField {
    return FormTextInput(
      label: 'Sólida/Madeirada',
      isDisabled: _isViewPage,
      controller: _controllers.solidaMadeirada!,
    );
  }

  Widget get _coresTiposIdField {
    return FormSelectInput(
      label: 'Cores/Tipos',
      isDisabled: _isViewPage,
      controllerValue: _controllers.coresTiposId!,
      controllerLabel: _controllers.Descricao!,
      itemsCallback: (pattern) async =>
          Provider.of<ObraRepository>(context, listen: false).select(pattern),
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
    await Provider.of<ObraRepository>(context, listen: false)
        .get(id)
        .then((obra) => _populateController(obra));
  }

  Future<void> _populateController(Obra obra) async {
    setState(() {
      _controllers.id!.text = obra.id ?? '';
      _controllers.nome!.text = obra.nome ?? '';
      _controllers.cnpj!.text = obra.cnpj ?? '';
      _controllers.endereco!.text = obra.endereco ?? '';
      _controllers.responsavelObra!.text = obra.responsavelObra ?? '';
      _controllers.contato!.text = obra.contato ?? '';
      _controllers.previsaoEntrega!.text =
          (obra.previsaoEntrega ?? '').toString();
      _controllers.tipoObra!.text = obra.tipoObra ?? '';
      _controllers.plantasIguais = obra.plantasIguais ?? false;
      _controllers.qtdCasas!.text = (obra.qtdCasas ?? '').toString();
      _controllers.grupoCasas!.text = obra.grupoCasas ?? '';
      _controllers.estruturaPredio!.text = obra.estruturaPredio ?? '';
      _controllers.qtdAptoPorAndar!.text =
          (obra.qtdAptoPorAndar ?? '').toString();
      _controllers.andares!.text = (obra.andares ?? '').toString();
      _controllers.qtdAptos!.text = (obra.qtdAptos ?? '').toString();
      _controllers.grupoAndares!.text = obra.grupoAndares ?? '';
      _controllers.padraoCorId!.text = obra.padraoCorId ?? '';
      _controllers.padraoCorNome!.text = obra.padraoCorNome ?? '';
      _controllers.solidaMadeirada!.text = obra.solidaMadeirada ?? '';
      _controllers.coresTiposId!.text = obra.coresTiposId ?? '';
      _controllers.Descricao!.text = obra.Descricao ?? '';
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
        'cnpj': _controllers.cnpj!.text,
        'endereco': _controllers.endereco!.text,
        'responsavelObra': _controllers.responsavelObra!.text,
        'contato': _controllers.contato!.text,
        'previsaoEntrega': _controllers.previsaoEntrega!.text,
        'tipoObra': _controllers.tipoObra!.text,
        'plantasIguais': _controllers.plantasIguais!,
        'qtdCasas': _controllers.qtdCasas!.text,
        'grupoCasas': _controllers.grupoCasas!.text,
        'estruturaPredio': _controllers.estruturaPredio!.text,
        'qtdAptoPorAndar': _controllers.qtdAptoPorAndar!.text,
        'andares': _controllers.andares!.text,
        'qtdAptos': _controllers.qtdAptos!.text,
        'grupoAndares': _controllers.grupoAndares!.text,
        'padraoCorId': _controllers.padraoCorId!.text,
        'solidaMadeirada': _controllers.solidaMadeirada!.text,
        'coresTiposId': _controllers.coresTiposId!.text,
      };

      await Provider.of<ObraRepository>(context, listen: false)
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
          ).then(
              (value) => Navigator.of(context).pushReplacementNamed('/obras'));
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
        Navigator.of(context).pushReplacementNamed('/obras');
      }
    });
  }
}
