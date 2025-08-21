# CryptoMarketApp - Aplicação iOS de Criptomoedas

## Descrição

Projeto prático desenvolvido durante o Santander BootCamp que implementa uma aplicação iOS moderna para listagem e visualização de criptomoedas. O projeto segue os princípios da Clean Architecture (VIP) e utiliza tecnologias avançadas do ecossistema iOS.

## Características Técnicas

- **Plataforma**: iOS (iPhone e iPad)
- **Versão mínima**: iOS 13.0+
- **Arquitetura**: Clean Architecture (VIP)
- **Framework de UI**: SwiftUI + UIKit
- **Linguagem**: Swift 5.0+
- **Padrão de Design**: MVVM
- **Gerenciamento de Estado**: Combine Framework
- **Injeção de Dependência**: Container próprio
- **Persistência Local**: Core Data
- **Gráficos**: SwiftUI Charts
- **Notificações**: UserNotifications Framework

## Estrutura do Projeto

```
CryptoMarketApp/
├── App/                       # Configurações do app
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Info.plist
├── Presentation/              # Camada de apresentação
│   ├── Views/                # Views SwiftUI
│   │   ├── CryptoListView.swift
│   │   ├── CryptoCurrencyRowView.swift
│   │   └── PriceChartView.swift
│   └── ViewModels/           # ViewModels
│       └── CryptoListViewModel.swift
├── Domain/                   # Camada de domínio
│   ├── Entities/             # Entidades de negócio
│   │   └── CryptoCurrency.swift
│   ├── UseCases/             # Casos de uso
│   │   └── FetchCryptoCurrenciesUseCase.swift
│   └── Repositories/         # Interfaces dos repositórios
│       └── CryptoCurrencyRepositoryProtocol.swift
├── Data/                     # Camada de dados
│   ├── Repositories/         # Implementações dos repositórios
│   │   └── CryptoCurrencyRepository.swift
│   ├── DataSources/          # Fontes de dados (API, Local)
│   │   ├── CryptoCurrencyRemoteDataSource.swift
│   │   └── CryptoCurrencyLocalDataSource.swift
│   ├── Network/              # Configuração de rede
│   │   ├── NetworkService.swift
│   │   └── NetworkServiceProtocol.swift
│   └── CoreData/             # Persistência local
│       ├── CryptoMarketApp.xcdatamodeld/
│       └── CoreDataManager.swift
├── Shared/                   # Recursos compartilhados
│   ├── DIContainer.swift     # Container de injeção de dependências
│   ├── Services/             # Serviços compartilhados
│   │   └── NotificationService.swift
│   ├── Extensions/           # Extensões Swift
│   │   └── View+Extensions.swift
│   └── Constants/            # Constantes
│       └── AppConstants.swift
└── Tests/                    # Testes
    ├── Unit Tests/           # Testes unitários
    │   ├── CryptoCurrencyTests.swift
    │   └── CryptoListViewModelTests.swift
    └── UI Tests/             # Testes de interface
        └── CryptoListUITests.swift
```

## Funcionalidades Implementadas

### Modelo de Dados
- Estrutura completa para criptomoedas com 25+ propriedades
- Conformidade com protocolo Codable para serialização JSON
- Suporte a métricas de mercado (preço, volume, variações)
- Tratamento robusto de valores nulos
- Propriedades computadas para formatação de dados

### Arquitetura e Padrões
- **Clean Architecture**: Separação clara entre camadas
- **Repository Pattern**: Abstração de fontes de dados
- **Use Case Pattern**: Casos de uso bem definidos
- **Dependency Injection**: Container próprio para injeção
- **Combine Framework**: Gerenciamento reativo de estado

### Interface do Usuário
- Interface moderna construída com SwiftUI
- Lista de criptomoedas com design responsivo
- Barra de busca com debounce
- Pull-to-refresh para atualização de dados
- Tratamento de estados de loading e erro
- Suporte a orientações portrait e landscape
- **Gráficos de preços** com SwiftUI Charts
- Seletores de timeframe (1H, 24H, 7D, 30D)

### Funcionalidades de Rede
- Integração com API CoinGecko
- Cache local inteligente com expiração
- Tratamento de erros de rede
- Busca local e remota de criptomoedas

