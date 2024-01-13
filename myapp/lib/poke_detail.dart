import 'package:flutter/material.dart';

class PokeDetail extends StatelessWidget {
  const PokeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "No.25",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Pikachu",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              )
            ),
            Chip(
              label: Text('electric'),
              backgroundColor: Colors.yellow,
            ),
          ]
        ),
      ),
    );
  }
}
