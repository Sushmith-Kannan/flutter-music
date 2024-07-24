import 'package:flutter/material.dart';
import 'package:try_app/pages/artistpage.dart';
import 'package:try_app/pages/musicplayer.dart';
import 'package:try_app/pages/settingspage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
              child: Center(
            child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
                title: Text(
                  "A R T I S T S",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistsScreen(),
                      ));
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
            ),
            child: ListTile(
                title: Text(
                  "S E T T I N G S",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settingspage(),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
