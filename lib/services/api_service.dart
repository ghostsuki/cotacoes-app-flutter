import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cotacao.dart';

class ApiService {
  static const String baseUrl =
      'https://api.exchangerate-api.com/v4/latest/BRL';

  static Future<List<Cotacao>> buscarCotacoes() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'CotacoesApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificar se a resposta tem a estrutura esperada
        if (!data.containsKey('rates') || !data.containsKey('date')) {
          throw Exception('Formato de resposta inválido da API');
        }

        final rates = data['rates'] as Map<String, dynamic>;
        final date = data['date'] as String;

        List<Cotacao> cotacoes = [];

        // Lista das principais moedas que queremos exibir
        final moedasPrincipais = [
          'USD',
          'EUR',
          'GBP',
          'JPY',
          'AUD',
          'CAD',
          'CHF',
          'CNY',
          'ARS',
          'UYU'
        ];

        for (String moeda in moedasPrincipais) {
          if (rates.containsKey(moeda)) {
            final rate = rates[moeda];
            if (rate is num && rate > 0) {
              // Como a API retorna quanto vale 1 BRL em outras moedas,
              // invertemos para mostrar quanto vale 1 moeda estrangeira em BRL
              double valor = 1.0 / rate.toDouble();
              cotacoes.add(Cotacao.fromJson(moeda, valor, date));
            }
          }
        }

        if (cotacoes.isEmpty) {
          throw Exception('Nenhuma cotação válida encontrada');
        }

        return cotacoes;
      } else if (response.statusCode == 429) {
        throw Exception(
            'Muitas requisições. Tente novamente em alguns minutos.');
      } else {
        throw Exception('Servidor indisponível (${response.statusCode})');
      }
    } on http.ClientException {
      throw Exception(
          'Erro de conectividade. Verifique sua conexão com a internet.');
    } on FormatException {
      throw Exception('Erro ao processar dados da API');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: A requisição demorou muito para responder');
      }
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}
