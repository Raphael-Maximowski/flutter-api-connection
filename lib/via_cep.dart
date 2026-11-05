import 'dart:convert';

import 'package:http/http.dart' as http;

class Endereco {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;
  final String ddd;

  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.ddd,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) => Endereco(
        cep: json['cep'] as String,
        logradouro: json['logradouro'] as String? ?? '',
        bairro: json['bairro'] as String? ?? '',
        cidade: json['localidade'] as String? ?? '',
        uf: json['uf'] as String? ?? '',
        ddd: json['ddd'] as String? ?? '',
      );
}

class CepException implements Exception {
  final String mensagem;
  const CepException(this.mensagem);

  @override
  String toString() => mensagem;
}

Future<Endereco> buscarCep(String cep, {http.Client? client}) async {
  final url = Uri.https('viacep.com.br', '/ws/$cep/json/');
  final resposta = await (client?.get(url) ?? http.get(url));

  if (resposta.statusCode == 400) throw const CepException('CEP inválido');
  if (resposta.statusCode != 200) {
    throw CepException('Erro ao consultar o ViaCEP (HTTP ${resposta.statusCode})');
  }

  final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
  if (json.containsKey('erro')) throw const CepException('CEP não encontrado');
  return Endereco.fromJson(json);
}
