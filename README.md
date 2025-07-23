# Cotações BSF - App Flutter

Um aplicativo mobile moderno para consulta de cotações financeiras em tempo real, desenvolvido em Flutter como parte do desafio TalentLab da BSF.

## Sobre o Projeto

Este aplicativo permite consultar cotações de diferentes moedas em relação ao Real Brasileiro (BRL), oferecendo uma interface intuitiva e moderna para acompanhar variações cambiais.

## Funcionalidades

- **Consulta de Cotações**: Visualize cotações de 10 moedas principais em tempo real
- **Atualização Automática**: Pull-to-refresh para atualizar dados
- **Interface Moderna**: Design responsivo com Material Design 3
- **Detalhes Completos**: Tela dedicada com informações detalhadas de cada moeda
- **Simulador de Conversão**: Calcule conversões rapidamente
- **Animações Suaves**: Transições elegantes entre telas
- **Performance Otimizada**: Carregamento rápido e eficiente

## Moedas Suportadas

| Código | Moeda | Nome Completo |
|--------|-------|---------------|
| USD | $ | Dólar Americano |
| EUR | € | Euro |
| GBP | £ | Libra Esterlina |
| JPY | ¥ | Iene Japonês |
| AUD | A$ | Dólar Australiano |
| CAD | C$ | Dólar Canadense |
| CHF | Fr | Franco Suíço |
| CNY | ¥ | Yuan Chinês |
| ARS | $ | Peso Argentino |
| UYU | $ | Peso Uruguaio |

## Tecnologias Utilizadas

- **Framework**: Flutter 3.x
- **Linguagem**: Dart
- **API**: ExchangeRate-API
- **Arquitetura**: Model-View (MV)
- **Testes**: flutter_test
- **HTTP Client**: package:http

## Pré-requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.0 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (incluído com Flutter)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

## Como Executar

### 1. Clone o repositório
```bash
git clone https://github.com/SEU_USUARIO/cotacoes-app-flutter.git
cd cotacoes-app-flutter
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Execute o aplicativo
```bash
# No emulador/dispositivo Android
flutter run

# No navegador (para desenvolvimento)
flutter run -d chrome

# No iOS (apenas no macOS)
flutter run -d ios
```

## Executar Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Executar teste específico
flutter test test/api_service_test.dart
```

## Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do app
├── models/
│   └── cotacao.dart         # Modelo de dados da cotação
├── screens/
│   ├── home_screen.dart     # Tela principal com lista
│   └── details_screen.dart  # Tela de detalhes da moeda
└── services/
    └── api_service.dart     # Serviço para consumo da API

test/
└── api_service_test.dart    # Testes unitários
```

## API Utilizada

**ExchangeRate-API**: https://api.exchangerate-api.com/v4/latest/BRL

- **Endpoint**: `GET /v4/latest/BRL`
- **Limite**: 1.500 requisições/mês (gratuito)
- **Formato**: JSON
- **Documentação**: https://exchangerate-api.com/docs

### Exemplo de Resposta:
```json
{
  "base": "BRL",
  "date": "2024-01-15",
  "rates": {
    "USD": 0.2,
    "EUR": 0.18,
    "GBP": 0.16
  }
}
```

## Configuração de Desenvolvimento

### VS Code
Instale as extensões recomendadas:
- Flutter
- Dart
- Material Icon Theme

### Android Studio
- Configure o emulador Android
- Instale o plugin Flutter/Dart

## Screenshots

### Tela Principal
- Lista de cotações com design moderno
- Pull-to-refresh para atualização
- Indicadores visuais de carregamento

### Tela de Detalhes
- Informações completas da moeda
- Simulador de conversão
- Variação percentual (simulada)

## Funcionalidades Futuras

- [ ] Gráficos de variação histórica
- [ ] Notificações push para alertas
- [ ] Modo offline com cache
- [ ] Favoritos do usuário
- [ ] Calculadora de conversão avançada
- [ ] Compartilhamento de cotações
- [ ] Modo escuro
- [ ] Suporte a mais moedas

## Desenvolvimento

### Dia 1: Configuração
- ✅ Setup do Flutter e Git
- ✅ Estrutura inicial do projeto
- ✅ Tela de boas-vindas

### Dia 2: API e Lista
- ✅ Integração com API de cotações
- ✅ Modelo de dados
- ✅ Lista de cotações

### Dia 3: Navegação
- ✅ Tela de detalhes
- ✅ Navegação entre telas
- ✅ Gerenciamento de estado

### Dia 4: Interface e Testes
- ✅ Material Design melhorado
- ✅ Testes unitários
- ✅ Tratamento de erros

### Dia 5: Finalização
- ✅ Animações e polish
- ✅ Documentação completa
- ✅ Deploy e entrega

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Desenvolvedor

**Luiz Augusto Nascimento Guimarães**
- GitHub: [@ghostsuki](https://github.com/ghostsuki)

## Agradecimentos

- **BSF TalentLab** pelo desafio proposto
- **ExchangeRate-API** pelos dados gratuitos
- **Flutter Team** pela framework incrível
- **Comunidade Flutter** pelo suporte

---

*Desenvolvido em Flutter para o TalentLab BSF*