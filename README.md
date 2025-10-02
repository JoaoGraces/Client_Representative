# Client_Representative
## 1. Descrição do projeto:
OrderFlowWhiteLabel é uma plataforma de automação de vendas projetada para modernizar e otimizar o fluxo de pedidos entre empresas distribuidoras, seus representantes comerciais e os clientes finais.

O projeto nasceu para resolver um problema crítico no processo de vendas: a dependência de métodos manuais e ineficientes. Atualmente, representantes comerciais recebem pedidos via aplicativos de mensagem, como o WhatsApp, e os redigitam manualmente em sistemas legados, um processo lento e altamente propenso a erros de digitação, seleção de produtos incorretos e preços desatualizados. Esses erros geram prejuízos logísticos, retrabalho e desgaste na relação com o cliente.

A nossa solução substitui esse fluxo fragmentado por uma plataforma integrada e intuitiva. Com um aplicativo móvel, o próprio cliente final pode montar e enviar seus pedidos diretamente de um catálogo digital sempre atualizado. O representante comercial, por sua vez, deixa de ser um digitador e se torna um validador ágil, aprovando os pedidos com segurança e eficiência antes de serem processados pela empresa.

O objetivo principal é eliminar erros operacionais, garantir a precisão dos dados, aumentar a produtividade da equipe de vendas e fornecer uma experiência de compra transparente e confiável para todos os envolvidos.


## 2. Arquitetura do Projeto (Estrutura de Pastas):
### MVVM-C (Model-View-ViewModel-Coordinator).

## 📁 Estrutura do Projeto

```plaintext
📁 OrderFlowWhiteLabel/
│
├── 📁 Coordinators/         # Gerencia a navegação e o fluxo entre as cenas.
├── 📁 DependencyInjection/  # Configuração da injeção de dependência.
├── 📁 Models/               # Estruturas de dados (ex: Pedido, Usuario, Empresa).
├── 📁 Network/              # Camada de comunicação com a API (ex: APIClient, Endpoints).
├── 📁 Repositories/         # Abstrai a origem dos dados (API, banco de dados local).
├── 📁 Resources/
│   └── 🖼️ Assets.xcassets     # Imagens, cores e outros recursos visuais.
│
├── 📁 Scenes/               # Agrupamento de telas completas (pode conter View+ViewModel).
├── 📁 Services/             # Lógica de negócio compartilhada (ex: AuthService, OrderService).
│   ├── 📁 Network/
│   └── 📁 Persistence/
│
├── 📁 Utilities/
│   └── 📁 Extensions/       # Extensões de tipos nativos (String, Date, etc.).
│
├── 📁 ViewModels/           # Lógica de apresentação e estado das Views.
├── 📁 Views/
│   ├── 📁 Components/       # Componentes de UI reutilizáveis (botões, campos de texto).
│   └── 📁 Shared/           # Views compartilhadas entre múltiplas cenas.
│
├── 📄 ContentView.swift               # View inicial ou de teste.
└── 📄 OrderFlowWhiteLabelApp.swift    # Ponto de entrada da aplicação.

📁 OrderFlowWhiteLabelTests/
└── 🧪 OrderFlowWhiteLabelTests.swift      # Testes de Unidade.

📁 OrderFlowWhiteLabelUITests/
└── 🧪 OrderFlowWhiteLabelUITests.swift   # Testes de Interface de Usuário.
```

## 3. Modelagem de Dados

#### 
<img width="2622" height="3840" alt="Untitled diagram | Mermaid Chart-2025-10-02-212405" src="https://github.com/user-attachments/assets/5e531b0f-84c6-4951-8b64-bddeab83590f" />

3.1. Descrição da Arquitetura
A modelagem foi projetada para ser flexível e robusta, suportando uma arquitetura White Label. O pilar do sistema é a entidade Empresas, que distingue as Distribuidoras (donas da instância do app) das empresas que são Cliente Final.

Os principais conceitos da modelagem são:
Hierarquia de Empresas e Usuários: O sistema gerencia uma Empresa do tipo CLIENTE_FINAL (ex: um restaurante), que pode ter múltiplos Usuarios (funcionários) cadastrados e vinculados a ela. Cada ação no sistema é auditável em nível de usuário.
Catálogo por Distribuidora: A tabela Produtos está diretamente ligada à Empresa DISTRIBUIDORA, garantindo que cada instância white label tenha seu próprio catálogo de produtos.
Ciclo de Vida do Pedido: A entidade Pedidos é o centro das operações e está conectada a tabelas de suporte que gerenciam todo o fluxo: ItensPedido, Pagamentos (com status e links para boletos) e NotasFiscais. O modelo também captura detalhes da entrega, como data solicitada e status de recebimento.
Vínculo Cliente-Representante: Uma tabela de ligação, ClientesRepresentantes, formaliza qual Usuario (representante) é responsável por atender qual Empresa (cliente), garantindo que os pedidos sejam sempre direcionados à pessoa correta.

## 4.Padroes de Commit

Padrão de Nomenclatura de Branches
Para manter a organização e clareza no histórico de desenvolvimento, o projeto segue um padrão de nomenclatura para a criação de branches. Cada nome de branch deve ser prefixado de acordo com o tipo de tarefa sendo executada.
```plaintext
feat/: Para o desenvolvimento de novas funcionalidades (features).
Exemplo: feat/autenticacao-usuarios-jwt
Exemplo: feat/novo-formulario-cadastro
fix/ ou bugfix/: Para a correção de bugs.
Exemplo: fix/correcao-login-invalido
Exemplo: bugfix/problema-layout-responsivo
docs/: Para alterações na documentação do projeto.
Exemplo: docs/atualizacao-readme
Exemplo: docs/inclusao-guia-contribuicao
refactor/: Para refatorações de código que não alteram a funcionalidade externa.
Exemplo: refactor/otimizacao-consultas-banco
Exemplo: refactor/simplificacao-logica-componente
style/: Para ajustes de formatação que não afetam a lógica do código (linting, code style).
Exemplo: style/ajuste-padrao-eslint
test/: Para a adição ou modificação de testes.
Exemplo: test/cobertura-testes-api-usuarios
chore/: Para tarefas de manutenção que não se encaixam nas outras categorias (ex: atualização de dependências, configuração de build).
Exemplo: chore/atualizacao-dependencias-npm
Exemplo: chore/configuracao-workflow-ci
hotfix/: Para correções críticas e urgentes em produção.
Exemplo: hotfix/correcao-falha-seguranca-critica
```
