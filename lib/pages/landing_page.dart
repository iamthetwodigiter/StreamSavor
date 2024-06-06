import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/profile.dart';
import 'package:streamsavor/pages/home_page.dart';
import 'package:streamsavor/pages/search_page.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();

  // List of Screens
  final List<Widget> _screens = [
    const HomePage(),
    SearchPage(),
    Profile(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        Provider.of<DarkModeProvider>(context, listen: true).darkMode;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkMode ? Colors.black : Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: darkMode ? Colors.grey : Colors.grey[600],

        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        showUnselectedLabels: true,
        unselectedIconTheme: const IconThemeData(size: 20),
        enableFeedback: true,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: darkMode ? Colors.black : Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_rounded),
            label: 'Search',
            backgroundColor: darkMode ? Colors.black : Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: 'Profile',
            backgroundColor: darkMode ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}
