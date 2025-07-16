import 'package:igmp/presentation/providers/common/user_provider.dart';
import 'package:igmp/presentation/providers/operacao/medi%C3%A7%C3%A3o_provider.dart';

import './authentication/authentication_provider.dart';
import './comum/pais_provider.dart';
import './comum/estado_provider.dart';
import './comum/cidade_provider.dart';
import './comum/cep_provider.dart';
import './configuracao/funcionario_provider.dart';
import './configuracao/cliente_provider.dart';
import './configuracao/padrao_cor_provider.dart';
import './configuracao/tipo_enchimento_provider.dart';
import './configuracao/sentido_abertura_provider.dart';
import './configuracao/tipo_porta_provider.dart';
import './configuracao/fechadura_provider.dart';
import './configuracao/alizar_provider.dart';
import './configuracao/largura_vaos_provider.dart';
import './configuracao/altura_vaos_provider.dart';
import './configuracao/status_negociacao_provider.dart';
import './operacao/pedido_provider.dart';
import './operacao/pedido_item_provider.dart';
import './operacao/pacote_provider.dart';
import './operacao/pacote_item_provider.dart';
import './operacao/obra_provider.dart';
import './operacao/negociacao_provider.dart';

mixin AppProviders {
  static var providers = [
    ...authenticationProvider,
    ...paisProvider,
    ...estadoProvider,
    ...cidadeProvider,
    ...cepProvider,
    ...funcionarioProvider,
    ...clienteProvider,
    ...padraoCorProvider,
    ...tipoEnchimentoProvider,
    ...sentidoAberturaProvider,
    ...tipoPortaProvider,
    ...fechaduraProvider,
    ...alizarProvider,
    ...larguraVaosProvider,
    ...alturaVaosProvider,
    ...statusNegociacaoProvider,
    ...pedidoProvider,
    ...pedidoItemProvider,
    ...pacoteProvider,
    ...pacoteItemProvider,
    ...obraProvider,
    ...medicaoProvider,
    ...negociacaoProvider,
    ...userProvider,
  ];
}
