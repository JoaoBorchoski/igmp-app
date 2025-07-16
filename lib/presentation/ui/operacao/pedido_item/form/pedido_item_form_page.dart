import 'package:igmp/data/repositories/operacao/pedido_repository.dart';
import 'package:igmp/data/repositories/operacao/pedido_item_repository.dart';
import 'package:igmp/domain/models/operacao/pedido_item.dart';
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

class PedidoItemFormPage extends StatefulWidget {
  const PedidoItemFormPage({super.key});

  @override
  State<PedidoItemFormPage> createState() => _PedidoItemFormPageState();
}

class _PedidoItemFormPageState extends State<PedidoItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = PedidoItemController(
    id: TextEditingController(),
    pedidoId: TextEditingController(),
    pedidoSequencial: TextEditingController(),
    produto: TextEditingController(),
    quantidade: TextEditingController(),
    corEtiqueta: TextEditingController(),
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
                .pushNamedAndRemoveUntil('/pedidos-items', (route) => false)
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
                    .pushNamedAndRemoveUntil('/pedidos-items', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('PedidosItems Form'),
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
              _pedidoIdField,
              _produtoField,
              _quantidadeField,
              _corEtiquetaField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _pedidoIdField {
    return FormSelectInput(
      label: 'Pedido',
      isDisabled: _isViewPage,
      controllerValue: _controllers.pedidoId!,
      controllerLabel: _controllers.pedidoSequencial!,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<PedidoRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _produtoField {
    return FormTextInput(
      label: 'Produto',
      isDisabled: _isViewPage,
      controller: _controllers.produto!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _quantidadeField {
    return FormTextInput(
      label: 'Quantidade',
      type: TextInputTypes.number,
      isDisabled: _isViewPage,
      controller: _controllers.quantidade!,
    );
  }

  Widget get _corEtiquetaField {
    return FormTextInput(
      label: 'Cor da Etiqueta',
      isDisabled: _isViewPage,
      controller: _controllers.corEtiqueta!,
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
    await Provider.of<PedidoItemRepository>(context, listen: false)
        .get(id)
        .then((pedidoItem) => _populateController(pedidoItem));
  }

  Future<void> _populateController(PedidoItem pedidoItem) async {
    setState(() {
      _controllers.id!.text = pedidoItem.id ?? '';
      _controllers.pedidoId!.text = pedidoItem.pedidoId ?? '';
      _controllers.pedidoSequencial!.text = pedidoItem.pedidoSequencial ?? '';
      _controllers.produto!.text = pedidoItem.produto ?? '';
      _controllers.quantidade!.text = (pedidoItem.quantidade ?? '').toString();
      _controllers.corEtiqueta!.text = pedidoItem.corEtiqueta ?? '';
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
        'pedidoId': _controllers.pedidoId!.text,
        'produto': _controllers.produto!.text,
        'quantidade': _controllers.quantidade!.text,
        'corEtiqueta': _controllers.corEtiqueta!.text,
      };

      await Provider.of<PedidoItemRepository>(context, listen: false)
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
              Navigator.of(context).pushReplacementNamed('/pedidos-items'));
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
        Navigator.of(context).pushReplacementNamed('/pedidos-items');
      }
    });
  }
}
