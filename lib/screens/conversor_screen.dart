import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cotacao.dart';
import '../services/api_service.dart';

class ConversorScreen extends StatefulWidget {
  const ConversorScreen({super.key});

  @override
  State<ConversorScreen> createState() => _ConversorScreenState();
}

class _ConversorScreenState extends State<ConversorScreen> {
  List<Cotacao> cotacoes = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _resultadoController = TextEditingController();

  String? moedaBase;
  String? moedaDestino;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _valorController.text = '1.00';
    carregarCotacoes();
  }

  @override
  void dispose() {
    _valorController.dispose();
    _resultadoController.dispose();
    super.dispose();
  }

  Future<void> carregarCotacoes() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final cotacoesCarregadas = await ApiService.buscarCotacoes();

      setState(() {
        cotacoes = cotacoesCarregadas;
        isLoading = false;

        if (moedaBase == null && cotacoes.isNotEmpty) {
          moedaBase = 'USD';
          moedaDestino = 'BRL';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _atualizarConversao() {
    if (moedaBase == null || moedaDestino == null) return;

    final valor =
        double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0;

    setState(() {
      if (moedaBase == 'BRL' && moedaDestino == 'BRL') {
        _resultadoController.text = valor.toStringAsFixed(2);
      } else if (moedaBase == 'BRL') {
        try {
          final cotacao = cotacoes.firstWhere((c) => c.moeda == moedaDestino);
          final resultado = valor / cotacao.valor;
          _resultadoController.text = resultado.toStringAsFixed(4);
        } catch (e) {
          _resultadoController.text = '0.0000';
        }
      } else if (moedaDestino == 'BRL') {
        try {
          final cotacao = cotacoes.firstWhere((c) => c.moeda == moedaBase);
          final resultado = valor * cotacao.valor;
          _resultadoController.text = resultado.toStringAsFixed(2);
        } catch (e) {
          _resultadoController.text = '0.00';
        }
      } else {
        try {
          final cotacaoBase = cotacoes.firstWhere((c) => c.moeda == moedaBase);
          final cotacaoDestino =
              cotacoes.firstWhere((c) => c.moeda == moedaDestino);

          final valorEmBRL = valor * cotacaoBase.valor;
          final resultado = valorEmBRL / cotacaoDestino.valor;
          _resultadoController.text = resultado.toStringAsFixed(4);
        } catch (e) {
          _resultadoController.text = '0.0000';
        }
      }
    });
  }

  void _trocarMoedas() {
    setState(() {
      final temp = moedaBase;
      moedaBase = moedaDestino;
      moedaDestino = temp;

      _resultadoController.text = '';
    });
  }

  List<String> _obterMoedasDisponiveis() {
    List<String> moedas = ['BRL'];
    moedas.addAll(cotacoes.map((c) => c.moeda));
    return moedas;
  }

  String _obterNomeMoeda(String codigo) {
    if (codigo == 'BRL') return 'Real Brasileiro';
    try {
      return cotacoes.firstWhere((c) => c.moeda == codigo).nome;
    } catch (e) {
      return codigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade50,
          ],
          stops: const [0.0, 0.3],
        ),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Carregando cotações...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar cotações',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: carregarCotacoes,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.swap_horiz,
                  size: 48,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(height: 12),
                Text(
                  'Conversor de Moedas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Converta entre mais de 10 moedas em tempo real',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Seletores de moeda
          Row(
            children: [
              Expanded(
                child: _buildSeletorMoeda(
                  titulo: 'De',
                  moedaSelecionada: moedaBase,
                  onChanged: (novaM) {
                    setState(() {
                      moedaBase = novaM;
                      // Limpar resultado quando mudar moeda
                      _resultadoController.text = '';
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _trocarMoedas,
                    icon: Icon(
                      Icons.swap_horiz,
                      color: Colors.blue.shade600,
                      size: 24,
                    ),
                    tooltip: 'Trocar moedas',
                  ),
                ),
              ),
              Expanded(
                child: _buildSeletorMoeda(
                  titulo: 'Para',
                  moedaSelecionada: moedaDestino,
                  onChanged: (novaM) {
                    setState(() {
                      moedaDestino = novaM;
                      // Limpar resultado quando mudar moeda
                      _resultadoController.text = '';
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Campos de conversão
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Valores',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Campo de entrada
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            moedaBase ?? 'USD',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${_obterNomeMoeda(moedaBase ?? 'USD')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _valorController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: '0.00',
                          prefixIcon: Icon(Icons.attach_money,
                              color: Colors.blue.shade600),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botão Converter
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _atualizarConversao,
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text(
                        'Converter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ícone de conversão
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo de resultado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            moedaDestino ?? 'BRL',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${_obterNomeMoeda(moedaDestino ?? 'BRL')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up,
                                color: Colors.green.shade600),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _resultadoController.text.isEmpty
                                    ? '0.00'
                                    : _resultadoController.text,
                                style: TextStyle(
                                  fontSize: 18,
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Valores rápidos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valores Rápidos',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['1', '5', '10', '50', '100', '500', '1000']
                        .map((valor) => _buildBotaoValorRapido(valor))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Informações da cotação
          if (moedaBase != null && moedaDestino != null) _buildInfoCotacao(),
        ],
      ),
    );
  }

  Widget _buildSeletorMoeda({
    required String titulo,
    required String? moedaSelecionada,
    required Function(String?) onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: moedaSelecionada,
                  isExpanded: true,
                  hint: const Text('Selecionar'),
                  items: _obterMoedasDisponiveis().map((moeda) {
                    return DropdownMenuItem<String>(
                      value: moeda,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                moeda,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  moeda,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _obterNomeMoeda(moeda),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoValorRapido(String valor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _valorController.text = valor;
          // Limpar resultado quando usar valor rápido
          _resultadoController.text = '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          valor,
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCotacao() {
    if (moedaBase == null || moedaDestino == null) {
      return const SizedBox.shrink();
    }

    // Só mostra informações se já foi feita uma conversão
    if (_resultadoController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calcular taxa de conversão
    String taxaConversao = '';
    String taxaInversa = '';

    if (moedaBase == 'BRL' && moedaDestino == 'BRL') {
      taxaConversao = '1 BRL = 1 BRL';
      taxaInversa = '1 BRL = 1 BRL';
    } else if (moedaBase == 'BRL') {
      final cotacao = cotacoes.firstWhere((c) => c.moeda == moedaDestino!);
      final taxa = 1 / cotacao.valor;
      taxaConversao = '1 BRL = ${taxa.toStringAsFixed(4)} $moedaDestino';
      taxaInversa = '1 $moedaDestino = ${cotacao.valor.toStringAsFixed(4)} BRL';
    } else if (moedaDestino == 'BRL') {
      final cotacao = cotacoes.firstWhere((c) => c.moeda == moedaBase!);
      taxaConversao = '1 $moedaBase = ${cotacao.valor.toStringAsFixed(4)} BRL';
      taxaInversa =
          '1 BRL = ${(1 / cotacao.valor).toStringAsFixed(4)} $moedaBase';
    } else {
      final cotacaoBase = cotacoes.firstWhere((c) => c.moeda == moedaBase!);
      final cotacaoDestino =
          cotacoes.firstWhere((c) => c.moeda == moedaDestino!);

      final taxa = cotacaoBase.valor / cotacaoDestino.valor;
      final taxaInv = cotacaoDestino.valor / cotacaoBase.valor;

      taxaConversao = '1 $moedaBase = ${taxa.toStringAsFixed(4)} $moedaDestino';
      taxaInversa =
          '1 $moedaDestino = ${taxaInv.toStringAsFixed(4)} $moedaBase';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Informações da Cotação',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up,
                          size: 16, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          taxaConversao,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.trending_down,
                          size: 16, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          taxaInversa,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Atualizado: ${cotacoes.isNotEmpty ? cotacoes.first.data : 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
