import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ono/aboutus.dart';
import 'package:ono/committee1.dart';
import 'package:ono/contact.dart';
import 'package:ono/exhibitors.dart';
import 'package:ono/login.dart';
import 'package:ono/profile.dart';
import 'package:ono/speakers.dart';
import 'package:ono/venue.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const Dashboard());
}


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(),
    viewProfilePage(),
    MyHomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      // Logout tapped
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(), // Assuming LoginPage is your login page
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _selectedIndex == 0 ? AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/Quantum_Logo.png',
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8), // Add some space between the image and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quantum Paradigm',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) : null,
        body: _pages[_selectedIndex],
        bottomNavigationBar: (_pages[_selectedIndex] is MyHomePage || _pages[_selectedIndex] is viewProfilePage) ?
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login_outlined),
              label: 'Logout',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.red,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ) : null,
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
            SizedBox(
              // height: 250,
              // width: 250,
              child: Image.asset(
                'assets/abc.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                  children: [
                    ItemDashboard(
                      title: 'About Us',
                      iconData: CupertinoIcons.phone,
                      background: Colors.blueAccent,
                      onTap: AboutUspage(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                    ItemDashboard(
                      title: 'Committee',
                      iconData: CupertinoIcons.person_2_fill,
                      background: Colors.green,
                      onTap: Committee1Page(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                    ItemDashboard(
                      title: 'Speakers',
                      iconData: CupertinoIcons.person_3,
                      background: Colors.purple,
                      onTap: SpeakerPage(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                    ItemDashboard(
                      title: 'Exhibitors',
                      iconData: CupertinoIcons.person_alt,
                      background: Colors.black45,
                      onTap: ExhibitorsPage(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                    ItemDashboard(
                      title: 'Venue',
                      iconData: CupertinoIcons.location_solid,
                      background: Colors.brown,
                      onTap: Venuepage(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                    ItemDashboard(
                      title: 'Contact Us',
                      iconData: CupertinoIcons.profile_circled,
                      background: Colors.deepOrange,
                      onTap: Contactpage(),
                      titleTextStyle: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 20),
          ]
      ),
    );
  }
}
class ItemDashboard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color background;
  final dynamic onTap;
  final TextStyle titleTextStyle;

  const ItemDashboard({
    required this.title,
    required this.iconData,
    required this.background,
    required this.onTap,
    required this.titleTextStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => onTap),
        );
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: titleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

