import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'via_cep.dart';

void main() => runApp(const CepApp());

class CepApp extends StatelessWidget {
  const CepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const ConsultaCepPage(),
    );
  }
}

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final _cepController = TextEditingController();
  Future<Endereco>? _busca;
  String? _erroDigitacao;

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  void _buscar() {
    final cep = _cepController.text;
    final valido = cep.length == 8;
    setState(() {
      _erroDigitacao = valido ? null : 'Digite um CEP com 8 dígitos';
      _busca = valido ? buscarCep(cep) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta CEP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: '01001000',
                errorText: _erroDigitacao,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _buscar,
              icon: const Icon(Icons.search),
              label: const Text('Buscar'),
            ),
            const SizedBox(height: 24),
            if (_busca != null)
              FutureBuilder<Endereco>(
                future: _busca,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    );
                  }
                  return EnderecoCard(endereco: snapshot.data!);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class EnderecoCard extends StatelessWidget {
  final Endereco endereco;
  const EnderecoCard({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(leading: const Icon(Icons.place), title: Text(endereco.logradouro), subtitle: const Text('Logradouro')),
          ListTile(leading: const Icon(Icons.holiday_village), title: Text(endereco.bairro), subtitle: const Text('Bairro')),
          ListTile(leading: const Icon(Icons.location_city), title: Text('${endereco.cidade}/${endereco.uf}'), subtitle: const Text('Cidade')),
          ListTile(leading: const Icon(Icons.phone), title: Text(endereco.ddd), subtitle: const Text('DDD')),
          ListTile(leading: const Icon(Icons.markunread_mailbox), title: Text(endereco.cep), subtitle: const Text('CEP')),
        ],
      ),
    );
  }
}
