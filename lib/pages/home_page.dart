import 'package:flutter/material.dart';
import 'package:inicioestudotroneio/models/game_model.dart';
import 'package:inicioestudotroneio/pages/add_game_page.dart';
import 'package:inicioestudotroneio/pages/game_information_page.dart';
import 'package:inicioestudotroneio/sql/sqflite_helper.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameModel> _gamesList = [];

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jogos',
        ),
      ),
      body: _gamesList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videogame_asset_outlined,
                    size: 200,
                    color: Colors.purple,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ainda não existe Jogos",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: _gamesList.length,
                itemBuilder: ((context, index) {
                  final game = _gamesList[index];
                  return Container(
                    width: 200,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 10,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                game.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                game.date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              game.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => GameInformationPage(
                                      id: game.id,
                                        )),
                                  ),
                                ).then(
                                  (value) => loadGames(),
                                );
                              },
                              child: const Text(
                                'Ver Games',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGame()),
          ).then(
            (value) => loadGames(),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> loadGames() async {
    final data = await SqlHelper.getItems();

    setState(() {
      _gamesList = data.map((e) => GameModel.fromJson(e)).toList();
    });
  }
}
