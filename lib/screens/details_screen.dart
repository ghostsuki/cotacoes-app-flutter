import 'package:flutter/material.dart';
import '../models/cotacao.dart';

class DetailsScreen extends StatefulWidget {
  final Cotacao cotacao;

  const DetailsScreen({super.key, required this.cotacao});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cotacao.moeda),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _compartilharCotacao(context);
            },
            tooltip: 'Compartilhar cotação',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        widget.cotacao.moeda,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.cotacao.nome,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Código: ${widget.cotacao.moeda}',
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
                    'R\$ ${widget.cotacao.valor.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1 ${widget.cotacao.moeda} = R\$ ${widget.cotacao.valor.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green.shade600,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Informações Adicionais',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            _buildInfoRow('Data da Cotação', widget.cotacao.data),
            _buildInfoRow('Conversão Inversa',
                'R\$ 1,00 = ${(1 / widget.cotacao.valor).toStringAsFixed(4)} ${widget.cotacao.moeda}'),
            _buildInfoRow('Variação', _calcularVariacao()),

            const SizedBox(height: 32),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade50,
                      Colors.blue.shade100,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.swap_horiz,
                      size: 48,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Quer fazer conversões?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acesse a aba "Conversor" para converter entre ${widget.cotacao.moeda} e outras moedas em tempo real!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Ir para Conversor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
    final variacao = (widget.cotacao.valor * 0.02 - 0.01);
    final percentual = (variacao / widget.cotacao.valor * 100);
    final sinal = percentual >= 0 ? '+' : '';
    return '$sinal${percentual.toStringAsFixed(2)}%';
  }

  void _compartilharCotacao(BuildContext context) {
    final textoCompartilhamento = '''
📈 Cotação ${widget.cotacao.nome} (${widget.cotacao.moeda})
💰 R\$ ${widget.cotacao.valor.toStringAsFixed(2)}
📅 Atualizado em: ${widget.cotacao.data}

🔄 Taxa: 1 ${widget.cotacao.moeda} = R\$ ${widget.cotacao.valor.toStringAsFixed(2)}

📱 Consultado via App Cotações BSF
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📤 Compartilhamento simulado'),
            const SizedBox(height: 4),
            Text(
              'Cotação de ${widget.cotacao.moeda}: R\$ ${widget.cotacao.valor.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ver texto',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('📤 Texto de compartilhamento'),
                content: SingleChildScrollView(
                  child: Text(textoCompartilhamento),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
