import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme_mode_selection_page.dart';
import './models/theme_mode.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text('Dark/Lignt Mode'),
            trailing: Text((mode.mode == ThemeMode.system
                ? 'System'
                : mode.mode == ThemeMode.light
                    ? 'Light'
                    : 'Dark'
            )),
            onTap: () async {
              final ret = await Navigator.of(context).push<ThemeMode>(
                MaterialPageRoute(
                  builder: (context) => ThemeModeSelectionPage(init: mode.mode),
                ),
              );
              mode.update(ret!);
            },
          ),
        ],
      ),
    );
  }
}
