import 'package:igmp/data/repositories/configuracao/cliente_repository.dart';
import 'package:igmp/data/repositories/configuracao/status_negociacao_repository.dart';
import 'package:igmp/data/repositories/configuracao/funcionario_repository.dart';
import 'package:igmp/data/repositories/operacao/medi%C3%A7%C3%A3o_repository.dart';
import 'package:igmp/data/repositories/operacao/negociacao_repository.dart';
import 'package:igmp/domain/models/operacao/negociacao.dart';
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

class NegociacaoFormPage extends StatefulWidget {
  const NegociacaoFormPage({super.key});

  @override
  State<NegociacaoFormPage> createState() => _NegociacaoFormPageState();
}

class _NegociacaoFormPageState extends State<NegociacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = NegociacaoController(
    id: TextEditingController(),
    medicaoId: TextEditingController(),
    medicaoObraId: TextEditingController(),
    clienteId: TextEditingController(),
    clienteNome: TextEditingController(),
    statusNegociacaoId: TextEditingController(),
    statusNegociacaoDescricao: TextEditingController(),
    funcionarioId: TextEditingController(),
    funcionarioNome: TextEditingController(),
    dataCriacao: TextEditingController(),
    dataFechamento: TextEditingController(),
    valorEstimado: TextEditingController(),
    descricao: TextEditingController(),
    motivoPerda: TextEditingController(),
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
                .pushNamedAndRemoveUntil('/negociacoes', (route) => false)
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
                    .pushNamedAndRemoveUntil('/negociacoes', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Negociacoes Form'),
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
              _medicaoIdField,
              _clienteIdField,
              _statusNegociacaoIdField,
              _funcionarioIdField,
              _dataCriacaoField,
              _dataFechamentoField,
              _valorEstimadoField,
              _descricaoField,
              _motivoPerdaField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _medicaoIdField {
    return FormSelectInput(
      label: 'Medicao',
      isDisabled: _isViewPage,
      controllerValue: _controllers.medicaoId!,
      controllerLabel: _controllers.medicaoObraId!,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<MedicaoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _clienteIdField {
    return FormSelectInput(
      label: 'Cliente',
      isDisabled: _isViewPage,
      controllerValue: _controllers.clienteId!,
      controllerLabel: _controllers.clienteNome!,
      itemsCallback: (pattern) async =>
          Provider.of<ClienteRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _statusNegociacaoIdField {
    return FormSelectInput(
      label: 'Status Negociacao',
      isDisabled: _isViewPage,
      controllerValue: _controllers.statusNegociacaoId!,
      controllerLabel: _controllers.statusNegociacaoDescricao!,
      itemsCallback: (pattern) async =>
          Provider.of<StatusNegociacaoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _funcionarioIdField {
    return FormSelectInput(
      label: 'Responsável',
      isDisabled: _isViewPage,
      controllerValue: _controllers.funcionarioId!,
      controllerLabel: _controllers.funcionarioNome!,
      itemsCallback: (pattern) async =>
          Provider.of<FuncionarioRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _dataCriacaoField {
    return FormTextInput(
      label: 'Data de Criacao',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.dataCriacao!,
    );
  }

  Widget get _dataFechamentoField {
    return FormTextInput(
      label: 'Data de Fechamento',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.dataFechamento!,
    );
  }

  Widget get _valorEstimadoField {
    return FormSelectInput(
      label: 'Valor Estimado',
      isDisabled: _isViewPage,
      controllerValue: _controllers.valorEstimado!,
      controllerLabel: _controllers.descricao!,
      itemsCallback: (pattern) async =>
          Provider.of<MedicaoRepository>(context, listen: false)
              .select(pattern),
    );
  }

  Widget get _descricaoField {
    return FormTextInput(
      label: 'Descricao da Negociacao',
      isDisabled: _isViewPage,
      controller: _controllers.descricao!,
    );
  }

  Widget get _motivoPerdaField {
    return FormTextInput(
      label: 'Motivo da Perda (se aplicável)',
      isDisabled: _isViewPage,
      controller: _controllers.motivoPerda!,
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
    await Provider.of<NegociacaoRepository>(context, listen: false)
        .get(id)
        .then((negociacao) => _populateController(negociacao));
  }

  Future<void> _populateController(Negociacao negociacao) async {
    setState(() {
      _controllers.id!.text = negociacao.id ?? '';
      _controllers.medicaoId!.text = negociacao.medicaoId ?? '';
      _controllers.medicaoObraId!.text = negociacao.medicaoObraId ?? '';
      _controllers.clienteId!.text = negociacao.clienteId ?? '';
      _controllers.clienteNome!.text = negociacao.clienteNome ?? '';
      _controllers.statusNegociacaoId!.text =
          negociacao.statusNegociacaoId ?? '';
      _controllers.statusNegociacaoDescricao!.text =
          negociacao.statusNegociacaoDescricao ?? '';
      _controllers.funcionarioId!.text = negociacao.funcionarioId ?? '';
      _controllers.funcionarioNome!.text = negociacao.funcionarioNome ?? '';
      _controllers.dataCriacao!.text =
          (negociacao.dataCriacao ?? '').toString();
      _controllers.dataFechamento!.text =
          (negociacao.dataFechamento ?? '').toString();
      // _controllers.valorEstimado!.text = negociacao.valorEstimado ?? '';
      _controllers.descricao!.text = negociacao.descricao ?? '';
      _controllers.motivoPerda!.text = negociacao.motivoPerda ?? '';
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
        'medicaoId': _controllers.medicaoId!.text,
        'clienteId': _controllers.clienteId!.text,
        'statusNegociacaoId': _controllers.statusNegociacaoId!.text,
        'funcionarioId': _controllers.funcionarioId!.text,
        'dataCriacao': _controllers.dataCriacao!.text,
        'dataFechamento': _controllers.dataFechamento!.text,
        'valorEstimado': _controllers.valorEstimado!.text,
        'descricao': _controllers.descricao!.text,
        'motivoPerda': _controllers.motivoPerda!.text,
      };

      await Provider.of<NegociacaoRepository>(context, listen: false)
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
              Navigator.of(context).pushReplacementNamed('/negociacoes'));
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
        Navigator.of(context).pushReplacementNamed('/negociacoes');
      }
    });
  }
}
