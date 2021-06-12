import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.redAccent.shade400,
          )),
      home: RandomWord(),
    );
  }
}

class RandomWord extends StatefulWidget {
  @override
  _RandomWordState createState() => _RandomWordState();
}

class _RandomWordState extends State<RandomWord> {
  final _suggestion = <WordPair>[];
  final _saved = <WordPair>{};
  final _bigFont = const TextStyle(
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feeds'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            iconSize: 30.0,
            color: Colors.black87,
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: _buildSuggestion(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          Padding(padding: EdgeInsets.all(30));
          Divider(
            color: Colors.white,
          );
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                tileColor: Colors.grey,
                title: Text(
                  pair.asPascalCase,
                  style: _bigFont,
                ),
                trailing: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }

  @override
  Widget _buildSuggestion() {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          if (index >= _suggestion.length) {
            _suggestion.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestion[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _saved.contains(pair);
    return ListTile(
      tileColor: Colors.amber,
      title: Text(
        pair.asPascalCase,
        style: _bigFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_alreadySaved) {
            _saved.remove(pair);
          } else
            _saved.add(pair);
        });
      },
    );
  }
}
