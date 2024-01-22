import 'package:example6/film.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

final favoriteStatusProvider =
    StateProvider<FavoriteStatus>((ref) => FavoriteStatus.all);
final allFilmsProvider =
    StateNotifierProvider<FilmNotifier, List<Film>>((ref) => FilmNotifier());
final favoriteFilmProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where((e) => e.isFavorite),
);
final notFavoriteFilmProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where((e) => !e.isFavorite),
);

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(allFilms);
  void update(Film film, bool isFavorite) {
    state = state
        .map((e) => e.id == film.id ? e.copyWith(isFavorite: isFavorite) : e)
        .toList();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Movie List'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? child,
            ) {
              final filter = ref.watch(favoriteStatusProvider);
              switch (filter) {
                case FavoriteStatus.all:
                  return FilmsWidget(
                    provider: allFilmsProvider,
                  );
                case FavoriteStatus.favorite:
                  return FilmsWidget(
                    provider: favoriteFilmProvider,
                  );
                case FavoriteStatus.notFavorite:
                  return FilmsWidget(
                    provider: notFavoriteFilmProvider,
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final ico = film.isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border);
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              onPressed: () {
                ref
                    .watch(allFilmsProvider.notifier)
                    .update(film, !film.isFavorite);
              },
              icon: ico,
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => DropdownButton(
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ))
            .toList(),
        onChanged: (status) =>
            ref.watch(favoriteStatusProvider.notifier).state = status!,
      ),
    );
  }
}
