import 'dart:convert';

import 'package:cep_app/via_cep.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Client responde(int status, String corpo) =>
    MockClient((_) async => http.Response.bytes(utf8.encode(corpo), status));

void main() {
  test('CEP encontrado vira Endereco', () async {
    final endereco = await buscarCep(
      '01001000',
      client: responde(200, '{"cep":"01001-000","logradouro":"Praça da Sé","bairro":"Sé","localidade":"São Paulo","uf":"SP","ddd":"11"}'),
    );

    expect(endereco.logradouro, 'Praça da Sé');
    expect(endereco.cidade, 'São Paulo');
    expect(endereco.uf, 'SP');
  });

  test('CEP inexistente lança "CEP não encontrado"', () {
    expect(
      buscarCep('99999999', client: responde(200, '{"erro": "true"}')),
      throwsA(isA<CepException>().having((e) => e.mensagem, 'mensagem', 'CEP não encontrado')),
    );
  });

  test('CEP mal formatado lança "CEP inválido"', () {
    expect(
      buscarCep('123', client: responde(400, '')),
      throwsA(isA<CepException>().having((e) => e.mensagem, 'mensagem', 'CEP inválido')),
    );
  });
}
