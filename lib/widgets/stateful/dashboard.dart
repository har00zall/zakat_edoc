import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/helpers/logout_helper.dart';
import 'package:zakat_edoc/route.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoggingOut = false;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeDashboard(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: OutlinedButton.icon(
              onPressed: null,
              label: Text(userSession.length == 0
                  ? ""
                  : userSession.getAt(0)!.userData.displayName),
              icon: Icon(Icons.person),
            ),
          )
        ],
        elevation: 2.5,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 35,
                child: FilledButton.icon(
                  onPressed: isLoggingOut ? null : tryLogout,
                  label: Text("Log Out"),
                  icon: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tryLogout() {
    setState(() {
      isLoggingOut = true;
    });

    LogoutHelper.logout();
    backToLogin();
  }

  void backToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        Row(
          spacing: 15,
          children: [
            ReportCard(
              title: "Total Muzakki",
              data: "15",
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            ReportCard(
              title: "Zakat Terkumpul (Uang)",
              data: "Rp. 125.000,00",
              backgroundColor: Theme.of(context).highlightColor,
            ),
            ReportCard(
              title: "Zakat Terkumpul (Beras)",
              data: "12 Kg",
              backgroundColor: Theme.of(context).hoverColor,
            ),
          ],
        )
      ],
    );
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard(
      {super.key,
      required this.title,
      required this.data,
      required this.backgroundColor});

  final String title;
  final String data;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              data,
              style: GoogleFonts.rubik(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
