# Project iPhone Bootcamp - Lista de Criptomoedas

## Descrição

Projeto prático desenvolvido durante o Santander BootCamp que implementa uma aplicação iOS para listagem e visualização de criptomoedas. O projeto segue os princípios da Clean Architecture (VIP) e utiliza tecnologias modernas do ecossistema iOS.

## Características Técnicas

- **Plataforma**: iOS (iPhone e iPad)
- **Versão mínima**: iOS 13.0+
- **Arquitetura**: Clean Architecture (VIP)
- **Framework de UI**: SwiftUI + UIKit
- **Linguagem**: Swift 5.0+
- **Padrão de Design**: MVVM

## Estrutura do Projeto

```
list_coin_project1/
├── Domain/                    # Camada de domínio
│   └── DataProvider/         # Provedores de dados
│       └── cripto_models.swift
├── list_coin_project1/       # Camada de apresentação
│   ├── ContentView.swift     # View principal (SwiftUI)
│   ├── AppDelegate.swift     # Gerenciador do ciclo de vida
│   ├── SceneDelegate.swift   # Gerenciador de cenas
│   └── Info.plist           # Configurações do app
└── list_coin_project1.xcodeproj/
```

## Funcionalidades

### Modelo de Dados
- Estrutura completa para criptomoedas com 25+ propriedades
- Conformidade com protocolo Codable para serialização JSON
- Suporte a métricas de mercado (preço, volume, variações)
- Tratamento robusto de valores nulos

### Interface do Usuário
- Interface moderna construída com SwiftUI
- Suporte a orientações portrait e landscape
- Compatibilidade com iPhone e iPad
- Design responsivo e adaptativo

## Configurações do App

- **Orientação**: Portrait e Landscape (iPhone e iPad)
- **Capacidades**: Suporte a dispositivos ARMv7+
- **Cenas**: Configuração única de cena para melhor performance
- **Launch Screen**: Tela de carregamento personalizada

## Estado do Desenvolvimento

### Implementado
- Estrutura base do projeto seguindo Clean Architecture
- Modelos de dados para criptomoedas
- Configuração básica do aplicativo
- Integração SwiftUI com UIKit
- Configuração de cenas e ciclo de vida

### Em Desenvolvimento
- Interface do usuário para listagem de criptomoedas
- Lógica de negócio e validações
- Integração com APIs externas
- Persistência local de dados

### Pendente
- Views para exibição de lista de criptomoedas
- Implementação das camadas de apresentação (VIP)
- Serviços de rede e comunicação com APIs
- Testes unitários e de interface
- Documentação de API e uso

## Requisitos do Sistema

- Xcode 12.0 ou superior
- iOS 13.0+ para dispositivos de destino
- macOS 10.15+ para desenvolvimento
- Swift 5.0+

## Instalação e Configuração

1. Clone o repositório
2. Abra o arquivo `list_coin_project1.xcodeproj` no Xcode
3. Selecione o dispositivo de destino ou simulador
4. Execute o projeto (Cmd + R)

## Arquitetura

O projeto segue os princípios da Clean Architecture (VIP):

- **Domain Layer**: Contém os modelos de dados e regras de negócio
- **Presentation Layer**: Gerencia a interface do usuário e interações
- **Data Layer**: Responsável pela persistência e comunicação externa

## Contribuição

Este projeto foi desenvolvido como parte do Santander BootCamp e serve como base para aprendizado e desenvolvimento de aplicações iOS profissionais.

## Licença

Copyright © 2023 Camila Fernandes. Todos os direitos reservados.

## Contato

Desenvolvido por Camila Fernandes durante o Santander BootCamp.