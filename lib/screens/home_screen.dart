import 'package:flutter/material.dart';
import '../models/cotacao.dart';
import '../services/api_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cotacao> cotacoes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    carregarCotacoes();
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
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações Financeiras'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarCotacoes,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando cotações...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: carregarCotacoes,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: carregarCotacoes,
      child: ListView.builder(
        itemCount: cotacoes.length,
        itemBuilder: (context, index) {
          final cotacao = cotacoes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  cotacao.moeda,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                cotacao.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Atualizado em: ${cotacao.data}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${cotacao.valor.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '1 ${cotacao.moeda}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () async {
                // Navegação para a tela de detalhes
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(cotacao: cotacao),
                  ),
                );
                // Opcional: Atualizar dados quando voltar
                // carregarCotacoes();
              },
            ),
          );
        },
      ),
    );
  }
}
