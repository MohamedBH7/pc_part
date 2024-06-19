import 'package:flutter/material.dart';
import 'package:pc_part/Login/Login.dart';
import 'package:pc_part/Welcome-intro/FirstScreen%20.dart';
import 'package:pc_part/Welcome-intro/SecondScreen%20.dart';
import 'package:pc_part/Welcome-intro/ThirdScreen%20.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Welcome-intro/page_indicator_row.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pc Part ',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Welcome To Our Pc Parts App '),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    bool hasSeenScreens = _prefs.getBool('hasSeenScreens') ?? false;

    if (!hasSeenScreens) {
      _prefs.setBool('hasSeenScreens', true);
    } else {
      _navigateToMainScreen();
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Login(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  FirstScreen(),
                  SecondScreen(),
                  ThirdScreen(),
                ],
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return PageIndicatorRow(
      currentPage: _currentPage,
      totalPageCount: 3,
    );
  }
}
