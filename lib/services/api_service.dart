import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cotacao.dart';

class ApiService {
  static const String baseUrl =
      'https://api.exchangerate-api.com/v4/latest/BRL';

  static Future<List<Cotacao>> buscarCotacoes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
            // Como a API retorna quanto vale 1 BRL em outras moedas,
            // invertemos para mostrar quanto vale 1 moeda estrangeira em BRL
            double valor = 1.0 / rates[moeda];
            cotacoes.add(Cotacao.fromJson(moeda, valor, date));
          }
        }

        return cotacoes;
      } else {
        throw Exception('Falha ao carregar cotações');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
