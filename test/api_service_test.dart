import 'package:flutter_test/flutter_test.dart';
import 'package:cotacoes_app/models/cotacao.dart';

void main() {
  group('Cotacao Model Tests', () {
    test('Deve criar uma cotação com dados válidos', () {
      const moeda = 'USD';
      const valor = 5.25;
      const data = '2024-01-15';

      final cotacao = Cotacao.fromJson(moeda, valor, data);

      expect(cotacao.moeda, equals('USD'));
      expect(cotacao.nome, equals('Dólar Americano'));
      expect(cotacao.valor, equals(5.25));
      expect(cotacao.data, equals('2024-01-15'));
    });

    test('Deve retornar nome correto para moedas conhecidas', () {
      final cotacaoUSD = Cotacao.fromJson('USD', 5.0, '2024-01-15');
      final cotacaoEUR = Cotacao.fromJson('EUR', 6.0, '2024-01-15');
      final cotacaoGBP = Cotacao.fromJson('GBP', 7.0, '2024-01-15');

      expect(cotacaoUSD.nome, equals('Dólar Americano'));
      expect(cotacaoEUR.nome, equals('Euro'));
      expect(cotacaoGBP.nome, equals('Libra Esterlina'));
    });

    test('Deve retornar código da moeda para moedas desconhecidas', () {
      final cotacao = Cotacao.fromJson('XYZ', 1.0, '2024-01-15');

      expect(cotacao.nome, equals('XYZ'));
      expect(cotacao.moeda, equals('XYZ'));
    });

    test('Deve manter precisão dos valores decimais', () {
      final cotacao = Cotacao.fromJson('USD', 5.12345, '2024-01-15');

      expect(cotacao.valor, equals(5.12345));
    });
  });

  group('Cotacao Formatting Tests', () {
    test('Deve formatar valor com 2 casas decimais', () {
      final cotacao = Cotacao.fromJson('USD', 5.12345, '2024-01-15');

      final valorFormatado = cotacao.valor.toStringAsFixed(2);

      expect(valorFormatado, equals('5.12'));
    });

    test('Deve formatar valor com 4 casas decimais', () {
      final cotacao = Cotacao.fromJson('USD', 5.12345, '2024-01-15');

      final valorFormatado = cotacao.valor.toStringAsFixed(4);

      expect(valorFormatado, equals('5.1235'));
    });
  });

  group('Cotacao Business Logic Tests', () {
    test('Deve calcular conversão inversa corretamente', () {
      final cotacao = Cotacao.fromJson('USD', 5.0, '2024-01-15');

      final conversaoInversa = 1.0 / cotacao.valor;

      expect(conversaoInversa, equals(0.2));
    });

    test('Deve calcular múltiplas conversões corretamente', () {
      final cotacao = Cotacao.fromJson('USD', 5.0, '2024-01-15');

      final valor10 = cotacao.valor * 10;
      final valor100 = cotacao.valor * 100;

      expect(valor10, equals(50.0));
      expect(valor100, equals(500.0));
    });

    test('Deve lidar com valores zero e negativos', () {
      final cotacaoZero = Cotacao.fromJson('TEST', 0.0, '2024-01-15');
      final cotacaoNegativo = Cotacao.fromJson('TEST', -1.0, '2024-01-15');

      expect(cotacaoZero.valor, equals(0.0));
      expect(cotacaoNegativo.valor, equals(-1.0));
    });
  });
}
