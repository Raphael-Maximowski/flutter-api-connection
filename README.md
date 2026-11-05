<img src="assets/icon.svg" width="64" height="64" alt="">

# Consulta CEP

Aplicativo Flutter que consulta um CEP na API pública [ViaCEP](https://viacep.com.br) e mostra o endereço na tela. Roda no navegador Chrome.

Trabalho da disciplina de desenvolvimento mobile. O objetivo é praticar requisições HTTP, JSON, métodos assíncronos e apresentação de dados, consumindo uma API REST diferente da Invertexto usada em aula.

## Como funciona

1. O usuário digita um CEP com 8 dígitos e toca em **Buscar**.
2. O app faz um `GET https://viacep.com.br/ws/{cep}/json/`.
3. A resposta JSON vira um objeto `Endereco`.
4. A tela mostra o logradouro, o bairro, a cidade, a UF, o DDD e o CEP.

| Conceito | Onde está no código |
|---|---|
| Requisição HTTP | `http.get` em `buscarCep` (`lib/via_cep.dart`) |
| JSON | `jsonDecode` e `Endereco.fromJson` (`lib/via_cep.dart`) |
| Métodos assíncronos | `Future<Endereco>`, `async`/`await` e `FutureBuilder` (`lib/main.dart`) |
| Apresentação dos dados | `EnderecoCard`, indicador de carregamento e mensagens de erro (`lib/main.dart`) |

### Respostas da API tratadas

| Situação | Resposta do ViaCEP | O que o app mostra |
|---|---|---|
| CEP existe, por exemplo `01001000` | HTTP 200 com o endereço | Cartão com o endereço |
| CEP não existe, por exemplo `99999999` | HTTP 200 com `{"erro": "true"}` | "CEP não encontrado" |
| CEP com formato inválido | HTTP 400 | "CEP inválido" |
| Menos de 8 dígitos digitados | Nenhuma requisição é feita | "Digite um CEP com 8 dígitos" |

## Pré-requisitos

- Flutter 3.x instalado (`flutter --version`)
- Google Chrome
- Internet, porque o app consulta o ViaCEP em tempo real

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

## Como testar

```bash
flutter test
```

Os testes ficam em `test/via_cep_test.dart`. Eles usam o `MockClient` do pacote `http` para simular as três respostas do ViaCEP sem acessar a internet.

## Estrutura

```
lib/
  main.dart      Tela de consulta e cartão do endereço
  via_cep.dart   Modelo Endereco, CepException e a função buscarCep
test/
  via_cep_test.dart
```
