class Cotacao {
  final String moeda;
  final String nome;
  final double valor;
  final String data;

  Cotacao({
    required this.moeda,
    required this.nome,
    required this.valor,
    required this.data,
  });

  factory Cotacao.fromJson(String moeda, double valor, String data) {
    final Map<String, String> nomesMoedas = {
      'USD': 'Dólar Americano',
      'EUR': 'Euro',
      'GBP': 'Libra Esterlina',
      'JPY': 'Iene Japonês',
      'AUD': 'Dólar Australiano',
      'CAD': 'Dólar Canadense',
      'CHF': 'Franco Suíço',
      'CNY': 'Yuan Chinês',
      'ARS': 'Peso Argentino',
      'UYU': 'Peso Uruguaio',
    };

    return Cotacao(
      moeda: moeda,
      nome: nomesMoedas[moeda] ?? moeda,
      valor: valor,
      data: data,
    );
  }
}
