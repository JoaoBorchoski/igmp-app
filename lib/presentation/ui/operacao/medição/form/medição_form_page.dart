import 'package:igmp/data/repositories/configuracao/largura_vaos_repository.dart';
import 'package:igmp/data/repositories/configuracao/altura_vaos_repository.dart';
import 'package:igmp/data/repositories/configuracao/tipo_enchimento_repository.dart';
import 'package:igmp/data/repositories/configuracao/tipo_porta_repository.dart';
import 'package:igmp/data/repositories/configuracao/sentido_abertura_repository.dart';
import 'package:igmp/data/repositories/configuracao/alizar_repository.dart';
import 'package:igmp/data/repositories/configuracao/fechadura_repository.dart';
import 'package:igmp/data/repositories/operacao/medi%C3%A7%C3%A3o_repository.dart';
import 'package:igmp/domain/models/operacao/medi%C3%A7%C3%A3o.dart';
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

class MedicaoFormPage extends StatefulWidget {
  const MedicaoFormPage({super.key});

  @override
  State<MedicaoFormPage> createState() => _MedicaoFormPageState();
}

class _MedicaoFormPageState extends State<MedicaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = MedicaoController(
    id: TextEditingController(),
    obraId: TextEditingController(),
    nome: TextEditingController(),
    complemento: TextEditingController(),
    espessuraParede: TextEditingController(),
    larguraVaosId: TextEditingController(),
    larguraVaosMedida: TextEditingController(),
    alturaVaosId: TextEditingController(),
    alturaVaosMedida: TextEditingController(),
    tipoEnchimentoId: TextEditingController(),
    tipoEnchimentoDescricao: TextEditingController(),
    tipoPortaId: TextEditingController(),
    tipoPortaDescricao: TextEditingController(),
    confirmacao: false,
    complementoOrigemId: TextEditingController(),
    descricao: TextEditingController(),
    sentidoAberturaId: TextEditingController(),
    sentidoAberturaDescricao: TextEditingController(),
    alizarId: TextEditingController(),
    alizarDescricao: TextEditingController(),
    fechaduraId: TextEditingController(),
    fechaduraDescricao: TextEditingController(),
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
                .pushNamedAndRemoveUntil('/medicoes', (route) => false)
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
                    .pushNamedAndRemoveUntil('/medicoes', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Medicoes Form'),
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
              _obraIdField,
              _complementoField,
              _espessuraParedeField,
              _larguraVaosIdField,
              _alturaVaosIdField,
              _tipoEnchimentoIdField,
              _tipoPortaIdField,
              _confirmacaoField,
              _complementoOrigemIdField,
              _sentidoAberturaIdField,
              _alizarIdField,
              _fechaduraIdField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _obraIdField {
    return FormSelectInput(
      label: 'Obra',
      isDisabled: _isViewPage,
      controllerValue: _controllers.obraId!,
      controllerLabel: _controllers.nome!,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<MedicaoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _complementoField {
    return FormTextInput(
      label: 'Complemento',
      isDisabled: _isViewPage,
      controller: _controllers.complemento!,
    );
  }

  Widget get _espessuraParedeField {
    return FormTextInput(
      label: 'Espessura Parede',
      isDisabled: _isViewPage,
      controller: _controllers.espessuraParede!,
    );
  }

  Widget get _larguraVaosIdField {
    return FormSelectInput(
      label: 'Largura Vao',
      isDisabled: _isViewPage,
      controllerValue: _controllers.larguraVaosId!,
      controllerLabel: _controllers.larguraVaosMedida!,
      itemsCallback: (pattern) async =>
          Provider.of<LarguraVaosRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _alturaVaosIdField {
    return FormSelectInput(
      label: 'Altura Vao',
      isDisabled: _isViewPage,
      controllerValue: _controllers.alturaVaosId!,
      controllerLabel: _controllers.alturaVaosMedida!,
      itemsCallback: (pattern) async =>
          Provider.of<AlturaVaosRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _tipoEnchimentoIdField {
    return FormSelectInput(
      label: 'Tipo Enchimento',
      isDisabled: _isViewPage,
      controllerValue: _controllers.tipoEnchimentoId!,
      controllerLabel: _controllers.tipoEnchimentoDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<TipoEnchimentoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _tipoPortaIdField {
    return FormSelectInput(
      label: 'Tipo Porta',
      isDisabled: _isViewPage,
      controllerValue: _controllers.tipoPortaId!,
      controllerLabel: _controllers.tipoPortaDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<TipoPortaRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _confirmacaoField {
    return AppCheckbox(
      label: 'Confirmado',
      controller: _controllers.confirmacao!,
      onChanged: (value) {
        setState(() {
          _controllers.confirmacao = value;
        });
      },
    );
  }

  Widget get _complementoOrigemIdField {
    return FormSelectInput(
      label: 'Complemento Origem',
      isDisabled: _isViewPage,
      controllerValue: _controllers.complementoOrigemId!,
      controllerLabel: _controllers.descricao!,
      itemsCallback: (pattern) async =>
          Provider.of<MedicaoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _sentidoAberturaIdField {
    return FormSelectInput(
      label: 'Sentido Abertura',
      isDisabled: _isViewPage,
      controllerValue: _controllers.sentidoAberturaId!,
      controllerLabel: _controllers.sentidoAberturaDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<SentidoAberturaRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _alizarIdField {
    return FormSelectInput(
      label: 'Alizar',
      isDisabled: _isViewPage,
      controllerValue: _controllers.alizarId!,
      controllerLabel: _controllers.alizarDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<AlizarRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _fechaduraIdField {
    return FormSelectInput(
      label: 'Fechadura',
      isDisabled: _isViewPage,
      controllerValue: _controllers.fechaduraId!,
      controllerLabel: _controllers.fechaduraDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<FechaduraRepository>(context, listen: false)
              .select(pattern),
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
    await Provider.of<MedicaoRepository>(context, listen: false)
        .get(id)
        .then((medicao) => _populateController(medicao));
  }

  Future<void> _populateController(Medicao medicao) async {
    setState(() {
      _controllers.id!.text = medicao.id ?? '';
      _controllers.obraId!.text = medicao.obraId ?? '';
      _controllers.nome!.text = medicao.nome ?? '';
      _controllers.complemento!.text = medicao.complemento ?? '';
      _controllers.espessuraParede!.text = medicao.espessuraParede ?? '';
      _controllers.larguraVaosId!.text = medicao.larguraVaosId ?? '';
      _controllers.larguraVaosMedida!.text = medicao.larguraVaosMedida ?? '';
      _controllers.alturaVaosId!.text = medicao.alturaVaosId ?? '';
      _controllers.alturaVaosMedida!.text = medicao.alturaVaosMedida ?? '';
      _controllers.tipoEnchimentoId!.text = medicao.tipoEnchimentoId ?? '';
      _controllers.tipoEnchimentoDescricao!.text =
          medicao.tipoEnchimentoDescricao ?? '';
      _controllers.tipoPortaId!.text = medicao.tipoPortaId ?? '';
      _controllers.tipoPortaDescricao!.text = medicao.tipoPortaDescricao ?? '';
      _controllers.confirmacao = medicao.confirmacao ?? false;
      _controllers.complementoOrigemId!.text =
          medicao.complementoOrigemId ?? '';
      _controllers.descricao!.text = medicao.descricao ?? '';
      _controllers.sentidoAberturaId!.text = medicao.sentidoAberturaId ?? '';
      _controllers.sentidoAberturaDescricao!.text =
          medicao.sentidoAberturaDescricao ?? '';
      _controllers.alizarId!.text = medicao.alizarId ?? '';
      _controllers.alizarDescricao!.text = medicao.alizarDescricao ?? '';
      _controllers.fechaduraId!.text = medicao.fechaduraId ?? '';
      _controllers.fechaduraDescricao!.text = medicao.fechaduraDescricao ?? '';
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
        'obraId': _controllers.obraId!.text,
        'complemento': _controllers.complemento!.text,
        'espessuraParede': _controllers.espessuraParede!.text,
        'larguraVaosId': _controllers.larguraVaosId!.text,
        'alturaVaosId': _controllers.alturaVaosId!.text,
        'tipoEnchimentoId': _controllers.tipoEnchimentoId!.text,
        'tipoPortaId': _controllers.tipoPortaId!.text,
        'confirmacao': _controllers.confirmacao!,
        'complementoOrigemId': _controllers.complementoOrigemId!.text,
        'sentidoAberturaId': _controllers.sentidoAberturaId!.text,
        'alizarId': _controllers.alizarId!.text,
        'fechaduraId': _controllers.fechaduraId!.text,
      };

      await Provider.of<MedicaoRepository>(context, listen: false)
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
              Navigator.of(context).pushReplacementNamed('/medicoes'));
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
        Navigator.of(context).pushReplacementNamed('/medicoes');
      }
    });
  }
}
