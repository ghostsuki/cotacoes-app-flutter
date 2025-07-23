import 'package:flutter/material.dart';
import '../models/cotacao.dart';

class DetailsScreen extends StatelessWidget {
  final Cotacao cotacao;

  const DetailsScreen({super.key, required this.cotacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cotacao.moeda),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal com informações da moeda
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Text(
                        cotacao.moeda,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      cotacao.nome,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Código: ${cotacao.moeda}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Seção de cotação atual
            Text(
              'Cotação Atual',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'R\$ ${cotacao.valor.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1 ${cotacao.moeda} = R\$ ${cotacao.valor.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green.shade600,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informações adicionais
            Text(
              'Informações Adicionais',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            _buildInfoRow('Data da Cotação', cotacao.data),
            _buildInfoRow('Conversão Inversa',
                'R\$ 1,00 = ${(1 / cotacao.valor).toStringAsFixed(4)} ${cotacao.moeda}'),
            _buildInfoRow('Variação', _calcularVariacao()),

            const SizedBox(height: 32),

            // Simulador de conversão
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulador de Conversão',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('10 ${cotacao.moeda}'),
                              Text(
                                'R\$ ${(cotacao.valor * 10).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('100 ${cotacao.moeda}'),
                              Text(
                                'R\$ ${(cotacao.valor * 100).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _calcularVariacao() {
    // Simulação de variação (em um app real viria da API)
    final variacao = (cotacao.valor * 0.02 - 0.01); // Variação simulada
    final percentual = (variacao / cotacao.valor * 100);
    final sinal = percentual >= 0 ? '+' : '';
    return '$sinal${percentual.toStringAsFixed(2)}%';
  }
}
