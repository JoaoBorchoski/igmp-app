import 'dart:convert';

import 'package:igmp/domain/models/operacao/espelho_carga.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';
import 'package:igmp/presentation/components/app_confirm_action.dart';
import 'package:igmp/presentation/components/app_form_button.dart';
import 'package:igmp/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:igmp/presentation/components/qr_scanner_page.dart';
import 'package:provider/provider.dart';
import 'package:igmp/data/repositories/operacao/pacote_repository.dart';
import 'package:igmp/presentation/components/app_scaffold.dart';
import 'package:igmp/presentation/components/app_search_bar.dart';
import 'pacote_list_widget.dart';
import 'espelho_carga_list_widget.dart';

class PacoteListPage extends StatefulWidget {
  const PacoteListPage({Key? key}) : super(key: key);

  @override
  State<PacoteListPage> createState() => _PacoteListPageState();
}

class _PacoteListPageState extends State<PacoteListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Pacote> _cards;
  late List<EspelhoCarga> _espelhosCarga;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _espelhosCarga = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<EspelhoCarga> espelhoCargaList = [];
    await Provider.of<PacoteRepository>(context, listen: false)
        .listEspelhosCarga(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        espelhoCargaList = value;
        setState(() {
          _isLastPage = espelhoCargaList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _espelhosCarga.addAll(espelhoCargaList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  void _hasErrorDialog() async {
    await showDialog(
        context: context,
        builder: (context) => ConfirmActionWidget(
            message: 'Ocorreu um erro ao carregar as pacotes.',
            cancelButtonText: 'Tentar novamente')).then((value) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _fetchData();
      });
    });
  }

  Widget get _cameraButtons {
    return Row(
      children: [
        Expanded(
          child: AppFormButton(
            submit: () async {
              await _scanQrCode().then((value) {
                if (value.isNotEmpty) {
                  Navigator.of(context)
                      .pushReplacementNamed('/pacotes-form', arguments: value);
                }
              });
            },
            label: 'Ler QR Code',
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _scanQrCode() async {
    final String? qrCodeData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (qrCodeData != null && qrCodeData.isNotEmpty) {
      try {
        Map<String, dynamic> qrCodeDataJson = json.decode(qrCodeData);
        Map<String, dynamic> data = {
          'id': qrCodeDataJson['pacoteId'],
          'view': true
        };

        return data;
      } catch (e) {
        return {};
      }
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_espelhosCarga.isEmpty) {
      if (_isLoading) {
        return AppScaffold(
          title: Text('Cargas'),
          route: null,
          showDrawer: true,
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (_hasError) {
        _hasErrorDialog();
        return AppScaffold(
          title: Text('Cargas'),
          route: null,
          showDrawer: true,
          body: Center(child: Text('Erro ao carregar dados')),
        );
      }
    }
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(
        title: Text('Cargas'),
        route: null,
        showDrawer: true,
        // body: Column(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              AppSearchBar(
                onSearch: (q) {
                  setState(() {
                    _query = q;
                    _page = 1;
                    _espelhosCarga.clear();
                    _fetchData();
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  child: _espelhosCarga.isEmpty
                      ? AppNoData()
                      : ListView.builder(
                          itemCount:
                              _espelhosCarga.length + (_isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index ==
                                    _espelhosCarga.length - _nextPageTrigger &&
                                !_isLastPage) {
                              _fetchData();
                            }

                            if (index == _espelhosCarga.length) {
                              if (_hasError) {
                                _hasErrorDialog();
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            }

                            final EspelhoCarga espelhoCarga =
                                _espelhosCarga[index];
                            return EspelhoCargaListWidget(espelhoCarga);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