### Persistência Local
- **Core Data** para armazenamento persistente
- Histórico de preços das criptomoedas
- Cache inteligente com expiração automática
- Operações em background para melhor performance

### Sistema de Notificações
- **Alertas de preço** configuráveis
- Notificações de mudanças percentuais
- Resumos diários do portfólio
- Atualizações do mercado
- Suporte a notificações push

### Testes
- **Testes unitários** para modelos e ViewModels
- **Testes de interface** para funcionalidades de UI
- Mocks para dependências externas
- Cobertura de casos de sucesso e erro

## Estado do Desenvolvimento

### Implementado
- Arquitetura Clean Architecture completa
- Modelos de dados robustos para criptomoedas
- Sistema de cache local com expiração
- Integração com API externa (CoinGecko)
- Interface de usuário moderna e responsiva
- Sistema de injeção de dependências
- Tratamento de erros e estados de loading
- Busca local de criptomoedas
- Pull-to-refresh e atualização de dados
- **Core Data para persistência local**
- **Gráficos de preços interativos**
- **Sistema de notificações completo**
- **Testes unitários e de UI**
- **Configuração de aparência do app**

### Em Desenvolvimento
- Widgets para iOS Home Screen
- Modo offline completo
- Suporte a múltiplas moedas
- Gráficos em tempo real
- Análise técnica avançada

### Pendente
- Testes de integração
- Analytics e crash reporting
- Acessibilidade avançada
- Suporte a Apple Watch
- Siri Shortcuts

## Requisitos do Sistema

- Xcode 12.0 ou superior
- iOS 13.0+ para dispositivos de destino
- macOS 10.15+ para desenvolvimento
- Swift 5.0+
- Combine Framework
- Core Data
- UserNotifications Framework

## Instalação e Configuração

1. Clone o repositório
2. Abra o arquivo `list_coin_project1.xcodeproj` no Xcode
3. Selecione o dispositivo de destino ou simulador
4. Execute o projeto (Cmd + R)

## Executando os Testes

### Testes Unitários
```bash
# No Xcode: Product > Test (Cmd + U)
# Ou via linha de comando:
xcodebuild test -scheme list_coin_project1 -destination 'platform=iOS Simulator,name=iPhone 14'
```

### Testes de UI
```bash
# No Xcode: Product > Test (Cmd + U)
# Os testes de UI são executados automaticamente
```

## Arquitetura

O projeto implementa Clean Architecture com as seguintes camadas:

- **Domain Layer**: Entidades, casos de uso e protocolos de repositório
- **Data Layer**: Implementações de repositório, fontes de dados e serviços de rede
- **Presentation Layer**: Views, ViewModels e coordenação de UI
- **Shared**: Recursos compartilhados, constantes e configurações

## Padrões de Design

- **MVVM**: Separação de responsabilidades entre View e ViewModel
- **Repository Pattern**: Abstração de acesso a dados
- **Use Case Pattern**: Encapsulamento de lógica de negócio
- **Dependency Injection**: Inversão de controle para dependências
- **Observer Pattern**: Uso do Combine Framework para reatividade
- **Core Data Pattern**: Persistência local estruturada

## Funcionalidades Avançadas

### Gráficos de Preços
- Visualização interativa de preços
- Múltiplos timeframes (1H, 24H, 7D, 30D)
- Gestos de toque para navegação
- Formatação automática de eixos
- Suporte a temas claro/escuro

### Sistema de Notificações
- Alertas de preço configuráveis
- Notificações de mudanças significativas
- Resumos diários automáticos
- Integração com sistema iOS

### Persistência Local
- Armazenamento Core Data otimizado
- Histórico de preços detalhado
- Operações assíncronas em background
- Limpeza automática de dados antigos

## Contribuição

Este projeto foi desenvolvido como parte do Santander BootCamp e serve como base para aprendizado e desenvolvimento de aplicações iOS profissionais seguindo as melhores práticas de arquitetura.

## Licença

Copyright © 2023 Camila Fernandes. Todos os direitos reservados.

## Contato

Desenvolvido por Camila Fernandes durante o Santander BootCamp. 
Obs.: IMac utilizado de Caio Zini