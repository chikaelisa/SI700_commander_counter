# Commander Counter

Aplicativo Flutter para auxiliar partidas de Commander, formato multiplayer de Magic: The Gathering.

## Objetivo

O app permite configurar uma partida com múltiplos jogadores, controlar pontos de vida, registrar informações dos jogadores e salvar o histórico local das partidas encerradas.

## Funcionalidades atuais

- Navegação por abas:
  - Game
  - Counters
  - Life
  - Profile
- Controle de acesso por login mockado.
- Tela Life disponível mesmo sem login.
- Game e Counters bloqueadas para usuários não logados.
- Configuração de partida com 2 a 6 jogadores.
- Escolha de vida inicial: 20, 30, 40, 60 ou personalizada.
- Controle individual de vida.
- Edição de nome do jogador.
- Edição de comandante para usuários logados.
- Seleção de identidade de mana.
- Personalização da cor do card do jogador.
- Encerramento de partida.
- Salvamento de histórico local para usuários logados.
- Listagem e exclusão de partidas salvas.

## Arquitetura

O projeto está sendo organizado em três camadas principais:

### Interface Gráfica

Responsável por exibir as telas, coletar interações do usuário e renderizar os estados recebidos dos BLoCs.

Exemplos:

- `LifePage`
- `MatchHistoryPage`
- `ProfilePage`
- `SignInView`
- `SignUpView`
- `PlayerLifeCard`
- `EndGameBottomSheet`

### BLoC

Responsável por controlar eventos e estados das funcionalidades.

Exemplos:

- `AuthBloc`
- `AuthEvent`
- `AuthState`
- `MatchHistoryBloc`
- `MatchHistoryEvent`
- `MatchHistoryState`

### Data Provider

Responsável por acessar dados externos ou persistentes.

Exemplos:

- `AuthDataProvider`
- `MockAuthDataProvider`
- `MatchHistoryDataProvider`
- `LocalMatchHistoryDataProvider`

## Persistência

O histórico de partidas é salvo localmente usando `shared_preferences`.

A camada responsável por isso é:

```text
LocalMatchHistoryDataProvider
```
