import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/poke_list/poke_grid_item.dart';
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
  bool isGridMode = false;
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

  void changeFavMode(bool currentMode) {
    setState(() => isFavoriteMode = !currentMode);
  }

  void changeGridMode(bool currentMode) {
    setState(() => isGridMode = !currentMode);
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
                await showModalBottomSheet<bool>(
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
                      gridMode: isGridMode,
                      changeFavMode: changeFavMode,
                      changeGridMode: changeGridMode,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if (itemCount(_currentPage, favs.favs) == 0) {
                  return const Text('no data');
                } else {
                  if (isGridMode) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: itemCount(_currentPage, favs.favs) + 1,
                      itemBuilder: (context, index) {
                        if (index == itemCount(_currentPage, favs.favs)) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: OutlinedButton(
                              child: const Text('more'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: isLastPage(_currentPage, favs.favs)
                                ? null
                                : () => {
                                  setState(
                                    () => _currentPage++,
                                  )
                              },
                            ),
                          );
                        } else {
                          return PokeGridItem(
                            poke: pokes.byId(itemId(index, favs.favs))
                          );
                        };
                      },
                    );
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
  const ViewModeBottomSheet({
    super.key,
    required this.favMode,
    required this.gridMode,
    required this.changeFavMode,
    required this.changeGridMode,
  });
  final bool favMode;
  final bool gridMode;
  final Function(bool) changeFavMode;
  final Function(bool) changeGridMode;

  String mainText(bool fav) {
    return '表示設定';
  }

  String menuFavTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String menuFavSubtitle(bool fav) {
    if (fav) {
      return 'すべてのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  String menuGridTitle(bool grid) {
    if (grid) {
      return 'リスト表示に切り替え';
    } else {
      return 'グリッド表示に切り替え';
    }
  }

  String menuGridSubtitle(bool grid) {
    if (grid) {
      return 'ポケモンをリスト表示します';
    } else {
      return 'ポケモンをグリッド表示します';
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
              title: Text(menuFavTitle(favMode)),
              subtitle: Text(menuFavSubtitle(favMode)),
              onTap: () {
                changeFavMode(favMode);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3),
              title: Text(menuGridTitle(gridMode)),
              subtitle: Text(menuGridSubtitle(gridMode)),
              onTap: () {
                changeGridMode(gridMode);
                Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
