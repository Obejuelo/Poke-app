import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapp/pokedetail.dart';
import 'dart:convert';

import 'package:pokeapp/pokemon.dart';

void main() => runApp(MaterialApp(
      title: 'Poke App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

  PokeHub pokehub;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodeJson = jsonDecode(res.body);
    pokehub = PokeHub.fromJson(decodeJson);
    // print(pokehub.toJson());
    // print('resstart');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poke App'),
        backgroundColor: Colors.cyan,
      ),
      body: pokehub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokehub.pokemon
                  .map(
                    (poke) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PokeDetail(poke)));
                            },
                            child: Hero(
                                tag: poke.img,
                                child: Card(
                                  elevation: 3.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(poke.img),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        poke.name,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                  )
                  .toList(),
            ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.cyan,
        onPressed: fetchData,
      ),
    );
  }
}
