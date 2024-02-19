import 'package:flutter/material.dart';
import 'package:pppi/daybook/add_record.dart';
import 'package:pppi/daybook/daybook.dart';
import 'package:pppi/home/home.dart';

class daybookDrawer extends StatefulWidget {
  const daybookDrawer({super.key});

  @override
  State<daybookDrawer> createState() => _daybookDrawerState();
}

class _daybookDrawerState extends State<daybookDrawer> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => home(),
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.book,
            color: Colors.white,
          ),
          title: Text(
            'Daybook Records',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 1, 41, 46),
          centerTitle: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => add_record()));
                },
                leading: const Icon(
                  Icons.note_add_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Add Dyabook Records',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'Add records of daily expenses ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DaybookHistoryScreen()));
                },
                leading: const Icon(
                  Icons.import_export_rounded,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Daybook History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'View Expenses Records',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
