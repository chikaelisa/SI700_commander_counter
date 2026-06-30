import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/card_search_bloc.dart';
import '../bloc/card_search_event.dart';
import '../bloc/card_search_state.dart';
import '../models/magic_card.dart';

class CommanderCardSearch extends StatefulWidget {
  final void Function(MagicCard card) onCardSelected;

  const CommanderCardSearch({super.key, required this.onCardSelected});

  @override
  State<CommanderCardSearch> createState() => _CommanderCardSearchState();
}

class _CommanderCardSearchState extends State<CommanderCardSearch> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchCards() {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome de um comandante.')),
      );

      return;
    }

    context.read<CardSearchBloc>().add(SearchCommanderCardsRequested(query));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buscar comandante',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Nome da carta',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => searchCards(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: searchCards,
              icon: const Icon(Icons.search),
              tooltip: 'Buscar',
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<CardSearchBloc, CardSearchState>(
          builder: (context, state) {
            if (state is CardSearchInitial) {
              return const SizedBox.shrink();
            }

            if (state is CardSearchLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is CardSearchEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Nenhum comandante encontrado.'),
              );
            }

            if (state is CardSearchError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(state.message),
              );
            }

            if (state is CardSearchLoaded) {
              return SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.cards.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final card = state.cards[index];

                    return CommanderCardSearchResult(
                      card: card,
                      onTap: () {
                        widget.onCardSelected(card);
                        context.read<CardSearchBloc>().add(
                          const ClearCardSearch(),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class CommanderCardSearchResult extends StatelessWidget {
  final MagicCard card;
  final VoidCallback onTap;

  const CommanderCardSearchResult({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: card.imageUrl == null
                    ? const Center(
                        child: Icon(Icons.image_not_supported_outlined),
                      )
                    : Image.network(
                        card.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image_outlined),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  card.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
