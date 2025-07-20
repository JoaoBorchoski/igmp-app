// ignore_for_file: avoid_print

import 'package:igmp/data/repositories/operacao/pedido_repository.dart';
import 'package:igmp/data/repositories/operacao/pacote_repository.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';
import 'package:igmp/presentation/components/app_confirm_action.dart';
import 'package:igmp/presentation/components/app_form_button.dart';
import 'package:igmp/presentation/components/app_scaffold.dart';
import 'package:igmp/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:igmp/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:igmp/presentation/components/qr_scanner_page.dart';
import 'package:igmp/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class PacoteFormPage extends StatefulWidget {
  const PacoteFormPage({super.key});

  @override
  State<PacoteFormPage> createState() => _PacoteFormPageState();
}

class _PacoteFormPageState extends State<PacoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = PacoteController(
    id: TextEditingController(),
    pedidoId: TextEditingController(),
    pedidoSequencial: TextEditingController(),
    descricao: TextEditingController(),
  );

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
                .pushNamedAndRemoveUntil('/pacotes', (route) => false)
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
                    .pushNamedAndRemoveUntil('/pacotes', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: const Text('Pacotes Form'),
        showDrawer: false,
        body: formFields(context),
      ),
    );
  }

  Widget formFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pedidoIdField,
            _descricaoField,
            _cameraButtons,
            const SizedBox(height: 20),
            Expanded(
              child: _itemsTable,
            ),
            const SizedBox(height: 20),
            _actionButtons,
          ],
        ),
      ),
    );
  }

  // Form Fields

  Widget get _pedidoIdField {
    return FormSelectInput(
      label: 'Pedido',
      isDisabled: true,
      controllerValue: _controllers.pedidoId!,
      controllerLabel: _controllers.pedidoSequencial!,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<PedidoRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _descricaoField {
    return FormTextInput(
      label: 'Descricao',
      isDisabled: true,
      controller: _controllers.descricao!,
    );
  }

  Widget get _actionButtons {
    return _isViewPage
        ? const SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                  child: AppFormButton(submit: _cancel, label: 'Cancelar')),
              const SizedBox(width: 10),
              Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
            ],
          );
  }

  Widget get _itemsTable {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items do Pacote',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16), // Espaçamento vertical

        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: _controllers.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _controllers.items![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  color: Colors.blue.shade100,
                  child: ListTile(
                    title: Text(
                      item.produto ?? '',
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Text(
                      'Quantidade: ${item.quantidade ?? ''}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget get _cameraButtons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: AppFormButton(
            submit: _scanQrCode,
            label: 'Pacote Carregado',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppFormButton(
            submit: () {},
            label: 'Pacote Descarregado',
          ),
        ),
      ],
    );
  }

  // Functions

  Future<void> _loadData(String id) async {
    await Provider.of<PacoteRepository>(context, listen: false)
        .get(id)
        .then((pacote) => _populateController(pacote));
  }

  Future<void> _populateController(Pacote pacote) async {
    setState(() {
      _controllers.id!.text = pacote.id ?? '';
      _controllers.pedidoId!.text = pacote.pedidoId ?? '';
      _controllers.pedidoSequencial!.text = pacote.pedidoLabel ?? '';
      _controllers.descricao!.text = pacote.descricao ?? '';
      _controllers.items = pacote.items ?? [];
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
        'descricao': _controllers.descricao!.text,
      };

      await Provider.of<PacoteRepository>(context, listen: false)
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
              Navigator.of(context).pushReplacementNamed('/pacotes'));
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
    );
  }

  Future<void> _scanQrCode() async {
    final String? qrCodeData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (qrCodeData != null && qrCodeData.isNotEmpty) {
      Map<String, dynamic> qrCodeDataJson = json.decode(qrCodeData);
      if (qrCodeDataJson['pedidoId'] == _controllers.pedidoId!.text) {
        return showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              message: 'Confirmar o carregamento do pacote?',
              cancelButtonText: 'Não',
              confirmButtonText: 'Sim',
            );
          },
        ).then((value) async {
          if (value) {
            await Provider.of<PacoteRepository>(context, listen: false)
                .updatePacoteItem(qrCodeDataJson['pacoteId']);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacementNamed('/pacotes');
          }
        });
      }
    } else {
      print('Nenhum QR Code lido ou operação cancelada.');
    }
  }
}
