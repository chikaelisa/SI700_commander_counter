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

## Regras de segurança planejadas

A ideia é garantir que cada usuário só consiga acessar os próprios dados.

Regras planejadas para o Firestore:

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

Essas regras impedem que um usuário autenticado leia ou altere dados de outro usuário.

## Estratégia de implementação Firebase

A integração será feita em etapas:

1. Configurar Firebase no projeto Flutter.
2. Substituir `MockAuthDataProvider` por `FirebaseAuthDataProvider`.
3. Criar o documento `users/{uid}` no cadastro.
4. Buscar dados de `users/{uid}` no login.
5. Exibir nome e e-mail reais no perfil.
6. Substituir `LocalMatchHistoryDataProvider` por `FirestoreMatchHistoryDataProvider`.
7. Salvar partidas em `users/{uid}/matches`.
8. Listar apenas as partidas do usuário autenticado.
9. Permitir exclusão e edição de comentário no Firestore.
10. Integrar API externa de cartas para buscar comandantes e imagens.

## Justificativa técnica

Essa estrutura foi escolhida para manter os dados de cada usuário isolados e facilitar a apresentação do projeto.

O Firebase Authentication será responsável pela identidade do usuário. O Cloud Firestore armazenará os dados complementares do perfil e o histórico de partidas.

A separação planejada é:

```text
Firebase Authentication
  - e-mail
  - senha
  - uid

Cloud Firestore
  - nome do usuário
  - dados de perfil
  - histórico de partidas
  - jogadores de cada partida
  - dados dos comandantes
```

Com isso, o app consegue demonstrar:

- autenticação real;
- dados persistentes;
- dados separados por usuário;
- armazenamento visível no Firebase Console;
- estrutura compatível com a arquitetura em camadas do projeto.

## Relação com a arquitetura do app

A integração com Firebase seguirá a arquitetura atual do projeto:

```text
Interface Gráfica
  → BLoC
    → Data Provider
      → Firebase
```

Exemplo para autenticação:

```text
ProfilePage / SignInView / SignUpView
  → AuthBloc
    → FirebaseAuthDataProvider
      → Firebase Authentication + Firestore users/{uid}
```

Exemplo para histórico:

```text
LifePage / MatchHistoryPage
  → MatchHistoryBloc
    → FirestoreMatchHistoryDataProvider
      → Firestore users/{uid}/matches/{matchId}
```

Essa organização permite trocar a implementação dos dados sem reescrever as telas principais.
