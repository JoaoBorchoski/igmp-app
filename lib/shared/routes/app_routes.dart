import 'package:flutter/material.dart';
import 'package:igmp/presentation/ui/authentication/home/home_page.dart';
import 'package:igmp/presentation/ui/authentication/signin/signin_page.dart';
import 'package:igmp/presentation/ui/comum/pais/list/pais_list_page.dart';
import 'package:igmp/presentation/ui/comum/pais/form/pais_form_page.dart';
import 'package:igmp/presentation/ui/comum/estado/list/estado_list_page.dart';
import 'package:igmp/presentation/ui/comum/estado/form/estado_form_page.dart';
import 'package:igmp/presentation/ui/comum/cidade/list/cidade_list_page.dart';
import 'package:igmp/presentation/ui/comum/cidade/form/cidade_form_page.dart';
import 'package:igmp/presentation/ui/comum/cep/list/cep_list_page.dart';
import 'package:igmp/presentation/ui/comum/cep/form/cep_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/funcionario/list/funcionario_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/funcionario/form/funcionario_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/cliente/list/cliente_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/cliente/form/cliente_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/padrao_cor/list/padrao_cor_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/padrao_cor/form/padrao_cor_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/tipo_enchimento/list/tipo_enchimento_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/tipo_enchimento/form/tipo_enchimento_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/sentido_abertura/list/sentido_abertura_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/sentido_abertura/form/sentido_abertura_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/tipo_porta/list/tipo_porta_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/tipo_porta/form/tipo_porta_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/fechadura/list/fechadura_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/fechadura/form/fechadura_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/alizar/list/alizar_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/alizar/form/alizar_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/largura_vaos/list/largura_vaos_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/largura_vaos/form/largura_vaos_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/altura_vaos/list/altura_vaos_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/altura_vaos/form/altura_vaos_form_page.dart';
import 'package:igmp/presentation/ui/configuracao/status_negociacao/list/status_negociacao_list_page.dart';
import 'package:igmp/presentation/ui/configuracao/status_negociacao/form/status_negociacao_form_page.dart';
import 'package:igmp/presentation/ui/operacao/medi%C3%A7%C3%A3o/form/medi%C3%A7%C3%A3o_form_page.dart';
import 'package:igmp/presentation/ui/operacao/medi%C3%A7%C3%A3o/list/medi%C3%A7%C3%A3o_list_page.dart';
import 'package:igmp/presentation/ui/operacao/pedido/list/pedido_list_page.dart';
import 'package:igmp/presentation/ui/operacao/pedido/form/pedido_form_page.dart';
import 'package:igmp/presentation/ui/operacao/pedido_item/list/pedido_item_list_page.dart';
import 'package:igmp/presentation/ui/operacao/pedido_item/form/pedido_item_form_page.dart';
import 'package:igmp/presentation/ui/operacao/pacote/list/pacote_list_page.dart';
import 'package:igmp/presentation/ui/operacao/pacote/form/pacote_form_page.dart';
import 'package:igmp/presentation/ui/operacao/pacote_item/list/pacote_item_list_page.dart';
import 'package:igmp/presentation/ui/operacao/pacote_item/form/pacote_item_form_page.dart';
import 'package:igmp/presentation/ui/operacao/obra/list/obra_list_page.dart';
import 'package:igmp/presentation/ui/operacao/obra/form/obra_form_page.dart';
import 'package:igmp/presentation/ui/operacao/negociacao/list/negociacao_list_page.dart';
import 'package:igmp/presentation/ui/operacao/negociacao/form/negociacao_form_page.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const AuthenticationPage(),
  '/home': (context) => const HomePage(),
  '/paises': (context) => const PaisListPage(),
  '/paises-form': (context) => const PaisFormPage(),
  '/estados': (context) => const EstadoListPage(),
  '/estados-form': (context) => const EstadoFormPage(),
  '/cidades': (context) => const CidadeListPage(),
  '/cidades-form': (context) => const CidadeFormPage(),
  '/ceps': (context) => const CepListPage(),
  '/ceps-form': (context) => const CepFormPage(),
  '/funcionarios': (context) => const FuncionarioListPage(),
  '/funcionarios-form': (context) => const FuncionarioFormPage(),
  '/clientes': (context) => const ClienteListPage(),
  '/clientes-form': (context) => const ClienteFormPage(),
  '/padroes-cores': (context) => const PadraoCorListPage(),
  '/padroes-cores-form': (context) => const PadraoCorFormPage(),
  '/tipos-enchimento': (context) => const TipoEnchimentoListPage(),
  '/tipos-enchimento-form': (context) => const TipoEnchimentoFormPage(),
  '/sentidos-abertura': (context) => const SentidoAberturaListPage(),
  '/sentidos-abertura-form': (context) => const SentidoAberturaFormPage(),
  '/tipos-porta': (context) => const TipoPortaListPage(),
  '/tipos-porta-form': (context) => const TipoPortaFormPage(),
  '/fechaduras': (context) => const FechaduraListPage(),
  '/fechaduras-form': (context) => const FechaduraFormPage(),
  '/alizares': (context) => const AlizarListPage(),
  '/alizares-form': (context) => const AlizarFormPage(),
  '/larguras-vaos': (context) => const LarguraVaosListPage(),
  '/larguras-vaos-form': (context) => const LarguraVaosFormPage(),
  '/alturas-vaos': (context) => const AlturaVaosListPage(),
  '/alturas-vaos-form': (context) => const AlturaVaosFormPage(),
  '/status-negociacoes': (context) => const StatusNegociacaoListPage(),
  '/status-negociacoes-form': (context) => const StatusNegociacaoFormPage(),
  '/pedidos': (context) => const PedidoListPage(),
  '/pedidos-form': (context) => const PedidoFormPage(),
  '/pedidos-items': (context) => const PedidoItemListPage(),
  '/pedidos-items-form': (context) => const PedidoItemFormPage(),
  '/pacotes': (context) => const PacoteListPage(),
  '/pacotes-form': (context) => const PacoteFormPage(),
  '/pacotes-items': (context) => const PacoteItemListPage(),
  '/pacotes-items-form': (context) => const PacoteItemFormPage(),
  '/obras': (context) => const ObraListPage(),
  '/obras-form': (context) => const ObraFormPage(),
  '/medicoes': (context) => const MedicaoListPage(),
  '/medicoes-form': (context) => const MedicaoFormPage(),
  '/negociacoes': (context) => const NegociacaoListPage(),
  '/negociacoes-form': (context) => const NegociacaoFormPage(),
};
