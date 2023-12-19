import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var generatorPage = GeneratorPage(
    favorites: [],
    cardStr: 'cardStr',
    icon: Icons.favorite_border,
  );

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = generatorPage;
        break;
      case 1:
        page = Favorites(favorites: generatorPage.favorites);
        break;
      default:
        throw UnimplementedError('No widget for $_selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text('Favorite'))
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('print +');
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required String cardStr,
  }) : _cardStr = cardStr;

  final String _cardStr;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _cardStr,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GeneratorPage extends StatefulWidget {
  GeneratorPage(
      {super.key,
      required this.favorites,
      required this.cardStr,
      required this.icon});

  List<String> favorites;
  String cardStr;
  IconData icon;

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  void _getCardString() {
    setState(() {
      const availableChars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      widget.cardStr = List.generate(
          6,
          (index) =>
              availableChars[Random().nextInt(availableChars.length)]).join();
      if (widget.favorites.contains(widget.cardStr)) {
        widget.icon = Icons.favorite;
      } else {
        widget.icon = Icons.favorite_border;
      }
    });
  }

  void _toggleFavorite() {
    setState(() {
      if (widget.favorites.contains(widget.cardStr)) {
        widget.favorites.remove(widget.cardStr);
        widget.icon = Icons.favorite_border;
      } else {
        widget.favorites.add(widget.cardStr);
        widget.icon = Icons.favorite;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BigCard(cardStr: widget.cardStr),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(widget.icon),
                  label: const Text('Like')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: _getCardString, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}

class Favorites extends StatelessWidget {
  const Favorites({
    super.key,
    required List<String> favorites,
  }) : _favorites = favorites;

  final List<String> _favorites;

  @override
  Widget build(BuildContext context) {
    if (_favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('You have ${_favorites.length} favorites'),
        ),
        for (var str in _favorites)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(str),
          ),
      ],
    );
  }
}
