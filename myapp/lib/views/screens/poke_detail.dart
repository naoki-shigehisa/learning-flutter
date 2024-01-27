import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pokemon.dart';
import '../../const/pokeapi.dart';
import '../../models/favorite.dart';

class PokeDetail extends StatelessWidget {
  const PokeDetail({super.key, required this.poke});
  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesNotifier>(
      builder: (context, favs, child) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                trailing: IconButton(
                  icon: favs.isExist(poke.id)
                    ? const Icon(Icons.star, color: Colors.orangeAccent)
                    : const Icon(Icons.star_outline),
                  onPressed: () => {
                    favs.toggle(Favorite(pokeId: poke.id)),
                  },
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Image.network(
                      poke.imageUrl,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'No.${poke.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                poke.name,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: poke.types.map((type) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Chip(
                    backgroundColor: pokeTypeColors[type] ?? Colors.grey,
                    label: Text(
                      type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (pokeTypeColors[type] ?? Colors.grey).computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      ),
                    ),
                  ),
                )).toList(),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
