import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Image.asset(
          'assets/logos/main.jpg',
          height: 110,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: '',
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Attendance Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
