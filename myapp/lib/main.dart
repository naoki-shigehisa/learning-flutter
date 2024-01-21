import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './poke_list.dart';
import './poke_list_item.dart';
import './settings.dart';
import './theme_mode_selection_page.dart';
import './models/theme_mode.dart';
import './models/pokemon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModeNotifier = ThemeModeNotifier(pref);
  final pokemonsNotifier = PokemonsNotifier();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeModeNotifier>(create: (context) => themeModeNotifier),
      ChangeNotifierProvider<PokemonsNotifier>(create: (context) => pokemonsNotifier),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => MaterialApp(
        title: 'Pokemon Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: mode.mode,
        home: const TopPage(),
      ),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentbnb == 0 ? const PokeList() : const Settings(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(
            () => currentbnb = index,
          )
        },
        currentIndex: currentbnb,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
    );
  }
}
