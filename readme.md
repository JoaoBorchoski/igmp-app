# igmp

## Requisitos necessários

Para que a aplicacao possa ser executada e testada em ambiente local de desenvolvimento, alguns itens de software devem estar previamente instalados.

-   Flutter, rode o comando `flutter doctor` no terminal para saber se está tudo certo.

## Requisitos opcionais

-   Android Studio ou algum emulador do gênero.

## Como executar a aplicacao

1. Abra seu emulador no computador.
2. Abra a pasta do projeto em algum terminal
3. Caso vá utilizar alguma API, certifique-se que o endereco da API está correto no arquivo `lib\shared\config\app_constants.dart`
4. Rode o comando `flutter pub get` para baixar todas as libs.
5. Rode o comando `flutter create .` para criar as pastas necessárias.
6. Rode o comando `flutter emulators` para verificar os emuladores disponíveis, se tudo ocorrer corretamente o seu emulador que está aberto irá ser listado.
7. Rode o comando `flutter run` para comecar a rodar seu código no emulador.
