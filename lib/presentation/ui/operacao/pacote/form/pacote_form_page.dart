// ignore_for_file: avoid_print

import 'package:igmp/data/repositories/operacao/pedido_repository.dart';
import 'package:igmp/data/repositories/operacao/pacote_repository.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';
import 'package:igmp/domain/models/operacao/espelho_carga.dart';
import 'package:igmp/domain/models/operacao/espelho_carga_item.dart';
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
  final _itemsScrollController = ScrollController();
  EspelhoCarga? _espelhoCarga;

  @override
  void dispose() {
    _itemsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: PacoteFormPage build chamado.');
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    print('DEBUG: Args recebidos: $args');
    print('DEBUG: _dataIsLoaded: $_dataIsLoaded');

    if (args != null && !_dataIsLoaded) {
      print('DEBUG: Carregando dados com id: ${args['id']}');
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    } else if (_dataIsLoaded) {
      print('DEBUG: Dados já carregados. _dataIsLoaded: $_dataIsLoaded');
    } else {
      print('DEBUG: Args nulos ou _dataIsLoaded já true.');
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
        title: const Text('Espelho de Carga'),
        showDrawer: false,
        body: formFields(context),
      ),
    );
  }

  Widget formFields(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _placaField,
              _motoristaField,
              _loteField,
              _descricaoEspelhoField,
              _cameraButtons,
              const SizedBox(height: 20),
              _espelhoCargaItemsTable,
              // _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _confirmarCarregamentoField {
    return AppFormButton(
      submit: _confirmarCarregamento,
      label: 'Confirmar Carregamento',
    );
  }

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
      controller: _controllers.descricao ?? TextEditingController(),
    );
  }

  Widget get _actionButtons {
    return _isViewPage
        ? const SizedBox.shrink()
        : Row(
            children: [
              AppFormButton(submit: _cancel, label: 'Cancelar'),
              const SizedBox(width: 10),
              AppFormButton(submit: _submit, label: 'Salvar'),
            ],
          );
  }

  Widget get _placaField {
    return FormTextInput(
      label: 'Placa',
      isDisabled: true,
      controller: TextEditingController(text: _espelhoCarga?.placa ?? ''),
    );
  }

  Widget get _motoristaField {
    return FormTextInput(
      label: 'Motorista',
      isDisabled: true,
      controller: TextEditingController(text: _espelhoCarga?.motorista ?? ''),
    );
  }

  Widget get _loteField {
    return FormTextInput(
      label: 'Lote',
      isDisabled: true,
      controller: TextEditingController(text: _espelhoCarga?.lote ?? ''),
    );
  }

  Widget get _descricaoEspelhoField {
    return FormTextInput(
      label: 'Descrição',
      isDisabled: true,
      controller: TextEditingController(text: _espelhoCarga?.descricao ?? ''),
    );
  }

  Widget get _espelhoCargaItemsTable {
    if (_espelhoCarga?.espelhoCargaItems == null ||
        _espelhoCarga!.espelhoCargaItems!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itens do Espelho de Carga',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _espelhoCarga!.espelhoCargaItems!.length,
          itemBuilder: (context, index) {
            final item = _espelhoCarga!.espelhoCargaItems![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2.0,
              child: ExpansionTile(
                title: Text(
                  item.descricao ?? 'Sem descrição',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  if (item.items != null && item.items!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildItemsTable(item.items!),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Nenhum item encontrado'),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemsTable(List<EspelhoCargaItemProduto> items) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Colors.grey),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Produto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Quantidade',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        ...items.map((item) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.produtoNome ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.quantidade ?? '',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget get _cameraButtons {
    return Row(
      children: [
        AppFormButton(
          submit: () async {
            await _scanQrCode().then((value) {});
          },
          label: 'Ler QR Code',
        ),
      ],
    );
  }

  // Functions

  Future<void> _loadData(String id) async {
    print('DEBUG: _loadData chamado com id: $id');
    try {
      await Provider.of<PacoteRepository>(context, listen: false)
          .getEspelhoCarga(id)
          .then((espelhoCarga) {
        if (mounted) {
          print('DEBUG: EspelhoCarga retornado do repo: $espelhoCarga');
          print('DEBUG: EspelhoCarga descricao: ${espelhoCarga.descricao}');
          print('DEBUG: EspelhoCarga id: ${espelhoCarga.id}');
          print('DEBUG: EspelhoCarga pedidoId: ${espelhoCarga.pedidoId}');
          print(
              'DEBUG: EspelhoCarga items: ${espelhoCarga.espelhoCargaItems?.length ?? 0}');
          _populateController(espelhoCarga);
        }
      });
    } catch (e) {
      print('ERRO: Falha ao carregar dados do espelho de carga: $e');
    }
  }

  Future<void> _populateController(EspelhoCarga espelhoCarga) async {
    print(
        'DEBUG: _populateController chamado com espelhoCarga: ${espelhoCarga.id}');
    if (mounted) {
      setState(() {
        _espelhoCarga = espelhoCarga;
        _controllers.id!.text = espelhoCarga.id ?? '';
        _controllers.pedidoId!.text = espelhoCarga.pedidoId ?? '';
        print(
            'DEBUG: Total de espelhoCargaItems carregados: ${espelhoCarga.espelhoCargaItems?.length ?? 0}');
      });
    }
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

      print('------------------');
      print('DEBUG: qrCodeDataJson: $qrCodeDataJson');
      print('------------------');

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
          final bool validado =
              await Provider.of<PacoteRepository>(context, listen: false)
                  .updatePacoteItem(
                      qrCodeDataJson['pacoteId'], _controllers.id!.text);

          if (validado) {
            return showDialog(
              context: context,
              builder: (context) {
                return ConfirmActionWidget(
                  message: 'Carregamento confirmado com sucesso!',
                  cancelButtonText: 'Ok',
                );
              },
            );
          } else {
            return showDialog(
              context: context,
              builder: (context) {
                return ConfirmActionWidget(
                  message: 'Pacote não pertence a essa carga!',
                  cancelButtonText: 'Ok',
                );
              },
            );
          }
        }
      });
      // if (qrCodeDataJson['pedidoId'] == _controllers.pedidoId!.text) {}
    } else {
      print('Nenhum QR Code lido ou operação cancelada.');
    }
  }

  Future<void> _confirmarCarregamento() async {
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
      // if (value) {
      //   await Provider.of<PacoteRepository>(context, listen: false)
      //       .updatePacoteItem(_controllers.id!.text);
      //   // ignore: use_build_context_synchronously
      //   Navigator.of(context).pushReplacementNamed('/pacotes');
      // }
    });
  }
}
