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

## Modelo de dados planejado no Firebase

A versão final do app usará Firebase Authentication para login real e Cloud Firestore para armazenar os dados persistentes do usuário.

A estrutura planejada é:

```text
users
  {uid}
    name: string
    email: string
    createdAt: timestamp
    updatedAt: timestamp

    matches
      {matchId}
        playedAt: timestamp
        playerCount: number
        winnerName: string | null
        comment: string
        createdAt: timestamp
        updatedAt: timestamp
        players: array
          [
            {
              playerName: string
              commanderName: string
              commanderImageUrl: string | null
              commanderCardId: string | null
              finalLife: number
              manaColors: array<string>
            }
          ]
```

### Coleção `users`

Cada usuário autenticado terá um documento próprio em:

```text
users/{uid}
```

O campo `uid` será o identificador gerado pelo Firebase Authentication.

Campos planejados:

| Campo       | Tipo      | Descrição                            |
| ----------- | --------- | ------------------------------------ |
| `name`      | string    | Nome exibido no perfil do usuário    |
| `email`     | string    | E-mail usado na autenticação         |
| `createdAt` | timestamp | Data de criação do cadastro          |
| `updatedAt` | timestamp | Data da última atualização do perfil |

### Subcoleção `matches`

Cada usuário terá suas próprias partidas salvas em:

```text
users/{uid}/matches/{matchId}
```

Campos planejados:

| Campo         | Tipo           | Descrição                                            |
| ------------- | -------------- | ---------------------------------------------------- |
| `playedAt`    | timestamp      | Data e horário da partida                            |
| `playerCount` | number         | Quantidade de jogadores                              |
| `winnerName`  | string ou null | Nome do vencedor, ou null quando não houver vencedor |
| `comment`     | string         | Comentário opcional sobre a partida                  |
| `createdAt`   | timestamp      | Data de criação do registro                          |
| `updatedAt`   | timestamp      | Data da última atualização do registro               |
| `players`     | array          | Lista com os jogadores da partida                    |

Cada item de `players` terá:

| Campo               | Tipo           | Descrição                        |
| ------------------- | -------------- | -------------------------------- |
| `playerName`        | string         | Nome do jogador                  |
| `commanderName`     | string         | Nome do comandante               |
| `commanderImageUrl` | string ou null | URL da imagem do comandante      |
| `commanderCardId`   | string ou null | ID da carta na API externa       |
| `finalLife`         | number         | Vida final do jogador            |
| `manaColors`        | array<string>  | Identidade de mana do comandante |

## Integração com Firebase

O app usa Firebase para autenticação real e persistência remota dos dados do usuário.

### Firebase Authentication

A autenticação é feita com Firebase Authentication usando e-mail e senha.

Fluxos implementados:

- Cadastro com nome, e-mail e senha.
- Login com e-mail e senha.
- Logout.
- Exibição dos dados reais do usuário autenticado no perfil.

No cadastro, o Firebase Authentication cria o usuário e gera um `uid`. Esse `uid` é usado como identificador principal do usuário no Firestore.

### Cloud Firestore

O Cloud Firestore é usado para armazenar os dados complementares do perfil e o histórico de partidas.

Estrutura implementada:

```text
users
  {uid}
    name: string
    email: string
    createdAt: timestamp
    updatedAt: timestamp

    matches
      {matchId}
        playedAt: timestamp
        playerCount: number
        winnerName: string | null
        comment: string
        createdAt: timestamp
        updatedAt: timestamp
        players: array
          [
            {
              playerName: string
              commanderName: string
              finalLife: number
            }
          ]
```

### CRUD do histórico

O histórico de partidas possui operações completas de CRUD:

| Operação | Implementação                                               |
| -------- | ----------------------------------------------------------- |
| Create   | Salvar partida encerrada em `users/{uid}/matches/{matchId}` |
| Read     | Listar partidas salvas do usuário autenticado               |
| Update   | Editar comentário de uma partida salva                      |
| Delete   | Excluir partida salva                                       |

O histórico é sempre associado ao usuário logado, usando o `uid` do Firebase Authentication.

### Regras de segurança do Firestore

As regras planejadas/implementadas garantem que cada usuário só possa acessar os próprios dados:

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;

      match /matches/{matchId} {
        allow read, write: if request.auth != null
                           && request.auth.uid == userId;
      }
    }
  }
}
```

## Arquitetura atual com Firebase

A integração com Firebase segue a arquitetura em camadas do projeto:

```text
Interface Gráfica
  → BLoC
    → Data Provider
      → Firebase
```

### Autenticação

```text
ProfilePage / SignInView / SignUpView
  → AuthBloc
    → FirebaseAuthDataProvider
      → Firebase Authentication
      → Firestore users/{uid}
```

### Histórico

```text
LifePage / MatchHistoryPage
  → MatchHistoryBloc
    → FirestoreMatchHistoryDataProvider
      → Firestore users/{uid}/matches/{matchId}
```

Essa separação permite trocar a origem dos dados sem reescrever as telas principais.
