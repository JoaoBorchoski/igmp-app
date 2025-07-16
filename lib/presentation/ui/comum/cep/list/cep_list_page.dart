import 'package:igmp/domain/models/comum/cep.dart';
import 'package:igmp/presentation/components/app_confirm_action.dart';
import 'package:igmp/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:igmp/data/repositories/comum/cep_repository.dart';
import 'package:igmp/presentation/components/app_scaffold.dart';
import 'package:igmp/presentation/components/app_search_bar.dart';
import 'cep_list_widget.dart';

class CepListPage extends StatefulWidget {
  const CepListPage({Key? key}) : super(key: key);

  @override
  State<CepListPage> createState() => _CepListPageState();
}

class _CepListPageState extends State<CepListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Cep> _cards;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Cep> cepList = [];
    await Provider.of<CepRepository>(context, listen: false).list(_query, _pageSize, _page, ['ASC', 'ASC']).then((value) {
        cepList = value;
        setState(() {
          _isLastPage = cepList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(cepList);
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
            builder: (context) => ConfirmActionWidget(message: 'Ocorreu um erro ao carregar as ceps.', cancelButtonText: 'Tentar novamente'))
        .then((value) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (_hasError) {
        _hasErrorDialog();
      }
    }
    return WillPopScope(onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(title: Text('Ceps'),
        route: '/ceps-form',
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              AppSearchBar(onSearch: (q) {
                  setState(() {
                    _query = q;
                    _page = 1;
                    _cards.clear();
                    _fetchData();
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  child: _cards.isEmpty
                  ? AppNoData()
                  : ListView.builder(itemCount: _cards.length + (_isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == _cards.length - _nextPageTrigger && !_isLastPage) {
                          _fetchData();
                        }

                        if (index == _cards.length) {
                          if (_hasError) {
                            _hasErrorDialog();
                          } else {
                            return const Center(
                              child: Padding(padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }
                        final Cep card = _cards[index];
                        return CepListWidget(card);
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
