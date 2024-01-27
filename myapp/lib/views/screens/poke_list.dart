import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/poke_list/poke_list_item.dart';
import '../../models/pokemon.dart';
import '../../const/pokeapi.dart';
import '../../models/favorite.dart';

class PokeList extends StatefulWidget {
  const PokeList({super.key});
  @override
  _PokeListState createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  bool isFavoriteMode = false;
  int _currentPage = 1;

  int itemCount(int page, List<Favorite> favs) {
    int ret = page * pageSize;
    if (isFavoriteMode && ret > favs.length) {
      ret = favs.length;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(int index, List<Favorite> favs) {
    int ret = index + 1;
    if (isFavoriteMode) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  bool isLastPage(int page, List<Favorite> favs) {
    if (isFavoriteMode) {
      return page * pageSize >= favs.length;
    } else {
      return page * pageSize >= pokeMaxId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          Container(
            height: 24,
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.auto_awesome_outlined),
              onPressed: () async {
                var ret = await showModalBottomSheet<bool>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),
                  builder: (BuildContext context) {
                    return ViewModeBottomSheet(
                      favMode: isFavoriteMode,
                    );
                  },
                );
                if (ret != null && ret) {
                  setState(() => isFavoriteMode = !isFavoriteMode);
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if (itemCount(_currentPage, favs.favs) == 0) {
                  return const Text('no data');
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    itemCount: itemCount(_currentPage, favs.favs) + 1,
                    itemBuilder: (context, index) {
                      if (index == itemCount(_currentPage, favs.favs)) {
                        return OutlinedButton(
                          child: const Text('more'),
                          onPressed: isLastPage(_currentPage, favs.favs)
                            ? null
                            : () => {
                              setState(
                                () => _currentPage++,
                              )
                          },
                        );
                      } else {
                        return PokeListItem(
                          poke: pokes.byId(itemId(index, favs.favs))
                        );
                      };
                    },
                  );
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({super.key, required this.favMode});
  final bool favMode;

  String mainText(bool fav) {
    if (fav) {
      return 'お気に入りのポケモンが表示されています';
    } else {
      return 'すべてのポケモンが表示されています';
    }
  }

  String menuTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String menuSubtitle(bool fav) {
    if (fav) {
      return 'すべてのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).backgroundColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                mainText(favMode),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(menuTitle(favMode)),
              subtitle: Text(menuSubtitle(favMode)),
              onTap: () {
                Navigator.pop(context, true);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
