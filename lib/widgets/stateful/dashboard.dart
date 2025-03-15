import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    HomeDashboard(),
    AdminSettings(),
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
              onPressed: () {
                _onItemTapped(1);
              },
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
              title: const Text('Admin Settings'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
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
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
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
    // print("Route name: ${ModalRoute.of(context)?.settings.name}");
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
              backgroundColor: Colors.cyan[50]!,
            ),
            ReportCard(
              title: "Zakat Terkumpul (Beras)",
              data: "12 Kg",
              backgroundColor: Colors.teal[50]!,
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: SizedBox(
              height: 35,
              child: FilledButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addMuzakki),
                  );
                },
                label: Text("Tambahkan Muzakki"),
                icon: Icon(Icons.add),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.replay_outlined),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    showDialog(
                      context: context,
                      builder: (v) {
                        return AlertDialog(
                          icon: Icon(Icons.delete),
                          title: Text(
                              "Are you sure want to delete all entry ?\nThis action can't be undone"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await muzakkiData.clear();
                                setState(() {});
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (v) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text("Delete All"),
                  ),
                ],
              ),
            ),
          ],
        ),
        Table(
          defaultColumnWidth: FixedColumnWidth(300),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                TableHeader(title: "No."),
                TableHeader(title: "Muzakki"),
                TableHeader(title: "Jenis Zakat"),
                TableHeader(title: "Jumlah")
              ],
            ),
            ...List<TableRow>.generate(
              muzakkiData.length,
              (index) {
                return TableRow(
                  decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.white : Colors.grey[200]),
                  children: [
                    TableRowTextChild(title: (index + 1).toString()),
                    TableRowTextChild(title: muzakkiData.getAt(index)!.name),
                    TableRowTextChild(
                        title: muzakkiData.getAt(index)!.zakatType.toString()),
                    TableRowTextChild(
                        title:
                            "${muzakkiData.getAt(index)!.zakatType == ZakatType.uang ? "Rp." : ""} ${muzakkiData.getAt(index)!.amount} ${muzakkiData.getAt(index)!.zakatType == ZakatType.beras ? "(Kg)" : ""}"),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "Admin Settings",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Table(
          children: [
            TableRow(
              children: tableHeader(
                ["Ketua BKM", "Ketua 'Amil", "Sekretaris"],
              ),
            ),
            TableRow(
              children: tableTextFieldItem(
                ["Ketua BKM", "Ketua 'Amil", "Sekretaris"],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 45,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: FilledButton.icon(
              onPressed: () {},
              label: Text("Simpan"),
              icon: Icon(Icons.save),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> tableHeader(List<String> headerTitle) {
    return List.generate(headerTitle.length, (index) {
      return TableHeader(title: headerTitle[index]);
    });
  }

  List<Widget> tableTextFieldItem(List<String> placeholders) {
    return List.generate(placeholders.length, (index) {
      return TableRowChild(placeholder: placeholders[index]);
    });
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ));
  }
}

class TableRowChild extends StatelessWidget {
  const TableRowChild({super.key, required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        decoration: InputDecoration(
          hintText: placeholder,
        ),
      ),
    );
  }
}

class TableRowTextChild extends StatelessWidget {
  const TableRowTextChild({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          fontSize: 13,
        ),
      ),
    ));
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
              blurRadius: 2.5,
              spreadRadius: 0,
            ),
          ],
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
