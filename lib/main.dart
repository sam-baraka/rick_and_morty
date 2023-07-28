import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/providers/fetch_characters_provider.dart';

void main() {
  runApp(const ProviderScope(child: RickAndMorty()));
}

class RickAndMorty extends StatelessWidget {
  const RickAndMorty({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Characters"),
      ),
      body: ref.watch(fetchCharactersProvider).maybeWhen(fetching: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, fetched: (characters) {
        return ListView(
          children: characters
              .map((e) => ListTile(
                    title: Text(e.name!),
                    leading: Image.network(
                      e.image!,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    subtitle: Text(e.status!),
                  ))
              .toList(),
        );
      }, orElse: () {
        return Container();
      }),
    );
  }
}
