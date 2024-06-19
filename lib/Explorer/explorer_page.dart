import 'package:flutter/material.dart';
import 'package:pc_part/cart/cart.dart';
import '../Account/account_page.dart';
import '../Sections/SectionPage.dart';
import '../Settings/SettingsPage.dart';
import 'ExplorerContentPage.dart';

class ExplorerPage extends StatefulWidget {
  final String userID;

  ExplorerPage({required this.userID});

  @override
  _ExplorerPageState createState() => _ExplorerPageState(userID: userID);
}

class _ExplorerPageState extends State<ExplorerPage> {
  late PageController _pageController;
  int _currentIndex = 2;
  final String userID;

  _ExplorerPageState({required this.userID});

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/assets/user.png'),
          ),

        ),
      ),
      title: Text('PC Part'),

    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      children: [
        AccountPage(userID: userID),
        BasketPage(userID:userID),
        ExplorerContentPage(userID: userID),
        SectionPage(userID: userID),
        SettingsPage(userID: userID),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _pageController.jumpToPage(index);
      },
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedLabelStyle: TextStyle(color: Colors.black),
      items: [
        _buildBottomNavigationBarItem('lib/assets/user.png', 'Account', 0),
        _buildBottomNavigationBarItem('lib/assets/shopping-basket.png', 'Basket', 1),
        _buildBottomNavigationBarItem('lib/assets/explore.png', 'Explorer', 2),
        _buildBottomNavigationBarItem('lib/assets/compass.png', 'Section', 3),
        _buildBottomNavigationBarItem('lib/assets/sett.jpg', 'Settings', 4)
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String imagePath, String label, int index) {
    return BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          _pageController.jumpToPage(index);
        },
        child: Image.asset(imagePath, width: 24, height: 24),
      ),
      label: label,
    );
  }
}
