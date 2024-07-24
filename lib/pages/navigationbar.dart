import 'package:flutter/material.dart';
import 'package:try_app/components/my_drawer.dart';
import 'package:try_app/pages/First.dart';
import 'package:try_app/pages/artistpage.dart';
import 'package:try_app/pages/searchpage.dart';
import 'package:try_app/pages/settingspage.dart';
import 'package:try_app/pages/track.dart'; // Ensure this import is correct

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  // Replace these dummy values with your actual data
  final List<Track> _initialTracks =
      []; // Initialize this with actual tracks if needed

  // Function to handle track selection
  void _onTrackSelected(Track track) {
    // Handle track selection, e.g., update player or navigate to player page
  }

  static List<Widget> _widgetOptions = <Widget>[
    ArtistsScreen(),
    // Initialize SearchPage with required parameters
    SearchPage(
      initialTracks: [], // Provide the initial tracks here if needed
      onTrackSelected: (track) {
        // Handle track selection here, e.g., show in player
      },
    ),
    First(),
    Settingspage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: 'Home',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: 'Search',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: 'Library',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: 'Settings',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: _onItemTapped,
      ),
    );
  }
}
