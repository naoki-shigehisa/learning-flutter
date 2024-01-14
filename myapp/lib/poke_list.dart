import 'package:flutter/material.dart';
import './poke_list_item.dart';

class PokeList extends StatelessWidget {
  const PokeList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10000,
      itemBuilder: (context, index) => PokeListItem(index: index),
    );
  }
}
