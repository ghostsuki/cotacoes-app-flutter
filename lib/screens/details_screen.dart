import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cotacao.dart';

class DetailsScreen extends StatefulWidget {
  final Cotacao cotacao;

  const DetailsScreen({super.key, required this.cotacao});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _realController = TextEditingController();
  bool _isConvertingFromForeign =
      true; // true = moeda estrangeira -> real, false = real -> moeda estrangeira
  bool _isUpdating = false; // Flag para evitar loops infinitos

  @override
  void initState() {
    super.initState();
    _valorController.text = '1.00';
    _realController.text = widget.cotacao.valor.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _valorController.dispose();
    _realController.dispose();
    super.dispose();
  }

  // Atualiza conversão de moeda estrangeira para real
  void _updateConversionFromForeign() {
    if (_isUpdating) return;

    final valor =
        double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0;
    final resultado = valor * widget.cotacao.valor;

    _isUpdating = true;
    _realController.text = resultado.toStringAsFixed(2);
    _isUpdating = false;
  }

  // Atualiza conversão de real para moeda estrangeira
  void _updateConversionFromReal() {
    if (_isUpdating) return;

    final valor =
        double.tryParse(_realController.text.replaceAll(',', '.')) ?? 0.0;
    final resultado = valor / widget.cotacao.valor;

    _isUpdating = true;
    _valorController.text = resultado.toStringAsFixed(4);
    _isUpdating = false;
  }

  // Método para trocar o modo de conversão
  void _switchConversionMode() {
    _isUpdating = true;

    if (_isConvertingFromForeign) {
      // Mudou para: moeda estrangeira -> real
      // Recalcula o real baseado no valor da moeda estrangeira atual
      _updateConversionFromForeign();
    } else {
      // Mudou para: real -> moeda estrangeira
      // Recalcula a moeda estrangeira baseado no valor real atual
      _updateConversionFromReal();
    }

    _isUpdating = false;
  }

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

            // Informações adicionais
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

            // Simulador interativo de conversão
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calculate, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Simulador de Conversão',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Toggle para direção da conversão
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isConvertingFromForeign = true;
                                });
                                _switchConversionMode();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _isConvertingFromForeign
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${widget.cotacao.moeda} → BRL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isConvertingFromForeign
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isConvertingFromForeign = false;
                                });
                                _switchConversionMode();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: !_isConvertingFromForeign
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'BRL → ${widget.cotacao.moeda}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !_isConvertingFromForeign
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campos de conversão
                    Row(
                      children: [
                        // Campo de entrada
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isConvertingFromForeign
                                    ? widget.cotacao.moeda
                                    : 'BRL',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _isConvertingFromForeign
                                    ? _valorController
                                    : _realController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  prefixText:
                                      _isConvertingFromForeign ? '' : 'R\$ ',
                                  hintText: '0.00',
                                ),
                                onChanged: (value) {
                                  // Força a atualização quando o usuário digita
                                  if (_isConvertingFromForeign) {
                                    _updateConversionFromForeign();
                                  } else {
                                    _updateConversionFromReal();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        // Ícone de conversão
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.swap_horiz,
                              color: Colors.blue.shade600,
                              size: 24,
                            ),
                          ),
                        ),

                        // Campo de resultado
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isConvertingFromForeign
                                    ? 'BRL'
                                    : widget.cotacao.moeda,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _isConvertingFromForeign
                                      ? 'R\$ ${_realController.text}'
                                      : _valorController.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Botões de valores rápidos
                    Text(
                      'Valores Rápidos:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildQuickValueChip('1'),
                        _buildQuickValueChip('10'),
                        _buildQuickValueChip('100'),
                        _buildQuickValueChip('1000'),
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
    final variacao = (widget.cotacao.valor * 0.02 - 0.01); // Variação simulada
    final percentual = (variacao / widget.cotacao.valor * 100);
    final sinal = percentual >= 0 ? '+' : '';
    return '$sinal${percentual.toStringAsFixed(2)}%';
  }

  void _compartilharCotacao(BuildContext context) {
    // Texto que seria compartilhado
    final textoCompartilhamento = '''
📈 Cotação ${widget.cotacao.nome} (${widget.cotacao.moeda})
💰 R\$ ${widget.cotacao.valor.toStringAsFixed(2)}
📅 Atualizado em: ${widget.cotacao.data}

🔄 Simulador: 1 ${widget.cotacao.moeda} = R\$ ${widget.cotacao.valor.toStringAsFixed(2)}

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

  Widget _buildQuickValueChip(String value) {
    return GestureDetector(
      onTap: () {
        if (_isConvertingFromForeign) {
          _valorController.text = value;
          _updateConversionFromForeign();
        } else {
          _realController.text = value;
          _updateConversionFromReal();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
